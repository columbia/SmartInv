1 // Full Contract Sources : https://github.com/DigixGlobal/dao-contracts
2 // File: @digix/cacp-contracts-dao/contracts/ACOwned.sol
3 pragma solidity ^0.4.25;
4 
5 /// @title Owner based access control
6 /// @author DigixGlobal
7 contract ACOwned {
8 
9   address public owner;
10   address public new_owner;
11   bool is_ac_owned_init;
12 
13   /// @dev Modifier to check if msg.sender is the contract owner
14   modifier if_owner() {
15     require(is_owner());
16     _;
17   }
18 
19   function init_ac_owned()
20            internal
21            returns (bool _success)
22   {
23     if (is_ac_owned_init == false) {
24       owner = msg.sender;
25       is_ac_owned_init = true;
26     }
27     _success = true;
28   }
29 
30   function is_owner()
31            private
32            constant
33            returns (bool _is_owner)
34   {
35     _is_owner = (msg.sender == owner);
36   }
37 
38   function change_owner(address _new_owner)
39            if_owner()
40            public
41            returns (bool _success)
42   {
43     new_owner = _new_owner;
44     _success = true;
45   }
46 
47   function claim_ownership()
48            public
49            returns (bool _success)
50   {
51     require(msg.sender == new_owner);
52     owner = new_owner;
53     _success = true;
54   }
55 
56 }
57 
58 // File: @digix/cacp-contracts-dao/contracts/Constants.sol
59 pragma solidity ^0.4.25;
60 
61 /// @title Some useful constants
62 /// @author DigixGlobal
63 contract Constants {
64   address constant NULL_ADDRESS = address(0x0);
65   uint256 constant ZERO = uint256(0);
66   bytes32 constant EMPTY = bytes32(0x0);
67 }
68 
69 // File: @digix/cacp-contracts-dao/contracts/ContractResolver.sol
70 pragma solidity ^0.4.25;
71 
72 /// @title Contract Name Registry
73 /// @author DigixGlobal
74 contract ContractResolver is ACOwned, Constants {
75 
76   mapping (bytes32 => address) contracts;
77   bool public locked_forever;
78 
79   modifier unless_registered(bytes32 _key) {
80     require(contracts[_key] == NULL_ADDRESS);
81     _;
82   }
83 
84   modifier if_owner_origin() {
85     require(tx.origin == owner);
86     _;
87   }
88 
89   /// Function modifier to check if msg.sender corresponds to the resolved address of a given key
90   /// @param _contract The resolver key
91   modifier if_sender_is(bytes32 _contract) {
92     require(msg.sender == get_contract(_contract));
93     _;
94   }
95 
96   modifier if_not_locked() {
97     require(locked_forever == false);
98     _;
99   }
100 
101   /// @dev ContractResolver constructor will perform the following: 1. Set msg.sender as the contract owner.
102   constructor() public
103   {
104     require(init_ac_owned());
105     locked_forever = false;
106   }
107 
108   /// @dev Called at contract initialization
109   /// @param _key bytestring for CACP name
110   /// @param _contract_address The address of the contract to be registered
111   /// @return _success if the operation is successful
112   function init_register_contract(bytes32 _key, address _contract_address)
113            if_owner_origin()
114            if_not_locked()
115            unless_registered(_key)
116            public
117            returns (bool _success)
118   {
119     require(_contract_address != NULL_ADDRESS);
120     contracts[_key] = _contract_address;
121     _success = true;
122   }
123 
124   /// @dev Lock the resolver from any further modifications.  This can only be called from the owner
125   /// @return _success if the operation is successful
126   function lock_resolver_forever()
127            if_owner
128            public
129            returns (bool _success)
130   {
131     locked_forever = true;
132     _success = true;
133   }
134 
135   /// @dev Get address of a contract
136   /// @param _key the bytestring name of the contract to look up
137   /// @return _contract the address of the contract
138   function get_contract(bytes32 _key)
139            public
140            view
141            returns (address _contract)
142   {
143     require(contracts[_key] != NULL_ADDRESS);
144     _contract = contracts[_key];
145   }
146 
147 }
148 
149 // File: @digix/cacp-contracts-dao/contracts/ResolverClient.sol
150 pragma solidity ^0.4.25;
151 
152 /// @title Contract Resolver Interface
153 /// @author DigixGlobal
154 contract ResolverClient {
155 
156   /// The address of the resolver contract for this project
157   address public resolver;
158   bytes32 public key;
159 
160   /// Make our own address available to us as a constant
161   address public CONTRACT_ADDRESS;
162 
163   /// Function modifier to check if msg.sender corresponds to the resolved address of a given key
164   /// @param _contract The resolver key
165   modifier if_sender_is(bytes32 _contract) {
166     require(sender_is(_contract));
167     _;
168   }
169 
170   function sender_is(bytes32 _contract) internal view returns (bool _isFrom) {
171     _isFrom = msg.sender == ContractResolver(resolver).get_contract(_contract);
172   }
173 
174   modifier if_sender_is_from(bytes32[3] _contracts) {
175     require(sender_is_from(_contracts));
176     _;
177   }
178 
179   function sender_is_from(bytes32[3] _contracts) internal view returns (bool _isFrom) {
180     uint256 _n = _contracts.length;
181     for (uint256 i = 0; i < _n; i++) {
182       if (_contracts[i] == bytes32(0x0)) continue;
183       if (msg.sender == ContractResolver(resolver).get_contract(_contracts[i])) {
184         _isFrom = true;
185         break;
186       }
187     }
188   }
189 
190   /// Function modifier to check resolver's locking status.
191   modifier unless_resolver_is_locked() {
192     require(is_locked() == false);
193     _;
194   }
195 
196   /// @dev Initialize new contract
197   /// @param _key the resolver key for this contract
198   /// @return _success if the initialization is successful
199   function init(bytes32 _key, address _resolver)
200            internal
201            returns (bool _success)
202   {
203     bool _is_locked = ContractResolver(_resolver).locked_forever();
204     if (_is_locked == false) {
205       CONTRACT_ADDRESS = address(this);
206       resolver = _resolver;
207       key = _key;
208       require(ContractResolver(resolver).init_register_contract(key, CONTRACT_ADDRESS));
209       _success = true;
210     }  else {
211       _success = false;
212     }
213   }
214 
215   /// @dev Check if resolver is locked
216   /// @return _locked if the resolver is currently locked
217   function is_locked()
218            private
219            view
220            returns (bool _locked)
221   {
222     _locked = ContractResolver(resolver).locked_forever();
223   }
224 
225   /// @dev Get the address of a contract
226   /// @param _key the resolver key to look up
227   /// @return _contract the address of the contract
228   function get_contract(bytes32 _key)
229            public
230            view
231            returns (address _contract)
232   {
233     _contract = ContractResolver(resolver).get_contract(_key);
234   }
235 }
236 
237 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
238 pragma solidity ^0.4.24;
239 
240 /**
241  * @title SafeMath
242  * @dev Math operations with safety checks that throw on error
243  */
244 library SafeMath {
245 
246   /**
247   * @dev Multiplies two numbers, throws on overflow.
248   */
249   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
250     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
251     // benefit is lost if 'b' is also tested.
252     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
253     if (_a == 0) {
254       return 0;
255     }
256 
257     c = _a * _b;
258     assert(c / _a == _b);
259     return c;
260   }
261 
262   /**
263   * @dev Integer division of two numbers, truncating the quotient.
264   */
265   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
266     // assert(_b > 0); // Solidity automatically throws when dividing by 0
267     // uint256 c = _a / _b;
268     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
269     return _a / _b;
270   }
271 
272   /**
273   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
274   */
275   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
276     assert(_b <= _a);
277     return _a - _b;
278   }
279 
280   /**
281   * @dev Adds two numbers, throws on overflow.
282   */
283   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
284     c = _a + _b;
285     assert(c >= _a);
286     return c;
287   }
288 }
289 
290 // File: contracts/lib/MathHelper.sol
291 pragma solidity ^0.4.25;
292 
293 library MathHelper {
294 
295   using SafeMath for uint256;
296 
297   function max(uint256 a, uint256 b) internal pure returns (uint256 _max){
298       _max = b;
299       if (a > b) {
300           _max = a;
301       }
302   }
303 
304   function min(uint256 a, uint256 b) internal pure returns (uint256 _min){
305       _min = b;
306       if (a < b) {
307           _min = a;
308       }
309   }
310 
311   function sumNumbers(uint256[] _numbers) internal pure returns (uint256 _sum) {
312       for (uint256 i=0;i<_numbers.length;i++) {
313           _sum = _sum.add(_numbers[i]);
314       }
315   }
316 }
317 
318 // File: @digix/solidity-collections/contracts/abstract/AddressIteratorInteractive.sol
319 pragma solidity ^0.4.19;
320 /**
321   @title Address Iterator Interactive
322   @author DigixGlobal Pte Ltd
323 */
324 contract AddressIteratorInteractive {
325 
326   /**
327     @notice Lists a Address collection from start or end
328     @param _count Total number of Address items to return
329     @param _function_first Function that returns the First Address item in the list
330     @param _function_last Function that returns the last Address item in the list
331     @param _function_next Function that returns the Next Address item in the list
332     @param _function_previous Function that returns previous Address item in the list
333     @param _from_start whether to read from start (or end) of the list
334     @return {"_address_items" : "Collection of reversed Address list"}
335   */
336   function list_addresses(uint256 _count,
337                                  function () external constant returns (address) _function_first,
338                                  function () external constant returns (address) _function_last,
339                                  function (address) external constant returns (address) _function_next,
340                                  function (address) external constant returns (address) _function_previous,
341                                  bool _from_start)
342            internal
343            constant
344            returns (address[] _address_items)
345   {
346     if (_from_start) {
347       _address_items = private_list_addresses_from_address(_function_first(), _count, true, _function_last, _function_next);
348     } else {
349       _address_items = private_list_addresses_from_address(_function_last(), _count, true, _function_first, _function_previous);
350     }
351   }
352 
353 
354 
355   /**
356     @notice Lists a Address collection from some `_current_item`, going forwards or backwards depending on `_from_start`
357     @param _current_item The current Item
358     @param _count Total number of Address items to return
359     @param _function_first Function that returns the First Address item in the list
360     @param _function_last Function that returns the last Address item in the list
361     @param _function_next Function that returns the Next Address item in the list
362     @param _function_previous Function that returns previous Address item in the list
363     @param _from_start whether to read in the forwards ( or backwards) direction
364     @return {"_address_items" :"Collection/list of Address"}
365   */
366   function list_addresses_from(address _current_item, uint256 _count,
367                                 function () external constant returns (address) _function_first,
368                                 function () external constant returns (address) _function_last,
369                                 function (address) external constant returns (address) _function_next,
370                                 function (address) external constant returns (address) _function_previous,
371                                 bool _from_start)
372            internal
373            constant
374            returns (address[] _address_items)
375   {
376     if (_from_start) {
377       _address_items = private_list_addresses_from_address(_current_item, _count, false, _function_last, _function_next);
378     } else {
379       _address_items = private_list_addresses_from_address(_current_item, _count, false, _function_first, _function_previous);
380     }
381   }
382 
383 
384   /**
385     @notice a private function to lists a Address collection starting from some `_current_item` (which could be included or excluded), in the forwards or backwards direction
386     @param _current_item The current Item
387     @param _count Total number of Address items to return
388     @param _including_current Whether the `_current_item` should be included in the result
389     @param _function_last Function that returns the address where we stop reading more address
390     @param _function_next Function that returns the next address to read after some address (could be backwards or forwards in the physical collection)
391     @return {"_address_items" :"Collection/list of Address"}
392   */
393   function private_list_addresses_from_address(address _current_item, uint256 _count, bool _including_current,
394                                  function () external constant returns (address) _function_last,
395                                  function (address) external constant returns (address) _function_next)
396            private
397            constant
398            returns (address[] _address_items)
399   {
400     uint256 _i;
401     uint256 _real_count = 0;
402     address _last_item;
403 
404     _last_item = _function_last();
405     if (_count == 0 || _last_item == address(0x0)) {
406       _address_items = new address[](0);
407     } else {
408       address[] memory _items_temp = new address[](_count);
409       address _this_item;
410       if (_including_current == true) {
411         _items_temp[0] = _current_item;
412         _real_count = 1;
413       }
414       _this_item = _current_item;
415       for (_i = _real_count; (_i < _count) && (_this_item != _last_item);_i++) {
416         _this_item = _function_next(_this_item);
417         if (_this_item != address(0x0)) {
418           _real_count++;
419           _items_temp[_i] = _this_item;
420         }
421       }
422 
423       _address_items = new address[](_real_count);
424       for(_i = 0;_i < _real_count;_i++) {
425         _address_items[_i] = _items_temp[_i];
426       }
427     }
428   }
429 
430 
431   /** DEPRECATED
432     @notice private function to list a Address collection starting from the start or end of the list
433     @param _count Total number of Address item to return
434     @param _function_total Function that returns the Total number of Address item in the list
435     @param _function_first Function that returns the First Address item in the list
436     @param _function_next Function that returns the Next Address item in the list
437     @return {"_address_items" :"Collection/list of Address"}
438   */
439   /*function list_addresses_from_start_or_end(uint256 _count,
440                                  function () external constant returns (uint256) _function_total,
441                                  function () external constant returns (address) _function_first,
442                                  function (address) external constant returns (address) _function_next)
443 
444            private
445            constant
446            returns (address[] _address_items)
447   {
448     uint256 _i;
449     address _current_item;
450     uint256 _real_count = _function_total();
451 
452     if (_count > _real_count) {
453       _count = _real_count;
454     }
455 
456     address[] memory _items_tmp = new address[](_count);
457 
458     if (_count > 0) {
459       _current_item = _function_first();
460       _items_tmp[0] = _current_item;
461 
462       for(_i = 1;_i <= (_count - 1);_i++) {
463         _current_item = _function_next(_current_item);
464         if (_current_item != address(0x0)) {
465           _items_tmp[_i] = _current_item;
466         }
467       }
468       _address_items = _items_tmp;
469     } else {
470       _address_items = new address[](0);
471     }
472   }*/
473 
474   /** DEPRECATED
475     @notice a private function to lists a Address collection starting from some `_current_item`, could be forwards or backwards
476     @param _current_item The current Item
477     @param _count Total number of Address items to return
478     @param _function_last Function that returns the bytes where we stop reading more bytes
479     @param _function_next Function that returns the next bytes to read after some bytes (could be backwards or forwards in the physical collection)
480     @return {"_address_items" :"Collection/list of Address"}
481   */
482   /*function list_addresses_from_byte(address _current_item, uint256 _count,
483                                  function () external constant returns (address) _function_last,
484                                  function (address) external constant returns (address) _function_next)
485            private
486            constant
487            returns (address[] _address_items)
488   {
489     uint256 _i;
490     uint256 _real_count = 0;
491 
492     if (_count == 0) {
493       _address_items = new address[](0);
494     } else {
495       address[] memory _items_temp = new address[](_count);
496 
497       address _start_item;
498       address _last_item;
499 
500       _last_item = _function_last();
501 
502       if (_last_item != _current_item) {
503         _start_item = _function_next(_current_item);
504         if (_start_item != address(0x0)) {
505           _items_temp[0] = _start_item;
506           _real_count = 1;
507           for(_i = 1;(_i <= (_count - 1)) && (_start_item != _last_item);_i++) {
508             _start_item = _function_next(_start_item);
509             if (_start_item != address(0x0)) {
510               _real_count++;
511               _items_temp[_i] = _start_item;
512             }
513           }
514           _address_items = new address[](_real_count);
515           for(_i = 0;_i <= (_real_count - 1);_i++) {
516             _address_items[_i] = _items_temp[_i];
517           }
518         } else {
519           _address_items = new address[](0);
520         }
521       } else {
522         _address_items = new address[](0);
523       }
524     }
525   }*/
526 
527 }
528 
529 // File: @digix/solidity-collections/contracts/abstract/BytesIteratorInteractive.sol
530 pragma solidity ^0.4.19;
531 /**
532   @title Bytes Iterator Interactive
533   @author DigixGlobal Pte Ltd
534 */
535 contract BytesIteratorInteractive {
536 
537   /**
538     @notice Lists a Bytes collection from start or end
539     @param _count Total number of Bytes items to return
540     @param _function_first Function that returns the First Bytes item in the list
541     @param _function_last Function that returns the last Bytes item in the list
542     @param _function_next Function that returns the Next Bytes item in the list
543     @param _function_previous Function that returns previous Bytes item in the list
544     @param _from_start whether to read from start (or end) of the list
545     @return {"_bytes_items" : "Collection of reversed Bytes list"}
546   */
547   function list_bytesarray(uint256 _count,
548                                  function () external constant returns (bytes32) _function_first,
549                                  function () external constant returns (bytes32) _function_last,
550                                  function (bytes32) external constant returns (bytes32) _function_next,
551                                  function (bytes32) external constant returns (bytes32) _function_previous,
552                                  bool _from_start)
553            internal
554            constant
555            returns (bytes32[] _bytes_items)
556   {
557     if (_from_start) {
558       _bytes_items = private_list_bytes_from_bytes(_function_first(), _count, true, _function_last, _function_next);
559     } else {
560       _bytes_items = private_list_bytes_from_bytes(_function_last(), _count, true, _function_first, _function_previous);
561     }
562   }
563 
564   /**
565     @notice Lists a Bytes collection from some `_current_item`, going forwards or backwards depending on `_from_start`
566     @param _current_item The current Item
567     @param _count Total number of Bytes items to return
568     @param _function_first Function that returns the First Bytes item in the list
569     @param _function_last Function that returns the last Bytes item in the list
570     @param _function_next Function that returns the Next Bytes item in the list
571     @param _function_previous Function that returns previous Bytes item in the list
572     @param _from_start whether to read in the forwards ( or backwards) direction
573     @return {"_bytes_items" :"Collection/list of Bytes"}
574   */
575   function list_bytesarray_from(bytes32 _current_item, uint256 _count,
576                                 function () external constant returns (bytes32) _function_first,
577                                 function () external constant returns (bytes32) _function_last,
578                                 function (bytes32) external constant returns (bytes32) _function_next,
579                                 function (bytes32) external constant returns (bytes32) _function_previous,
580                                 bool _from_start)
581            internal
582            constant
583            returns (bytes32[] _bytes_items)
584   {
585     if (_from_start) {
586       _bytes_items = private_list_bytes_from_bytes(_current_item, _count, false, _function_last, _function_next);
587     } else {
588       _bytes_items = private_list_bytes_from_bytes(_current_item, _count, false, _function_first, _function_previous);
589     }
590   }
591 
592   /**
593     @notice A private function to lists a Bytes collection starting from some `_current_item` (which could be included or excluded), in the forwards or backwards direction
594     @param _current_item The current Item
595     @param _count Total number of Bytes items to return
596     @param _including_current Whether the `_current_item` should be included in the result
597     @param _function_last Function that returns the bytes where we stop reading more bytes
598     @param _function_next Function that returns the next bytes to read after some bytes (could be backwards or forwards in the physical collection)
599     @return {"_address_items" :"Collection/list of Bytes"}
600   */
601   function private_list_bytes_from_bytes(bytes32 _current_item, uint256 _count, bool _including_current,
602                                  function () external constant returns (bytes32) _function_last,
603                                  function (bytes32) external constant returns (bytes32) _function_next)
604            private
605            constant
606            returns (bytes32[] _bytes32_items)
607   {
608     uint256 _i;
609     uint256 _real_count = 0;
610     bytes32 _last_item;
611 
612     _last_item = _function_last();
613     if (_count == 0 || _last_item == bytes32(0x0)) {
614       _bytes32_items = new bytes32[](0);
615     } else {
616       bytes32[] memory _items_temp = new bytes32[](_count);
617       bytes32 _this_item;
618       if (_including_current == true) {
619         _items_temp[0] = _current_item;
620         _real_count = 1;
621       }
622       _this_item = _current_item;
623       for (_i = _real_count; (_i < _count) && (_this_item != _last_item);_i++) {
624         _this_item = _function_next(_this_item);
625         if (_this_item != bytes32(0x0)) {
626           _real_count++;
627           _items_temp[_i] = _this_item;
628         }
629       }
630 
631       _bytes32_items = new bytes32[](_real_count);
632       for(_i = 0;_i < _real_count;_i++) {
633         _bytes32_items[_i] = _items_temp[_i];
634       }
635     }
636   }
637 
638 
639 
640 
641   ////// DEPRECATED FUNCTIONS (old versions)
642 
643   /**
644     @notice a private function to lists a Bytes collection starting from some `_current_item`, could be forwards or backwards
645     @param _current_item The current Item
646     @param _count Total number of Bytes items to return
647     @param _function_last Function that returns the bytes where we stop reading more bytes
648     @param _function_next Function that returns the next bytes to read after some bytes (could be backwards or forwards in the physical collection)
649     @return {"_bytes_items" :"Collection/list of Bytes"}
650   */
651   /*function list_bytes_from_bytes(bytes32 _current_item, uint256 _count,
652                                  function () external constant returns (bytes32) _function_last,
653                                  function (bytes32) external constant returns (bytes32) _function_next)
654            private
655            constant
656            returns (bytes32[] _bytes_items)
657   {
658     uint256 _i;
659     uint256 _real_count = 0;
660 
661     if (_count == 0) {
662       _bytes_items = new bytes32[](0);
663     } else {
664       bytes32[] memory _items_temp = new bytes32[](_count);
665 
666       bytes32 _start_item;
667       bytes32 _last_item;
668 
669       _last_item = _function_last();
670 
671       if (_last_item != _current_item) {
672         _start_item = _function_next(_current_item);
673         if (_start_item != bytes32(0x0)) {
674           _items_temp[0] = _start_item;
675           _real_count = 1;
676           for(_i = 1;(_i <= (_count - 1)) && (_start_item != _last_item);_i++) {
677             _start_item = _function_next(_start_item);
678             if (_start_item != bytes32(0x0)) {
679               _real_count++;
680               _items_temp[_i] = _start_item;
681             }
682           }
683           _bytes_items = new bytes32[](_real_count);
684           for(_i = 0;_i <= (_real_count - 1);_i++) {
685             _bytes_items[_i] = _items_temp[_i];
686           }
687         } else {
688           _bytes_items = new bytes32[](0);
689         }
690       } else {
691         _bytes_items = new bytes32[](0);
692       }
693     }
694   }*/
695 
696   /**
697     @notice private function to list a Bytes collection starting from the start or end of the list
698     @param _count Total number of Bytes item to return
699     @param _function_total Function that returns the Total number of Bytes item in the list
700     @param _function_first Function that returns the First Bytes item in the list
701     @param _function_next Function that returns the Next Bytes item in the list
702     @return {"_bytes_items" :"Collection/list of Bytes"}
703   */
704   /*function list_bytes_from_start_or_end(uint256 _count,
705                                  function () external constant returns (uint256) _function_total,
706                                  function () external constant returns (bytes32) _function_first,
707                                  function (bytes32) external constant returns (bytes32) _function_next)
708 
709            private
710            constant
711            returns (bytes32[] _bytes_items)
712   {
713     uint256 _i;
714     bytes32 _current_item;
715     uint256 _real_count = _function_total();
716 
717     if (_count > _real_count) {
718       _count = _real_count;
719     }
720 
721     bytes32[] memory _items_tmp = new bytes32[](_count);
722 
723     if (_count > 0) {
724       _current_item = _function_first();
725       _items_tmp[0] = _current_item;
726 
727       for(_i = 1;_i <= (_count - 1);_i++) {
728         _current_item = _function_next(_current_item);
729         if (_current_item != bytes32(0x0)) {
730           _items_tmp[_i] = _current_item;
731         }
732       }
733       _bytes_items = _items_tmp;
734     } else {
735       _bytes_items = new bytes32[](0);
736     }
737   }*/
738 }
739 
740 // File: @digix/solidity-collections/contracts/abstract/IndexedBytesIteratorInteractive.sol
741 pragma solidity ^0.4.19;
742 
743 /**
744   @title Indexed Bytes Iterator Interactive
745   @author DigixGlobal Pte Ltd
746 */
747 contract IndexedBytesIteratorInteractive {
748 
749   /**
750     @notice Lists an indexed Bytes collection from start or end
751     @param _collection_index Index of the Collection to list
752     @param _count Total number of Bytes items to return
753     @param _function_first Function that returns the First Bytes item in the list
754     @param _function_last Function that returns the last Bytes item in the list
755     @param _function_next Function that returns the Next Bytes item in the list
756     @param _function_previous Function that returns previous Bytes item in the list
757     @param _from_start whether to read from start (or end) of the list
758     @return {"_bytes_items" : "Collection of reversed Bytes list"}
759   */
760   function list_indexed_bytesarray(bytes32 _collection_index, uint256 _count,
761                               function (bytes32) external constant returns (bytes32) _function_first,
762                               function (bytes32) external constant returns (bytes32) _function_last,
763                               function (bytes32, bytes32) external constant returns (bytes32) _function_next,
764                               function (bytes32, bytes32) external constant returns (bytes32) _function_previous,
765                               bool _from_start)
766            internal
767            constant
768            returns (bytes32[] _indexed_bytes_items)
769   {
770     if (_from_start) {
771       _indexed_bytes_items = private_list_indexed_bytes_from_bytes(_collection_index, _function_first(_collection_index), _count, true, _function_last, _function_next);
772     } else {
773       _indexed_bytes_items = private_list_indexed_bytes_from_bytes(_collection_index, _function_last(_collection_index), _count, true, _function_first, _function_previous);
774     }
775   }
776 
777   /**
778     @notice Lists an indexed Bytes collection from some `_current_item`, going forwards or backwards depending on `_from_start`
779     @param _collection_index Index of the Collection to list
780     @param _current_item The current Item
781     @param _count Total number of Bytes items to return
782     @param _function_first Function that returns the First Bytes item in the list
783     @param _function_last Function that returns the last Bytes item in the list
784     @param _function_next Function that returns the Next Bytes item in the list
785     @param _function_previous Function that returns previous Bytes item in the list
786     @param _from_start whether to read in the forwards ( or backwards) direction
787     @return {"_bytes_items" :"Collection/list of Bytes"}
788   */
789   function list_indexed_bytesarray_from(bytes32 _collection_index, bytes32 _current_item, uint256 _count,
790                                 function (bytes32) external constant returns (bytes32) _function_first,
791                                 function (bytes32) external constant returns (bytes32) _function_last,
792                                 function (bytes32, bytes32) external constant returns (bytes32) _function_next,
793                                 function (bytes32, bytes32) external constant returns (bytes32) _function_previous,
794                                 bool _from_start)
795            internal
796            constant
797            returns (bytes32[] _indexed_bytes_items)
798   {
799     if (_from_start) {
800       _indexed_bytes_items = private_list_indexed_bytes_from_bytes(_collection_index, _current_item, _count, false, _function_last, _function_next);
801     } else {
802       _indexed_bytes_items = private_list_indexed_bytes_from_bytes(_collection_index, _current_item, _count, false, _function_first, _function_previous);
803     }
804   }
805 
806   /**
807     @notice a private function to lists an indexed Bytes collection starting from some `_current_item` (which could be included or excluded), in the forwards or backwards direction
808     @param _collection_index Index of the Collection to list
809     @param _current_item The item where we start reading from the list
810     @param _count Total number of Bytes items to return
811     @param _including_current Whether the `_current_item` should be included in the result
812     @param _function_last Function that returns the bytes where we stop reading more bytes
813     @param _function_next Function that returns the next bytes to read after another bytes (could be backwards or forwards in the physical collection)
814     @return {"_bytes_items" :"Collection/list of Bytes"}
815   */
816   function private_list_indexed_bytes_from_bytes(bytes32 _collection_index, bytes32 _current_item, uint256 _count, bool _including_current,
817                                          function (bytes32) external constant returns (bytes32) _function_last,
818                                          function (bytes32, bytes32) external constant returns (bytes32) _function_next)
819            private
820            constant
821            returns (bytes32[] _indexed_bytes_items)
822   {
823     uint256 _i;
824     uint256 _real_count = 0;
825     bytes32 _last_item;
826 
827     _last_item = _function_last(_collection_index);
828     if (_count == 0 || _last_item == bytes32(0x0)) {  // if count is 0 or the collection is empty, returns empty array
829       _indexed_bytes_items = new bytes32[](0);
830     } else {
831       bytes32[] memory _items_temp = new bytes32[](_count);
832       bytes32 _this_item;
833       if (_including_current) {
834         _items_temp[0] = _current_item;
835         _real_count = 1;
836       }
837       _this_item = _current_item;
838       for (_i = _real_count; (_i < _count) && (_this_item != _last_item);_i++) {
839         _this_item = _function_next(_collection_index, _this_item);
840         if (_this_item != bytes32(0x0)) {
841           _real_count++;
842           _items_temp[_i] = _this_item;
843         }
844       }
845 
846       _indexed_bytes_items = new bytes32[](_real_count);
847       for(_i = 0;_i < _real_count;_i++) {
848         _indexed_bytes_items[_i] = _items_temp[_i];
849       }
850     }
851   }
852 
853 
854   // old function, DEPRECATED
855   /*function list_indexed_bytes_from_bytes(bytes32 _collection_index, bytes32 _current_item, uint256 _count,
856                                          function (bytes32) external constant returns (bytes32) _function_last,
857                                          function (bytes32, bytes32) external constant returns (bytes32) _function_next)
858            private
859            constant
860            returns (bytes32[] _indexed_bytes_items)
861   {
862     uint256 _i;
863     uint256 _real_count = 0;
864     if (_count == 0) {
865       _indexed_bytes_items = new bytes32[](0);
866     } else {
867       bytes32[] memory _items_temp = new bytes32[](_count);
868 
869       bytes32 _start_item;
870       bytes32 _last_item;
871 
872       _last_item = _function_last(_collection_index);
873 
874       if (_last_item != _current_item) {
875         _start_item = _function_next(_collection_index, _current_item);
876         if (_start_item != bytes32(0x0)) {
877           _items_temp[0] = _start_item;
878           _real_count = 1;
879           for(_i = 1;(_i <= (_count - 1)) && (_start_item != _last_item);_i++) {
880             _start_item = _function_next(_collection_index, _start_item);
881             if (_start_item != bytes32(0x0)) {
882               _real_count++;
883               _items_temp[_i] = _start_item;
884             }
885           }
886           _indexed_bytes_items = new bytes32[](_real_count);
887           for(_i = 0;_i <= (_real_count - 1);_i++) {
888             _indexed_bytes_items[_i] = _items_temp[_i];
889           }
890         } else {
891           _indexed_bytes_items = new bytes32[](0);
892         }
893       } else {
894         _indexed_bytes_items = new bytes32[](0);
895       }
896     }
897   }*/
898 
899 
900 }
901 
902 // File: @digix/solidity-collections/contracts/lib/DoublyLinkedList.sol
903 pragma solidity ^0.4.19;
904 
905 library DoublyLinkedList {
906 
907   struct Item {
908     bytes32 item;
909     uint256 previous_index;
910     uint256 next_index;
911   }
912 
913   struct Data {
914     uint256 first_index;
915     uint256 last_index;
916     uint256 count;
917     mapping(bytes32 => uint256) item_index;
918     mapping(uint256 => bool) valid_indexes;
919     Item[] collection;
920   }
921 
922   struct IndexedUint {
923     mapping(bytes32 => Data) data;
924   }
925 
926   struct IndexedAddress {
927     mapping(bytes32 => Data) data;
928   }
929 
930   struct IndexedBytes {
931     mapping(bytes32 => Data) data;
932   }
933 
934   struct Address {
935     Data data;
936   }
937 
938   struct Bytes {
939     Data data;
940   }
941 
942   struct Uint {
943     Data data;
944   }
945 
946   uint256 constant NONE = uint256(0);
947   bytes32 constant EMPTY_BYTES = bytes32(0x0);
948   address constant NULL_ADDRESS = address(0x0);
949 
950   function find(Data storage self, bytes32 _item)
951            public
952            constant
953            returns (uint256 _item_index)
954   {
955     if ((self.item_index[_item] == NONE) && (self.count == NONE)) {
956       _item_index = NONE;
957     } else {
958       _item_index = self.item_index[_item];
959     }
960   }
961 
962   function get(Data storage self, uint256 _item_index)
963            public
964            constant
965            returns (bytes32 _item)
966   {
967     if (self.valid_indexes[_item_index] == true) {
968       _item = self.collection[_item_index - 1].item;
969     } else {
970       _item = EMPTY_BYTES;
971     }
972   }
973 
974   function append(Data storage self, bytes32 _data)
975            internal
976            returns (bool _success)
977   {
978     if (find(self, _data) != NONE || _data == bytes32("")) { // rejects addition of empty values
979       _success = false;
980     } else {
981       uint256 _index = uint256(self.collection.push(Item({item: _data, previous_index: self.last_index, next_index: NONE})));
982       if (self.last_index == NONE) {
983         if ((self.first_index != NONE) || (self.count != NONE)) {
984           revert();
985         } else {
986           self.first_index = self.last_index = _index;
987           self.count = 1;
988         }
989       } else {
990         self.collection[self.last_index - 1].next_index = _index;
991         self.last_index = _index;
992         self.count++;
993       }
994       self.valid_indexes[_index] = true;
995       self.item_index[_data] = _index;
996       _success = true;
997     }
998   }
999 
1000   function remove(Data storage self, uint256 _index)
1001            internal
1002            returns (bool _success)
1003   {
1004     if (self.valid_indexes[_index] == true) {
1005       Item memory item = self.collection[_index - 1];
1006       if (item.previous_index == NONE) {
1007         self.first_index = item.next_index;
1008       } else {
1009         self.collection[item.previous_index - 1].next_index = item.next_index;
1010       }
1011 
1012       if (item.next_index == NONE) {
1013         self.last_index = item.previous_index;
1014       } else {
1015         self.collection[item.next_index - 1].previous_index = item.previous_index;
1016       }
1017       delete self.collection[_index - 1];
1018       self.valid_indexes[_index] = false;
1019       delete self.item_index[item.item];
1020       self.count--;
1021       _success = true;
1022     } else {
1023       _success = false;
1024     }
1025   }
1026 
1027   function remove_item(Data storage self, bytes32 _item)
1028            internal
1029            returns (bool _success)
1030   {
1031     uint256 _item_index = find(self, _item);
1032     if (_item_index != NONE) {
1033       require(remove(self, _item_index));
1034       _success = true;
1035     } else {
1036       _success = false;
1037     }
1038     return _success;
1039   }
1040 
1041   function total(Data storage self)
1042            public
1043            constant
1044            returns (uint256 _total_count)
1045   {
1046     _total_count = self.count;
1047   }
1048 
1049   function start(Data storage self)
1050            public
1051            constant
1052            returns (uint256 _item_index)
1053   {
1054     _item_index = self.first_index;
1055     return _item_index;
1056   }
1057 
1058   function start_item(Data storage self)
1059            public
1060            constant
1061            returns (bytes32 _item)
1062   {
1063     uint256 _item_index = start(self);
1064     if (_item_index != NONE) {
1065       _item = get(self, _item_index);
1066     } else {
1067       _item = EMPTY_BYTES;
1068     }
1069   }
1070 
1071   function end(Data storage self)
1072            public
1073            constant
1074            returns (uint256 _item_index)
1075   {
1076     _item_index = self.last_index;
1077     return _item_index;
1078   }
1079 
1080   function end_item(Data storage self)
1081            public
1082            constant
1083            returns (bytes32 _item)
1084   {
1085     uint256 _item_index = end(self);
1086     if (_item_index != NONE) {
1087       _item = get(self, _item_index);
1088     } else {
1089       _item = EMPTY_BYTES;
1090     }
1091   }
1092 
1093   function valid(Data storage self, uint256 _item_index)
1094            public
1095            constant
1096            returns (bool _yes)
1097   {
1098     _yes = self.valid_indexes[_item_index];
1099     //_yes = ((_item_index - 1) < self.collection.length);
1100   }
1101 
1102   function valid_item(Data storage self, bytes32 _item)
1103            public
1104            constant
1105            returns (bool _yes)
1106   {
1107     uint256 _item_index = self.item_index[_item];
1108     _yes = self.valid_indexes[_item_index];
1109   }
1110 
1111   function previous(Data storage self, uint256 _current_index)
1112            public
1113            constant
1114            returns (uint256 _previous_index)
1115   {
1116     if (self.valid_indexes[_current_index] == true) {
1117       _previous_index = self.collection[_current_index - 1].previous_index;
1118     } else {
1119       _previous_index = NONE;
1120     }
1121   }
1122 
1123   function previous_item(Data storage self, bytes32 _current_item)
1124            public
1125            constant
1126            returns (bytes32 _previous_item)
1127   {
1128     uint256 _current_index = find(self, _current_item);
1129     if (_current_index != NONE) {
1130       uint256 _previous_index = previous(self, _current_index);
1131       _previous_item = get(self, _previous_index);
1132     } else {
1133       _previous_item = EMPTY_BYTES;
1134     }
1135   }
1136 
1137   function next(Data storage self, uint256 _current_index)
1138            public
1139            constant
1140            returns (uint256 _next_index)
1141   {
1142     if (self.valid_indexes[_current_index] == true) {
1143       _next_index = self.collection[_current_index - 1].next_index;
1144     } else {
1145       _next_index = NONE;
1146     }
1147   }
1148 
1149   function next_item(Data storage self, bytes32 _current_item)
1150            public
1151            constant
1152            returns (bytes32 _next_item)
1153   {
1154     uint256 _current_index = find(self, _current_item);
1155     if (_current_index != NONE) {
1156       uint256 _next_index = next(self, _current_index);
1157       _next_item = get(self, _next_index);
1158     } else {
1159       _next_item = EMPTY_BYTES;
1160     }
1161   }
1162 
1163   function find(Uint storage self, uint256 _item)
1164            public
1165            constant
1166            returns (uint256 _item_index)
1167   {
1168     _item_index = find(self.data, bytes32(_item));
1169   }
1170 
1171   function get(Uint storage self, uint256 _item_index)
1172            public
1173            constant
1174            returns (uint256 _item)
1175   {
1176     _item = uint256(get(self.data, _item_index));
1177   }
1178 
1179 
1180   function append(Uint storage self, uint256 _data)
1181            public
1182            returns (bool _success)
1183   {
1184     _success = append(self.data, bytes32(_data));
1185   }
1186 
1187   function remove(Uint storage self, uint256 _index)
1188            internal
1189            returns (bool _success)
1190   {
1191     _success = remove(self.data, _index);
1192   }
1193 
1194   function remove_item(Uint storage self, uint256 _item)
1195            public
1196            returns (bool _success)
1197   {
1198     _success = remove_item(self.data, bytes32(_item));
1199   }
1200 
1201   function total(Uint storage self)
1202            public
1203            constant
1204            returns (uint256 _total_count)
1205   {
1206     _total_count = total(self.data);
1207   }
1208 
1209   function start(Uint storage self)
1210            public
1211            constant
1212            returns (uint256 _index)
1213   {
1214     _index = start(self.data);
1215   }
1216 
1217   function start_item(Uint storage self)
1218            public
1219            constant
1220            returns (uint256 _start_item)
1221   {
1222     _start_item = uint256(start_item(self.data));
1223   }
1224 
1225 
1226   function end(Uint storage self)
1227            public
1228            constant
1229            returns (uint256 _index)
1230   {
1231     _index = end(self.data);
1232   }
1233 
1234   function end_item(Uint storage self)
1235            public
1236            constant
1237            returns (uint256 _end_item)
1238   {
1239     _end_item = uint256(end_item(self.data));
1240   }
1241 
1242   function valid(Uint storage self, uint256 _item_index)
1243            public
1244            constant
1245            returns (bool _yes)
1246   {
1247     _yes = valid(self.data, _item_index);
1248   }
1249 
1250   function valid_item(Uint storage self, uint256 _item)
1251            public
1252            constant
1253            returns (bool _yes)
1254   {
1255     _yes = valid_item(self.data, bytes32(_item));
1256   }
1257 
1258   function previous(Uint storage self, uint256 _current_index)
1259            public
1260            constant
1261            returns (uint256 _previous_index)
1262   {
1263     _previous_index = previous(self.data, _current_index);
1264   }
1265 
1266   function previous_item(Uint storage self, uint256 _current_item)
1267            public
1268            constant
1269            returns (uint256 _previous_item)
1270   {
1271     _previous_item = uint256(previous_item(self.data, bytes32(_current_item)));
1272   }
1273 
1274   function next(Uint storage self, uint256 _current_index)
1275            public
1276            constant
1277            returns (uint256 _next_index)
1278   {
1279     _next_index = next(self.data, _current_index);
1280   }
1281 
1282   function next_item(Uint storage self, uint256 _current_item)
1283            public
1284            constant
1285            returns (uint256 _next_item)
1286   {
1287     _next_item = uint256(next_item(self.data, bytes32(_current_item)));
1288   }
1289 
1290   function find(Address storage self, address _item)
1291            public
1292            constant
1293            returns (uint256 _item_index)
1294   {
1295     _item_index = find(self.data, bytes32(_item));
1296   }
1297 
1298   function get(Address storage self, uint256 _item_index)
1299            public
1300            constant
1301            returns (address _item)
1302   {
1303     _item = address(get(self.data, _item_index));
1304   }
1305 
1306 
1307   function find(IndexedUint storage self, bytes32 _collection_index, uint256 _item)
1308            public
1309            constant
1310            returns (uint256 _item_index)
1311   {
1312     _item_index = find(self.data[_collection_index], bytes32(_item));
1313   }
1314 
1315   function get(IndexedUint storage self, bytes32 _collection_index, uint256 _item_index)
1316            public
1317            constant
1318            returns (uint256 _item)
1319   {
1320     _item = uint256(get(self.data[_collection_index], _item_index));
1321   }
1322 
1323 
1324   function append(IndexedUint storage self, bytes32 _collection_index, uint256 _data)
1325            public
1326            returns (bool _success)
1327   {
1328     _success = append(self.data[_collection_index], bytes32(_data));
1329   }
1330 
1331   function remove(IndexedUint storage self, bytes32 _collection_index, uint256 _index)
1332            internal
1333            returns (bool _success)
1334   {
1335     _success = remove(self.data[_collection_index], _index);
1336   }
1337 
1338   function remove_item(IndexedUint storage self, bytes32 _collection_index, uint256 _item)
1339            public
1340            returns (bool _success)
1341   {
1342     _success = remove_item(self.data[_collection_index], bytes32(_item));
1343   }
1344 
1345   function total(IndexedUint storage self, bytes32 _collection_index)
1346            public
1347            constant
1348            returns (uint256 _total_count)
1349   {
1350     _total_count = total(self.data[_collection_index]);
1351   }
1352 
1353   function start(IndexedUint storage self, bytes32 _collection_index)
1354            public
1355            constant
1356            returns (uint256 _index)
1357   {
1358     _index = start(self.data[_collection_index]);
1359   }
1360 
1361   function start_item(IndexedUint storage self, bytes32 _collection_index)
1362            public
1363            constant
1364            returns (uint256 _start_item)
1365   {
1366     _start_item = uint256(start_item(self.data[_collection_index]));
1367   }
1368 
1369 
1370   function end(IndexedUint storage self, bytes32 _collection_index)
1371            public
1372            constant
1373            returns (uint256 _index)
1374   {
1375     _index = end(self.data[_collection_index]);
1376   }
1377 
1378   function end_item(IndexedUint storage self, bytes32 _collection_index)
1379            public
1380            constant
1381            returns (uint256 _end_item)
1382   {
1383     _end_item = uint256(end_item(self.data[_collection_index]));
1384   }
1385 
1386   function valid(IndexedUint storage self, bytes32 _collection_index, uint256 _item_index)
1387            public
1388            constant
1389            returns (bool _yes)
1390   {
1391     _yes = valid(self.data[_collection_index], _item_index);
1392   }
1393 
1394   function valid_item(IndexedUint storage self, bytes32 _collection_index, uint256 _item)
1395            public
1396            constant
1397            returns (bool _yes)
1398   {
1399     _yes = valid_item(self.data[_collection_index], bytes32(_item));
1400   }
1401 
1402   function previous(IndexedUint storage self, bytes32 _collection_index, uint256 _current_index)
1403            public
1404            constant
1405            returns (uint256 _previous_index)
1406   {
1407     _previous_index = previous(self.data[_collection_index], _current_index);
1408   }
1409 
1410   function previous_item(IndexedUint storage self, bytes32 _collection_index, uint256 _current_item)
1411            public
1412            constant
1413            returns (uint256 _previous_item)
1414   {
1415     _previous_item = uint256(previous_item(self.data[_collection_index], bytes32(_current_item)));
1416   }
1417 
1418   function next(IndexedUint storage self, bytes32 _collection_index, uint256 _current_index)
1419            public
1420            constant
1421            returns (uint256 _next_index)
1422   {
1423     _next_index = next(self.data[_collection_index], _current_index);
1424   }
1425 
1426   function next_item(IndexedUint storage self, bytes32 _collection_index, uint256 _current_item)
1427            public
1428            constant
1429            returns (uint256 _next_item)
1430   {
1431     _next_item = uint256(next_item(self.data[_collection_index], bytes32(_current_item)));
1432   }
1433 
1434   function append(Address storage self, address _data)
1435            public
1436            returns (bool _success)
1437   {
1438     _success = append(self.data, bytes32(_data));
1439   }
1440 
1441   function remove(Address storage self, uint256 _index)
1442            internal
1443            returns (bool _success)
1444   {
1445     _success = remove(self.data, _index);
1446   }
1447 
1448 
1449   function remove_item(Address storage self, address _item)
1450            public
1451            returns (bool _success)
1452   {
1453     _success = remove_item(self.data, bytes32(_item));
1454   }
1455 
1456   function total(Address storage self)
1457            public
1458            constant
1459            returns (uint256 _total_count)
1460   {
1461     _total_count = total(self.data);
1462   }
1463 
1464   function start(Address storage self)
1465            public
1466            constant
1467            returns (uint256 _index)
1468   {
1469     _index = start(self.data);
1470   }
1471 
1472   function start_item(Address storage self)
1473            public
1474            constant
1475            returns (address _start_item)
1476   {
1477     _start_item = address(start_item(self.data));
1478   }
1479 
1480 
1481   function end(Address storage self)
1482            public
1483            constant
1484            returns (uint256 _index)
1485   {
1486     _index = end(self.data);
1487   }
1488 
1489   function end_item(Address storage self)
1490            public
1491            constant
1492            returns (address _end_item)
1493   {
1494     _end_item = address(end_item(self.data));
1495   }
1496 
1497   function valid(Address storage self, uint256 _item_index)
1498            public
1499            constant
1500            returns (bool _yes)
1501   {
1502     _yes = valid(self.data, _item_index);
1503   }
1504 
1505   function valid_item(Address storage self, address _item)
1506            public
1507            constant
1508            returns (bool _yes)
1509   {
1510     _yes = valid_item(self.data, bytes32(_item));
1511   }
1512 
1513   function previous(Address storage self, uint256 _current_index)
1514            public
1515            constant
1516            returns (uint256 _previous_index)
1517   {
1518     _previous_index = previous(self.data, _current_index);
1519   }
1520 
1521   function previous_item(Address storage self, address _current_item)
1522            public
1523            constant
1524            returns (address _previous_item)
1525   {
1526     _previous_item = address(previous_item(self.data, bytes32(_current_item)));
1527   }
1528 
1529   function next(Address storage self, uint256 _current_index)
1530            public
1531            constant
1532            returns (uint256 _next_index)
1533   {
1534     _next_index = next(self.data, _current_index);
1535   }
1536 
1537   function next_item(Address storage self, address _current_item)
1538            public
1539            constant
1540            returns (address _next_item)
1541   {
1542     _next_item = address(next_item(self.data, bytes32(_current_item)));
1543   }
1544 
1545   function append(IndexedAddress storage self, bytes32 _collection_index, address _data)
1546            public
1547            returns (bool _success)
1548   {
1549     _success = append(self.data[_collection_index], bytes32(_data));
1550   }
1551 
1552   function remove(IndexedAddress storage self, bytes32 _collection_index, uint256 _index)
1553            internal
1554            returns (bool _success)
1555   {
1556     _success = remove(self.data[_collection_index], _index);
1557   }
1558 
1559 
1560   function remove_item(IndexedAddress storage self, bytes32 _collection_index, address _item)
1561            public
1562            returns (bool _success)
1563   {
1564     _success = remove_item(self.data[_collection_index], bytes32(_item));
1565   }
1566 
1567   function total(IndexedAddress storage self, bytes32 _collection_index)
1568            public
1569            constant
1570            returns (uint256 _total_count)
1571   {
1572     _total_count = total(self.data[_collection_index]);
1573   }
1574 
1575   function start(IndexedAddress storage self, bytes32 _collection_index)
1576            public
1577            constant
1578            returns (uint256 _index)
1579   {
1580     _index = start(self.data[_collection_index]);
1581   }
1582 
1583   function start_item(IndexedAddress storage self, bytes32 _collection_index)
1584            public
1585            constant
1586            returns (address _start_item)
1587   {
1588     _start_item = address(start_item(self.data[_collection_index]));
1589   }
1590 
1591 
1592   function end(IndexedAddress storage self, bytes32 _collection_index)
1593            public
1594            constant
1595            returns (uint256 _index)
1596   {
1597     _index = end(self.data[_collection_index]);
1598   }
1599 
1600   function end_item(IndexedAddress storage self, bytes32 _collection_index)
1601            public
1602            constant
1603            returns (address _end_item)
1604   {
1605     _end_item = address(end_item(self.data[_collection_index]));
1606   }
1607 
1608   function valid(IndexedAddress storage self, bytes32 _collection_index, uint256 _item_index)
1609            public
1610            constant
1611            returns (bool _yes)
1612   {
1613     _yes = valid(self.data[_collection_index], _item_index);
1614   }
1615 
1616   function valid_item(IndexedAddress storage self, bytes32 _collection_index, address _item)
1617            public
1618            constant
1619            returns (bool _yes)
1620   {
1621     _yes = valid_item(self.data[_collection_index], bytes32(_item));
1622   }
1623 
1624   function previous(IndexedAddress storage self, bytes32 _collection_index, uint256 _current_index)
1625            public
1626            constant
1627            returns (uint256 _previous_index)
1628   {
1629     _previous_index = previous(self.data[_collection_index], _current_index);
1630   }
1631 
1632   function previous_item(IndexedAddress storage self, bytes32 _collection_index, address _current_item)
1633            public
1634            constant
1635            returns (address _previous_item)
1636   {
1637     _previous_item = address(previous_item(self.data[_collection_index], bytes32(_current_item)));
1638   }
1639 
1640   function next(IndexedAddress storage self, bytes32 _collection_index, uint256 _current_index)
1641            public
1642            constant
1643            returns (uint256 _next_index)
1644   {
1645     _next_index = next(self.data[_collection_index], _current_index);
1646   }
1647 
1648   function next_item(IndexedAddress storage self, bytes32 _collection_index, address _current_item)
1649            public
1650            constant
1651            returns (address _next_item)
1652   {
1653     _next_item = address(next_item(self.data[_collection_index], bytes32(_current_item)));
1654   }
1655 
1656 
1657   function find(Bytes storage self, bytes32 _item)
1658            public
1659            constant
1660            returns (uint256 _item_index)
1661   {
1662     _item_index = find(self.data, _item);
1663   }
1664 
1665   function get(Bytes storage self, uint256 _item_index)
1666            public
1667            constant
1668            returns (bytes32 _item)
1669   {
1670     _item = get(self.data, _item_index);
1671   }
1672 
1673 
1674   function append(Bytes storage self, bytes32 _data)
1675            public
1676            returns (bool _success)
1677   {
1678     _success = append(self.data, _data);
1679   }
1680 
1681   function remove(Bytes storage self, uint256 _index)
1682            internal
1683            returns (bool _success)
1684   {
1685     _success = remove(self.data, _index);
1686   }
1687 
1688 
1689   function remove_item(Bytes storage self, bytes32 _item)
1690            public
1691            returns (bool _success)
1692   {
1693     _success = remove_item(self.data, _item);
1694   }
1695 
1696   function total(Bytes storage self)
1697            public
1698            constant
1699            returns (uint256 _total_count)
1700   {
1701     _total_count = total(self.data);
1702   }
1703 
1704   function start(Bytes storage self)
1705            public
1706            constant
1707            returns (uint256 _index)
1708   {
1709     _index = start(self.data);
1710   }
1711 
1712   function start_item(Bytes storage self)
1713            public
1714            constant
1715            returns (bytes32 _start_item)
1716   {
1717     _start_item = start_item(self.data);
1718   }
1719 
1720 
1721   function end(Bytes storage self)
1722            public
1723            constant
1724            returns (uint256 _index)
1725   {
1726     _index = end(self.data);
1727   }
1728 
1729   function end_item(Bytes storage self)
1730            public
1731            constant
1732            returns (bytes32 _end_item)
1733   {
1734     _end_item = end_item(self.data);
1735   }
1736 
1737   function valid(Bytes storage self, uint256 _item_index)
1738            public
1739            constant
1740            returns (bool _yes)
1741   {
1742     _yes = valid(self.data, _item_index);
1743   }
1744 
1745   function valid_item(Bytes storage self, bytes32 _item)
1746            public
1747            constant
1748            returns (bool _yes)
1749   {
1750     _yes = valid_item(self.data, _item);
1751   }
1752 
1753   function previous(Bytes storage self, uint256 _current_index)
1754            public
1755            constant
1756            returns (uint256 _previous_index)
1757   {
1758     _previous_index = previous(self.data, _current_index);
1759   }
1760 
1761   function previous_item(Bytes storage self, bytes32 _current_item)
1762            public
1763            constant
1764            returns (bytes32 _previous_item)
1765   {
1766     _previous_item = previous_item(self.data, _current_item);
1767   }
1768 
1769   function next(Bytes storage self, uint256 _current_index)
1770            public
1771            constant
1772            returns (uint256 _next_index)
1773   {
1774     _next_index = next(self.data, _current_index);
1775   }
1776 
1777   function next_item(Bytes storage self, bytes32 _current_item)
1778            public
1779            constant
1780            returns (bytes32 _next_item)
1781   {
1782     _next_item = next_item(self.data, _current_item);
1783   }
1784 
1785   function append(IndexedBytes storage self, bytes32 _collection_index, bytes32 _data)
1786            public
1787            returns (bool _success)
1788   {
1789     _success = append(self.data[_collection_index], bytes32(_data));
1790   }
1791 
1792   function remove(IndexedBytes storage self, bytes32 _collection_index, uint256 _index)
1793            internal
1794            returns (bool _success)
1795   {
1796     _success = remove(self.data[_collection_index], _index);
1797   }
1798 
1799 
1800   function remove_item(IndexedBytes storage self, bytes32 _collection_index, bytes32 _item)
1801            public
1802            returns (bool _success)
1803   {
1804     _success = remove_item(self.data[_collection_index], bytes32(_item));
1805   }
1806 
1807   function total(IndexedBytes storage self, bytes32 _collection_index)
1808            public
1809            constant
1810            returns (uint256 _total_count)
1811   {
1812     _total_count = total(self.data[_collection_index]);
1813   }
1814 
1815   function start(IndexedBytes storage self, bytes32 _collection_index)
1816            public
1817            constant
1818            returns (uint256 _index)
1819   {
1820     _index = start(self.data[_collection_index]);
1821   }
1822 
1823   function start_item(IndexedBytes storage self, bytes32 _collection_index)
1824            public
1825            constant
1826            returns (bytes32 _start_item)
1827   {
1828     _start_item = bytes32(start_item(self.data[_collection_index]));
1829   }
1830 
1831 
1832   function end(IndexedBytes storage self, bytes32 _collection_index)
1833            public
1834            constant
1835            returns (uint256 _index)
1836   {
1837     _index = end(self.data[_collection_index]);
1838   }
1839 
1840   function end_item(IndexedBytes storage self, bytes32 _collection_index)
1841            public
1842            constant
1843            returns (bytes32 _end_item)
1844   {
1845     _end_item = bytes32(end_item(self.data[_collection_index]));
1846   }
1847 
1848   function valid(IndexedBytes storage self, bytes32 _collection_index, uint256 _item_index)
1849            public
1850            constant
1851            returns (bool _yes)
1852   {
1853     _yes = valid(self.data[_collection_index], _item_index);
1854   }
1855 
1856   function valid_item(IndexedBytes storage self, bytes32 _collection_index, bytes32 _item)
1857            public
1858            constant
1859            returns (bool _yes)
1860   {
1861     _yes = valid_item(self.data[_collection_index], bytes32(_item));
1862   }
1863 
1864   function previous(IndexedBytes storage self, bytes32 _collection_index, uint256 _current_index)
1865            public
1866            constant
1867            returns (uint256 _previous_index)
1868   {
1869     _previous_index = previous(self.data[_collection_index], _current_index);
1870   }
1871 
1872   function previous_item(IndexedBytes storage self, bytes32 _collection_index, bytes32 _current_item)
1873            public
1874            constant
1875            returns (bytes32 _previous_item)
1876   {
1877     _previous_item = bytes32(previous_item(self.data[_collection_index], bytes32(_current_item)));
1878   }
1879 
1880   function next(IndexedBytes storage self, bytes32 _collection_index, uint256 _current_index)
1881            public
1882            constant
1883            returns (uint256 _next_index)
1884   {
1885     _next_index = next(self.data[_collection_index], _current_index);
1886   }
1887 
1888   function next_item(IndexedBytes storage self, bytes32 _collection_index, bytes32 _current_item)
1889            public
1890            constant
1891            returns (bytes32 _next_item)
1892   {
1893     _next_item = bytes32(next_item(self.data[_collection_index], bytes32(_current_item)));
1894   }
1895 
1896 
1897 }
1898 
1899 // File: @digix/solidity-collections/contracts/abstract/BytesIteratorStorage.sol
1900 pragma solidity ^0.4.19;
1901 
1902 /**
1903   @title Bytes Iterator Storage
1904   @author DigixGlobal Pte Ltd
1905 */
1906 contract BytesIteratorStorage {
1907 
1908   // Initialize Doubly Linked List of Bytes
1909   using DoublyLinkedList for DoublyLinkedList.Bytes;
1910 
1911   /**
1912     @notice Reads the first item from the list of Bytes
1913     @param _list The source list
1914     @return {"_item": "The first item from the list"}
1915   */
1916   function read_first_from_bytesarray(DoublyLinkedList.Bytes storage _list)
1917            internal
1918            constant
1919            returns (bytes32 _item)
1920   {
1921     _item = _list.start_item();
1922   }
1923 
1924   /**
1925     @notice Reads the last item from the list of Bytes
1926     @param _list The source list
1927     @return {"_item": "The last item from the list"}
1928   */
1929   function read_last_from_bytesarray(DoublyLinkedList.Bytes storage _list)
1930            internal
1931            constant
1932            returns (bytes32 _item)
1933   {
1934     _item = _list.end_item();
1935   }
1936 
1937   /**
1938     @notice Reads the next item on the list of Bytes
1939     @param _list The source list
1940     @param _current_item The current item to be used as base line
1941     @return {"_item": "The next item from the list based on the specieid `_current_item`"}
1942     TODO: Need to verify what happens if the specified `_current_item` is the last item from the list
1943   */
1944   function read_next_from_bytesarray(DoublyLinkedList.Bytes storage _list, bytes32 _current_item)
1945            internal
1946            constant
1947            returns (bytes32 _item)
1948   {
1949     _item = _list.next_item(_current_item);
1950   }
1951 
1952   /**
1953     @notice Reads the previous item on the list of Bytes
1954     @param _list The source list
1955     @param _current_item The current item to be used as base line
1956     @return {"_item": "The previous item from the list based on the spcified `_current_item`"}
1957     TODO: Need to verify what happens if the specified `_current_item` is the first item from the list
1958   */
1959   function read_previous_from_bytesarray(DoublyLinkedList.Bytes storage _list, bytes32 _current_item)
1960            internal
1961            constant
1962            returns (bytes32 _item)
1963   {
1964     _item = _list.previous_item(_current_item);
1965   }
1966 
1967   /**
1968     @notice Reads the list of Bytes and returns the length of the list
1969     @param _list The source list
1970     @return {"count": "`uint256` The lenght of the list"}
1971 
1972   */
1973   function read_total_bytesarray(DoublyLinkedList.Bytes storage _list)
1974            internal
1975            constant
1976            returns (uint256 _count)
1977   {
1978     _count = _list.total();
1979   }
1980 
1981 }
1982 
1983 // File: contracts/common/DaoConstants.sol
1984 pragma solidity ^0.4.25;
1985 
1986 contract DaoConstants {
1987     using SafeMath for uint256;
1988     bytes32 EMPTY_BYTES = bytes32(0x0);
1989     address EMPTY_ADDRESS = address(0x0);
1990 
1991 
1992     bytes32 PROPOSAL_STATE_PREPROPOSAL = "proposal_state_preproposal";
1993     bytes32 PROPOSAL_STATE_DRAFT = "proposal_state_draft";
1994     bytes32 PROPOSAL_STATE_MODERATED = "proposal_state_moderated";
1995     bytes32 PROPOSAL_STATE_ONGOING = "proposal_state_ongoing";
1996     bytes32 PROPOSAL_STATE_CLOSED = "proposal_state_closed";
1997     bytes32 PROPOSAL_STATE_ARCHIVED = "proposal_state_archived";
1998 
1999     uint256 PRL_ACTION_STOP = 1;
2000     uint256 PRL_ACTION_PAUSE = 2;
2001     uint256 PRL_ACTION_UNPAUSE = 3;
2002 
2003     uint256 COLLATERAL_STATUS_UNLOCKED = 1;
2004     uint256 COLLATERAL_STATUS_LOCKED = 2;
2005     uint256 COLLATERAL_STATUS_CLAIMED = 3;
2006 
2007     bytes32 INTERMEDIATE_DGD_IDENTIFIER = "inter_dgd_id";
2008     bytes32 INTERMEDIATE_MODERATOR_DGD_IDENTIFIER = "inter_mod_dgd_id";
2009     bytes32 INTERMEDIATE_BONUS_CALCULATION_IDENTIFIER = "inter_bonus_calculation_id";
2010 
2011     // interactive contracts
2012     bytes32 CONTRACT_DAO = "dao";
2013     bytes32 CONTRACT_DAO_SPECIAL_PROPOSAL = "dao:special:proposal";
2014     bytes32 CONTRACT_DAO_STAKE_LOCKING = "dao:stake-locking";
2015     bytes32 CONTRACT_DAO_VOTING = "dao:voting";
2016     bytes32 CONTRACT_DAO_VOTING_CLAIMS = "dao:voting:claims";
2017     bytes32 CONTRACT_DAO_SPECIAL_VOTING_CLAIMS = "dao:svoting:claims";
2018     bytes32 CONTRACT_DAO_IDENTITY = "dao:identity";
2019     bytes32 CONTRACT_DAO_REWARDS_MANAGER = "dao:rewards-manager";
2020     bytes32 CONTRACT_DAO_REWARDS_MANAGER_EXTRAS = "dao:rewards-extras";
2021     bytes32 CONTRACT_DAO_ROLES = "dao:roles";
2022     bytes32 CONTRACT_DAO_FUNDING_MANAGER = "dao:funding-manager";
2023     bytes32 CONTRACT_DAO_WHITELISTING = "dao:whitelisting";
2024     bytes32 CONTRACT_DAO_INFORMATION = "dao:information";
2025 
2026     // service contracts
2027     bytes32 CONTRACT_SERVICE_ROLE = "service:role";
2028     bytes32 CONTRACT_SERVICE_DAO_INFO = "service:dao:info";
2029     bytes32 CONTRACT_SERVICE_DAO_LISTING = "service:dao:listing";
2030     bytes32 CONTRACT_SERVICE_DAO_CALCULATOR = "service:dao:calculator";
2031 
2032     // storage contracts
2033     bytes32 CONTRACT_STORAGE_DAO = "storage:dao";
2034     bytes32 CONTRACT_STORAGE_DAO_COUNTER = "storage:dao:counter";
2035     bytes32 CONTRACT_STORAGE_DAO_UPGRADE = "storage:dao:upgrade";
2036     bytes32 CONTRACT_STORAGE_DAO_IDENTITY = "storage:dao:identity";
2037     bytes32 CONTRACT_STORAGE_DAO_POINTS = "storage:dao:points";
2038     bytes32 CONTRACT_STORAGE_DAO_SPECIAL = "storage:dao:special";
2039     bytes32 CONTRACT_STORAGE_DAO_CONFIG = "storage:dao:config";
2040     bytes32 CONTRACT_STORAGE_DAO_STAKE = "storage:dao:stake";
2041     bytes32 CONTRACT_STORAGE_DAO_REWARDS = "storage:dao:rewards";
2042     bytes32 CONTRACT_STORAGE_DAO_WHITELISTING = "storage:dao:whitelisting";
2043     bytes32 CONTRACT_STORAGE_INTERMEDIATE_RESULTS = "storage:intermediate:results";
2044 
2045     bytes32 CONTRACT_DGD_TOKEN = "t:dgd";
2046     bytes32 CONTRACT_DGX_TOKEN = "t:dgx";
2047     bytes32 CONTRACT_BADGE_TOKEN = "t:badge";
2048 
2049     uint8 ROLES_ROOT = 1;
2050     uint8 ROLES_FOUNDERS = 2;
2051     uint8 ROLES_PRLS = 3;
2052     uint8 ROLES_KYC_ADMINS = 4;
2053 
2054     uint256 QUARTER_DURATION = 90 days;
2055 
2056     bytes32 CONFIG_MINIMUM_LOCKED_DGD = "min_dgd_participant";
2057     bytes32 CONFIG_MINIMUM_DGD_FOR_MODERATOR = "min_dgd_moderator";
2058     bytes32 CONFIG_MINIMUM_REPUTATION_FOR_MODERATOR = "min_reputation_moderator";
2059 
2060     bytes32 CONFIG_LOCKING_PHASE_DURATION = "locking_phase_duration";
2061     bytes32 CONFIG_QUARTER_DURATION = "quarter_duration";
2062     bytes32 CONFIG_VOTING_COMMIT_PHASE = "voting_commit_phase";
2063     bytes32 CONFIG_VOTING_PHASE_TOTAL = "voting_phase_total";
2064     bytes32 CONFIG_INTERIM_COMMIT_PHASE = "interim_voting_commit_phase";
2065     bytes32 CONFIG_INTERIM_PHASE_TOTAL = "interim_voting_phase_total";
2066 
2067     bytes32 CONFIG_DRAFT_QUORUM_FIXED_PORTION_NUMERATOR = "draft_quorum_fixed_numerator";
2068     bytes32 CONFIG_DRAFT_QUORUM_FIXED_PORTION_DENOMINATOR = "draft_quorum_fixed_denominator";
2069     bytes32 CONFIG_DRAFT_QUORUM_SCALING_FACTOR_NUMERATOR = "draft_quorum_sfactor_numerator";
2070     bytes32 CONFIG_DRAFT_QUORUM_SCALING_FACTOR_DENOMINATOR = "draft_quorum_sfactor_denominator";
2071     bytes32 CONFIG_VOTING_QUORUM_FIXED_PORTION_NUMERATOR = "vote_quorum_fixed_numerator";
2072     bytes32 CONFIG_VOTING_QUORUM_FIXED_PORTION_DENOMINATOR = "vote_quorum_fixed_denominator";
2073     bytes32 CONFIG_VOTING_QUORUM_SCALING_FACTOR_NUMERATOR = "vote_quorum_sfactor_numerator";
2074     bytes32 CONFIG_VOTING_QUORUM_SCALING_FACTOR_DENOMINATOR = "vote_quorum_sfactor_denominator";
2075     bytes32 CONFIG_FINAL_REWARD_SCALING_FACTOR_NUMERATOR = "final_reward_sfactor_numerator";
2076     bytes32 CONFIG_FINAL_REWARD_SCALING_FACTOR_DENOMINATOR = "final_reward_sfactor_denominator";
2077 
2078     bytes32 CONFIG_DRAFT_QUOTA_NUMERATOR = "draft_quota_numerator";
2079     bytes32 CONFIG_DRAFT_QUOTA_DENOMINATOR = "draft_quota_denominator";
2080     bytes32 CONFIG_VOTING_QUOTA_NUMERATOR = "voting_quota_numerator";
2081     bytes32 CONFIG_VOTING_QUOTA_DENOMINATOR = "voting_quota_denominator";
2082 
2083     bytes32 CONFIG_MINIMAL_QUARTER_POINT = "minimal_qp";
2084     bytes32 CONFIG_QUARTER_POINT_SCALING_FACTOR = "quarter_point_scaling_factor";
2085     bytes32 CONFIG_REPUTATION_POINT_SCALING_FACTOR = "rep_point_scaling_factor";
2086 
2087     bytes32 CONFIG_MODERATOR_MINIMAL_QUARTER_POINT = "minimal_mod_qp";
2088     bytes32 CONFIG_MODERATOR_QUARTER_POINT_SCALING_FACTOR = "mod_qp_scaling_factor";
2089     bytes32 CONFIG_MODERATOR_REPUTATION_POINT_SCALING_FACTOR = "mod_rep_point_scaling_factor";
2090 
2091     bytes32 CONFIG_QUARTER_POINT_DRAFT_VOTE = "quarter_point_draft_vote";
2092     bytes32 CONFIG_QUARTER_POINT_VOTE = "quarter_point_vote";
2093     bytes32 CONFIG_QUARTER_POINT_INTERIM_VOTE = "quarter_point_interim_vote";
2094 
2095     /// this is per 10000 ETHs
2096     bytes32 CONFIG_QUARTER_POINT_MILESTONE_COMPLETION_PER_10000ETH = "q_p_milestone_completion";
2097 
2098     bytes32 CONFIG_BONUS_REPUTATION_NUMERATOR = "bonus_reputation_numerator";
2099     bytes32 CONFIG_BONUS_REPUTATION_DENOMINATOR = "bonus_reputation_denominator";
2100 
2101     bytes32 CONFIG_SPECIAL_PROPOSAL_COMMIT_PHASE = "special_proposal_commit_phase";
2102     bytes32 CONFIG_SPECIAL_PROPOSAL_PHASE_TOTAL = "special_proposal_phase_total";
2103 
2104     bytes32 CONFIG_SPECIAL_QUOTA_NUMERATOR = "config_special_quota_numerator";
2105     bytes32 CONFIG_SPECIAL_QUOTA_DENOMINATOR = "config_special_quota_denominator";
2106 
2107     bytes32 CONFIG_SPECIAL_PROPOSAL_QUORUM_NUMERATOR = "special_quorum_numerator";
2108     bytes32 CONFIG_SPECIAL_PROPOSAL_QUORUM_DENOMINATOR = "special_quorum_denominator";
2109 
2110     bytes32 CONFIG_MAXIMUM_REPUTATION_DEDUCTION = "config_max_reputation_deduction";
2111     bytes32 CONFIG_PUNISHMENT_FOR_NOT_LOCKING = "config_punishment_not_locking";
2112 
2113     bytes32 CONFIG_REPUTATION_PER_EXTRA_QP_NUM = "config_rep_per_extra_qp_num";
2114     bytes32 CONFIG_REPUTATION_PER_EXTRA_QP_DEN = "config_rep_per_extra_qp_den";
2115 
2116     bytes32 CONFIG_MAXIMUM_MODERATOR_REPUTATION_DEDUCTION = "config_max_m_rp_deduction";
2117     bytes32 CONFIG_REPUTATION_PER_EXTRA_MODERATOR_QP_NUM = "config_rep_per_extra_m_qp_num";
2118     bytes32 CONFIG_REPUTATION_PER_EXTRA_MODERATOR_QP_DEN = "config_rep_per_extra_m_qp_den";
2119 
2120     bytes32 CONFIG_PORTION_TO_MODERATORS_NUM = "config_mod_portion_num";
2121     bytes32 CONFIG_PORTION_TO_MODERATORS_DEN = "config_mod_portion_den";
2122 
2123     bytes32 CONFIG_DRAFT_VOTING_PHASE = "config_draft_voting_phase";
2124 
2125     bytes32 CONFIG_REPUTATION_POINT_BOOST_FOR_BADGE = "config_rp_boost_per_badge";
2126 
2127     bytes32 CONFIG_VOTE_CLAIMING_DEADLINE = "config_claiming_deadline";
2128 
2129     bytes32 CONFIG_PREPROPOSAL_COLLATERAL = "config_preproposal_collateral";
2130 
2131     bytes32 CONFIG_MAX_FUNDING_FOR_NON_DIGIX = "config_max_funding_nonDigix";
2132     bytes32 CONFIG_MAX_MILESTONES_FOR_NON_DIGIX = "config_max_milestones_nonDigix";
2133     bytes32 CONFIG_NON_DIGIX_PROPOSAL_CAP_PER_QUARTER = "config_nonDigix_proposal_cap";
2134 
2135     bytes32 CONFIG_PROPOSAL_DEAD_DURATION = "config_dead_duration";
2136     bytes32 CONFIG_CARBON_VOTE_REPUTATION_BONUS = "config_cv_reputation";
2137 }
2138 
2139 // File: contracts/storage/DaoWhitelistingStorage.sol
2140 pragma solidity ^0.4.25;
2141 
2142 // This contract is basically created to restrict read access to
2143 // ethereum accounts, and whitelisted contracts
2144 contract DaoWhitelistingStorage is ResolverClient, DaoConstants {
2145 
2146     // we want to avoid the scenario in which an on-chain bribing contract
2147     // can be deployed to distribute funds in a trustless way by verifying
2148     // on-chain votes. This mapping marks whether a contract address is whitelisted
2149     // to read from the read functions in DaoStorage, DaoSpecialStorage, etc.
2150     mapping (address => bool) public whitelist;
2151 
2152     constructor(address _resolver)
2153         public
2154     {
2155         require(init(CONTRACT_STORAGE_DAO_WHITELISTING, _resolver));
2156     }
2157 
2158     function setWhitelisted(address _contractAddress, bool _senderIsAllowedToRead)
2159         public
2160     {
2161         require(sender_is(CONTRACT_DAO_WHITELISTING));
2162         whitelist[_contractAddress] = _senderIsAllowedToRead;
2163     }
2164 }
2165 
2166 // File: contracts/common/DaoWhitelistingCommon.sol
2167 pragma solidity ^0.4.25;
2168 
2169 contract DaoWhitelistingCommon is ResolverClient, DaoConstants {
2170 
2171     function daoWhitelistingStorage()
2172         internal
2173         view
2174         returns (DaoWhitelistingStorage _contract)
2175     {
2176         _contract = DaoWhitelistingStorage(get_contract(CONTRACT_STORAGE_DAO_WHITELISTING));
2177     }
2178 
2179     /**
2180     @notice Check if a certain address is whitelisted to read sensitive information in the storage layer
2181     @dev if the address is an account, it is allowed to read. If the address is a contract, it has to be in the whitelist
2182     */
2183     function senderIsAllowedToRead()
2184         internal
2185         view
2186         returns (bool _senderIsAllowedToRead)
2187     {
2188         // msg.sender is allowed to read only if its an EOA or a whitelisted contract
2189         _senderIsAllowedToRead = (msg.sender == tx.origin) || daoWhitelistingStorage().whitelist(msg.sender);
2190     }
2191 }
2192 
2193 // File: contracts/lib/DaoStructs.sol
2194 pragma solidity ^0.4.25;
2195 
2196 library DaoStructs {
2197     using DoublyLinkedList for DoublyLinkedList.Bytes;
2198     using SafeMath for uint256;
2199     bytes32 constant EMPTY_BYTES = bytes32(0x0);
2200 
2201     struct PrlAction {
2202         // UTC timestamp at which the PRL action was done
2203         uint256 at;
2204 
2205         // IPFS hash of the document summarizing the action
2206         bytes32 doc;
2207 
2208         // Type of action
2209         // check PRL_ACTION_* in "./../common/DaoConstants.sol"
2210         uint256 actionId;
2211     }
2212 
2213     struct Voting {
2214         // UTC timestamp at which the voting round starts
2215         uint256 startTime;
2216 
2217         // Mapping of whether a commit was used in this voting round
2218         mapping (bytes32 => bool) usedCommits;
2219 
2220         // Mapping of commits by address. These are the commits during the commit phase in a voting round
2221         // This only stores the most recent commit in the voting round
2222         // In case a vote is edited, the previous commit is overwritten by the new commit
2223         // Only this new commit is verified at the reveal phase
2224         mapping (address => bytes32) commits;
2225 
2226         // This mapping is updated after the reveal phase, when votes are revealed
2227         // It is a mapping of address to weight of vote
2228         // Weight implies the lockedDGDStake of the address, at the time of revealing
2229         // If the address voted "NO", or didn't vote, this would be 0
2230         mapping (address => uint256) yesVotes;
2231 
2232         // This mapping is updated after the reveal phase, when votes are revealed
2233         // It is a mapping of address to weight of vote
2234         // Weight implies the lockedDGDStake of the address, at the time of revealing
2235         // If the address voted "YES", or didn't vote, this would be 0
2236         mapping (address => uint256) noVotes;
2237 
2238         // Boolean whether the voting round passed or not
2239         bool passed;
2240 
2241         // Boolean whether the voting round results were claimed or not
2242         // refer the claimProposalVotingResult function in "./../interative/DaoVotingClaims.sol"
2243         bool claimed;
2244 
2245         // Boolean whether the milestone following this voting round was funded or not
2246         // The milestone is funded when the proposer calls claimFunding in "./../interactive/DaoFundingManager.sol"
2247         bool funded;
2248     }
2249 
2250     struct ProposalVersion {
2251         // IPFS doc hash of this version of the proposal
2252         bytes32 docIpfsHash;
2253 
2254         // UTC timestamp at which this version was created
2255         uint256 created;
2256 
2257         // The number of milestones in the proposal as per this version
2258         uint256 milestoneCount;
2259 
2260         // The final reward asked by the proposer for completion of the entire proposal
2261         uint256 finalReward;
2262 
2263         // List of fundings required by the proposal as per this version
2264         // The numbers are in wei
2265         uint256[] milestoneFundings;
2266 
2267         // When a proposal is finalized (calling Dao.finalizeProposal), the proposer can no longer add proposal versions
2268         // However, they can still add more details to this final proposal version, in the form of IPFS docs.
2269         // These IPFS docs are stored in this array
2270         bytes32[] moreDocs;
2271     }
2272 
2273     struct Proposal {
2274         // ID of the proposal. Also the IPFS hash of the first ProposalVersion
2275         bytes32 proposalId;
2276 
2277         // current state of the proposal
2278         // refer PROPOSAL_STATE_* in "./../common/DaoConstants.sol"
2279         bytes32 currentState;
2280 
2281         // UTC timestamp at which the proposal was created
2282         uint256 timeCreated;
2283 
2284         // DoublyLinkedList of IPFS doc hashes of the various versions of the proposal
2285         DoublyLinkedList.Bytes proposalVersionDocs;
2286 
2287         // Mapping of version (IPFS doc hash) to ProposalVersion struct
2288         mapping (bytes32 => ProposalVersion) proposalVersions;
2289 
2290         // Voting struct for the draft voting round
2291         Voting draftVoting;
2292 
2293         // Mapping of voting round index (starts from 0) to Voting struct
2294         // votingRounds[0] is the Voting round of the proposal, which lasts for get_uint_config(CONFIG_VOTING_PHASE_TOTAL)
2295         // votingRounds[i] for i>0 are the Interim Voting rounds of the proposal, which lasts for get_uint_config(CONFIG_INTERIM_PHASE_TOTAL)
2296         mapping (uint256 => Voting) votingRounds;
2297 
2298         // Every proposal has a collateral tied to it with a value of
2299         // get_uint_config(CONFIG_PREPROPOSAL_COLLATERAL) (refer "./../storage/DaoConfigsStorage.sol")
2300         // Collateral can be in different states
2301         // refer COLLATERAL_STATUS_* in "./../common/DaoConstants.sol"
2302         uint256 collateralStatus;
2303         uint256 collateralAmount;
2304 
2305         // The final version of the proposal
2306         // Every proposal needs to be finalized before it can be voted on
2307         // This is the IPFS doc hash of the final version
2308         bytes32 finalVersion;
2309 
2310         // List of PrlAction structs
2311         // These are all the actions done by the PRL on the proposal
2312         PrlAction[] prlActions;
2313 
2314         // Address of the user who created the proposal
2315         address proposer;
2316 
2317         // Address of the moderator who endorsed the proposal
2318         address endorser;
2319 
2320         // Boolean whether the proposal is paused/stopped at the moment
2321         bool isPausedOrStopped;
2322 
2323         // Boolean whether the proposal was created by a founder role
2324         bool isDigix;
2325     }
2326 
2327     function countVotes(Voting storage _voting, address[] _allUsers)
2328         external
2329         view
2330         returns (uint256 _for, uint256 _against)
2331     {
2332         uint256 _n = _allUsers.length;
2333         for (uint256 i = 0; i < _n; i++) {
2334             if (_voting.yesVotes[_allUsers[i]] > 0) {
2335                 _for = _for.add(_voting.yesVotes[_allUsers[i]]);
2336             } else if (_voting.noVotes[_allUsers[i]] > 0) {
2337                 _against = _against.add(_voting.noVotes[_allUsers[i]]);
2338             }
2339         }
2340     }
2341 
2342     // get the list of voters who voted _vote (true-yes/false-no)
2343     function listVotes(Voting storage _voting, address[] _allUsers, bool _vote)
2344         external
2345         view
2346         returns (address[] memory _voters, uint256 _length)
2347     {
2348         uint256 _n = _allUsers.length;
2349         uint256 i;
2350         _length = 0;
2351         _voters = new address[](_n);
2352         if (_vote == true) {
2353             for (i = 0; i < _n; i++) {
2354                 if (_voting.yesVotes[_allUsers[i]] > 0) {
2355                     _voters[_length] = _allUsers[i];
2356                     _length++;
2357                 }
2358             }
2359         } else {
2360             for (i = 0; i < _n; i++) {
2361                 if (_voting.noVotes[_allUsers[i]] > 0) {
2362                     _voters[_length] = _allUsers[i];
2363                     _length++;
2364                 }
2365             }
2366         }
2367     }
2368 
2369     function readVote(Voting storage _voting, address _voter)
2370         public
2371         view
2372         returns (bool _vote, uint256 _weight)
2373     {
2374         if (_voting.yesVotes[_voter] > 0) {
2375             _weight = _voting.yesVotes[_voter];
2376             _vote = true;
2377         } else {
2378             _weight = _voting.noVotes[_voter]; // if _voter didnt vote at all, the weight will be 0 anyway
2379             _vote = false;
2380         }
2381     }
2382 
2383     function revealVote(
2384         Voting storage _voting,
2385         address _voter,
2386         bool _vote,
2387         uint256 _weight
2388     )
2389         public
2390     {
2391         if (_vote) {
2392             _voting.yesVotes[_voter] = _weight;
2393         } else {
2394             _voting.noVotes[_voter] = _weight;
2395         }
2396     }
2397 
2398     function readVersion(ProposalVersion storage _version)
2399         public
2400         view
2401         returns (
2402             bytes32 _doc,
2403             uint256 _created,
2404             uint256[] _milestoneFundings,
2405             uint256 _finalReward
2406         )
2407     {
2408         _doc = _version.docIpfsHash;
2409         _created = _version.created;
2410         _milestoneFundings = _version.milestoneFundings;
2411         _finalReward = _version.finalReward;
2412     }
2413 
2414     // read the funding for a particular milestone of a finalized proposal
2415     // if _milestoneId is the same as _milestoneCount, it returns the final reward
2416     function readProposalMilestone(Proposal storage _proposal, uint256 _milestoneIndex)
2417         public
2418         view
2419         returns (uint256 _funding)
2420     {
2421         bytes32 _finalVersion = _proposal.finalVersion;
2422         uint256 _milestoneCount = _proposal.proposalVersions[_finalVersion].milestoneFundings.length;
2423         require(_milestoneIndex <= _milestoneCount);
2424         require(_finalVersion != EMPTY_BYTES); // the proposal must have been finalized
2425 
2426         if (_milestoneIndex < _milestoneCount) {
2427             _funding = _proposal.proposalVersions[_finalVersion].milestoneFundings[_milestoneIndex];
2428         } else {
2429             _funding = _proposal.proposalVersions[_finalVersion].finalReward;
2430         }
2431     }
2432 
2433     function addProposalVersion(
2434         Proposal storage _proposal,
2435         bytes32 _newDoc,
2436         uint256[] _newMilestoneFundings,
2437         uint256 _finalReward
2438     )
2439         public
2440     {
2441         _proposal.proposalVersionDocs.append(_newDoc);
2442         _proposal.proposalVersions[_newDoc].docIpfsHash = _newDoc;
2443         _proposal.proposalVersions[_newDoc].created = now;
2444         _proposal.proposalVersions[_newDoc].milestoneCount = _newMilestoneFundings.length;
2445         _proposal.proposalVersions[_newDoc].milestoneFundings = _newMilestoneFundings;
2446         _proposal.proposalVersions[_newDoc].finalReward = _finalReward;
2447     }
2448 
2449     struct SpecialProposal {
2450         // ID of the special proposal
2451         // This is the IPFS doc hash of the proposal
2452         bytes32 proposalId;
2453 
2454         // UTC timestamp at which the proposal was created
2455         uint256 timeCreated;
2456 
2457         // Voting struct for the special proposal
2458         Voting voting;
2459 
2460         // List of the new uint256 configs as per the special proposal
2461         uint256[] uintConfigs;
2462 
2463         // List of the new address configs as per the special proposal
2464         address[] addressConfigs;
2465 
2466         // List of the new bytes32 configs as per the special proposal
2467         bytes32[] bytesConfigs;
2468 
2469         // Address of the user who created the special proposal
2470         // This address should also be in the ROLES_FOUNDERS group
2471         // refer "./../storage/DaoIdentityStorage.sol"
2472         address proposer;
2473     }
2474 
2475     // All configs are as per the DaoConfigsStorage values at the time when
2476     // calculateGlobalRewardsBeforeNewQuarter is called by founder in that quarter
2477     struct DaoQuarterInfo {
2478         // The minimum quarter points required
2479         // below this, reputation will be deducted
2480         uint256 minimalParticipationPoint;
2481 
2482         // The scaling factor for quarter point
2483         uint256 quarterPointScalingFactor;
2484 
2485         // The scaling factor for reputation point
2486         uint256 reputationPointScalingFactor;
2487 
2488         // The summation of effectiveDGDs in the previous quarter
2489         // The effectiveDGDs represents the effective participation in DigixDAO in a quarter
2490         // Which depends on lockedDGDStake, quarter point and reputation point
2491         // This value is the summation of all participant effectiveDGDs
2492         // It will be used to calculate the fraction of effectiveDGD a user has,
2493         // which will determine his portion of DGX rewards for that quarter
2494         uint256 totalEffectiveDGDPreviousQuarter;
2495 
2496         // The minimum moderator quarter point required
2497         // below this, reputation will be deducted for moderators
2498         uint256 moderatorMinimalParticipationPoint;
2499 
2500         // the scaling factor for moderator quarter point
2501         uint256 moderatorQuarterPointScalingFactor;
2502 
2503         // the scaling factor for moderator reputation point
2504         uint256 moderatorReputationPointScalingFactor;
2505 
2506         // The summation of effectiveDGDs (only specific to moderators)
2507         uint256 totalEffectiveModeratorDGDLastQuarter;
2508 
2509         // UTC timestamp from which the DGX rewards for the previous quarter are distributable to Holders
2510         uint256 dgxDistributionDay;
2511 
2512         // This is the rewards pool for the previous quarter. This is the sum of the DGX fees coming in from the collector, and the demurrage that has incurred
2513         // when user call claimRewards() in the previous quarter.
2514         // more graphical explanation: https://ipfs.io/ipfs/QmZDgFFMbyF3dvuuDfoXv5F6orq4kaDPo7m3QvnseUguzo
2515         uint256 dgxRewardsPoolLastQuarter;
2516 
2517         // The summation of all dgxRewardsPoolLastQuarter up until this quarter
2518         uint256 sumRewardsFromBeginning;
2519     }
2520 
2521     // There are many function calls where all calculations/summations cannot be done in one transaction
2522     // and require multiple transactions.
2523     // This struct stores the intermediate results in between the calculating transactions
2524     // These intermediate results are stored in IntermediateResultsStorage
2525     struct IntermediateResults {
2526         // weight of "FOR" votes counted up until the current calculation step
2527         uint256 currentForCount;
2528 
2529         // weight of "AGAINST" votes counted up until the current calculation step
2530         uint256 currentAgainstCount;
2531 
2532         // summation of effectiveDGDs up until the iteration of calculation
2533         uint256 currentSumOfEffectiveBalance;
2534 
2535         // Address of user until which the calculation has been done
2536         address countedUntil;
2537     }
2538 }
2539 
2540 // File: contracts/storage/DaoStorage.sol
2541 pragma solidity ^0.4.25;
2542 
2543 contract DaoStorage is DaoWhitelistingCommon, BytesIteratorStorage {
2544     using DoublyLinkedList for DoublyLinkedList.Bytes;
2545     using DaoStructs for DaoStructs.Voting;
2546     using DaoStructs for DaoStructs.Proposal;
2547     using DaoStructs for DaoStructs.ProposalVersion;
2548 
2549     // List of all the proposals ever created in DigixDAO
2550     DoublyLinkedList.Bytes allProposals;
2551 
2552     // mapping of Proposal struct by its ID
2553     // ID is also the IPFS doc hash of the first ever version of this proposal
2554     mapping (bytes32 => DaoStructs.Proposal) proposalsById;
2555 
2556     // mapping from state of a proposal to list of all proposals in that state
2557     // proposals are added/removed from the state's list as their states change
2558     // eg. when proposal is endorsed, when proposal is funded, etc
2559     mapping (bytes32 => DoublyLinkedList.Bytes) proposalsByState;
2560 
2561     constructor(address _resolver) public {
2562         require(init(CONTRACT_STORAGE_DAO, _resolver));
2563     }
2564 
2565     /////////////////////////////// READ FUNCTIONS //////////////////////////////
2566 
2567     /// @notice read all information and details of proposal
2568     /// @param _proposalId Proposal ID, i.e. hash of IPFS doc Proposal ID, i.e. hash of IPFS doc
2569     /// return {
2570     ///   "_doc": "Original IPFS doc of proposal, also ID of proposal",
2571     ///   "_proposer": "Address of the proposer",
2572     ///   "_endorser": "Address of the moderator that endorsed the proposal",
2573     ///   "_state": "Current state of the proposal",
2574     ///   "_timeCreated": "UTC timestamp at which proposal was created",
2575     ///   "_nVersions": "Number of versions of the proposal",
2576     ///   "_latestVersionDoc": "IPFS doc hash of the latest version of this proposal",
2577     ///   "_finalVersion": "If finalized, the version of the final proposal",
2578     ///   "_pausedOrStopped": "If the proposal is paused/stopped at the moment",
2579     ///   "_isDigixProposal": "If the proposal has been created by founder or not"
2580     /// }
2581     function readProposal(bytes32 _proposalId)
2582         public
2583         view
2584         returns (
2585             bytes32 _doc,
2586             address _proposer,
2587             address _endorser,
2588             bytes32 _state,
2589             uint256 _timeCreated,
2590             uint256 _nVersions,
2591             bytes32 _latestVersionDoc,
2592             bytes32 _finalVersion,
2593             bool _pausedOrStopped,
2594             bool _isDigixProposal
2595         )
2596     {
2597         require(senderIsAllowedToRead());
2598         DaoStructs.Proposal storage _proposal = proposalsById[_proposalId];
2599         _doc = _proposal.proposalId;
2600         _proposer = _proposal.proposer;
2601         _endorser = _proposal.endorser;
2602         _state = _proposal.currentState;
2603         _timeCreated = _proposal.timeCreated;
2604         _nVersions = read_total_bytesarray(_proposal.proposalVersionDocs);
2605         _latestVersionDoc = read_last_from_bytesarray(_proposal.proposalVersionDocs);
2606         _finalVersion = _proposal.finalVersion;
2607         _pausedOrStopped = _proposal.isPausedOrStopped;
2608         _isDigixProposal = _proposal.isDigix;
2609     }
2610 
2611     function readProposalProposer(bytes32 _proposalId)
2612         public
2613         view
2614         returns (address _proposer)
2615     {
2616         _proposer = proposalsById[_proposalId].proposer;
2617     }
2618 
2619     function readTotalPrlActions(bytes32 _proposalId)
2620         public
2621         view
2622         returns (uint256 _length)
2623     {
2624         _length = proposalsById[_proposalId].prlActions.length;
2625     }
2626 
2627     function readPrlAction(bytes32 _proposalId, uint256 _index)
2628         public
2629         view
2630         returns (uint256 _actionId, uint256 _time, bytes32 _doc)
2631     {
2632         DaoStructs.PrlAction[] memory _actions = proposalsById[_proposalId].prlActions;
2633         require(_index < _actions.length);
2634         _actionId = _actions[_index].actionId;
2635         _time = _actions[_index].at;
2636         _doc = _actions[_index].doc;
2637     }
2638 
2639     function readProposalDraftVotingResult(bytes32 _proposalId)
2640         public
2641         view
2642         returns (bool _result)
2643     {
2644         require(senderIsAllowedToRead());
2645         _result = proposalsById[_proposalId].draftVoting.passed;
2646     }
2647 
2648     function readProposalVotingResult(bytes32 _proposalId, uint256 _index)
2649         public
2650         view
2651         returns (bool _result)
2652     {
2653         require(senderIsAllowedToRead());
2654         _result = proposalsById[_proposalId].votingRounds[_index].passed;
2655     }
2656 
2657     function readProposalDraftVotingTime(bytes32 _proposalId)
2658         public
2659         view
2660         returns (uint256 _start)
2661     {
2662         require(senderIsAllowedToRead());
2663         _start = proposalsById[_proposalId].draftVoting.startTime;
2664     }
2665 
2666     function readProposalVotingTime(bytes32 _proposalId, uint256 _index)
2667         public
2668         view
2669         returns (uint256 _start)
2670     {
2671         require(senderIsAllowedToRead());
2672         _start = proposalsById[_proposalId].votingRounds[_index].startTime;
2673     }
2674 
2675     function readDraftVotingCount(bytes32 _proposalId, address[] _allUsers)
2676         external
2677         view
2678         returns (uint256 _for, uint256 _against)
2679     {
2680         require(senderIsAllowedToRead());
2681         return proposalsById[_proposalId].draftVoting.countVotes(_allUsers);
2682     }
2683 
2684     function readVotingCount(bytes32 _proposalId, uint256 _index, address[] _allUsers)
2685         external
2686         view
2687         returns (uint256 _for, uint256 _against)
2688     {
2689         require(senderIsAllowedToRead());
2690         return proposalsById[_proposalId].votingRounds[_index].countVotes(_allUsers);
2691     }
2692 
2693     function readVotingRoundVotes(bytes32 _proposalId, uint256 _index, address[] _allUsers, bool _vote)
2694         external
2695         view
2696         returns (address[] memory _voters, uint256 _length)
2697     {
2698         require(senderIsAllowedToRead());
2699         return proposalsById[_proposalId].votingRounds[_index].listVotes(_allUsers, _vote);
2700     }
2701 
2702     function readDraftVote(bytes32 _proposalId, address _voter)
2703         public
2704         view
2705         returns (bool _vote, uint256 _weight)
2706     {
2707         require(senderIsAllowedToRead());
2708         return proposalsById[_proposalId].draftVoting.readVote(_voter);
2709     }
2710 
2711     /// @notice returns the latest committed vote by a voter on a proposal
2712     /// @param _proposalId proposal ID
2713     /// @param _voter address of the voter
2714     /// @return {
2715     ///   "_commitHash": ""
2716     /// }
2717     function readComittedVote(bytes32 _proposalId, uint256 _index, address _voter)
2718         public
2719         view
2720         returns (bytes32 _commitHash)
2721     {
2722         require(senderIsAllowedToRead());
2723         _commitHash = proposalsById[_proposalId].votingRounds[_index].commits[_voter];
2724     }
2725 
2726     function readVote(bytes32 _proposalId, uint256 _index, address _voter)
2727         public
2728         view
2729         returns (bool _vote, uint256 _weight)
2730     {
2731         require(senderIsAllowedToRead());
2732         return proposalsById[_proposalId].votingRounds[_index].readVote(_voter);
2733     }
2734 
2735     /// @notice get all information and details of the first proposal
2736     /// return {
2737     ///   "_id": ""
2738     /// }
2739     function getFirstProposal()
2740         public
2741         view
2742         returns (bytes32 _id)
2743     {
2744         _id = read_first_from_bytesarray(allProposals);
2745     }
2746 
2747     /// @notice get all information and details of the last proposal
2748     /// return {
2749     ///   "_id": ""
2750     /// }
2751     function getLastProposal()
2752         public
2753         view
2754         returns (bytes32 _id)
2755     {
2756         _id = read_last_from_bytesarray(allProposals);
2757     }
2758 
2759     /// @notice get all information and details of proposal next to _proposalId
2760     /// @param _proposalId Proposal ID, i.e. hash of IPFS doc
2761     /// return {
2762     ///   "_id": ""
2763     /// }
2764     function getNextProposal(bytes32 _proposalId)
2765         public
2766         view
2767         returns (bytes32 _id)
2768     {
2769         _id = read_next_from_bytesarray(
2770             allProposals,
2771             _proposalId
2772         );
2773     }
2774 
2775     /// @notice get all information and details of proposal previous to _proposalId
2776     /// @param _proposalId Proposal ID, i.e. hash of IPFS doc
2777     /// return {
2778     ///   "_id": ""
2779     /// }
2780     function getPreviousProposal(bytes32 _proposalId)
2781         public
2782         view
2783         returns (bytes32 _id)
2784     {
2785         _id = read_previous_from_bytesarray(
2786             allProposals,
2787             _proposalId
2788         );
2789     }
2790 
2791     /// @notice get all information and details of the first proposal in state _stateId
2792     /// @param _stateId State ID of the proposal
2793     /// return {
2794     ///   "_id": ""
2795     /// }
2796     function getFirstProposalInState(bytes32 _stateId)
2797         public
2798         view
2799         returns (bytes32 _id)
2800     {
2801         require(senderIsAllowedToRead());
2802         _id = read_first_from_bytesarray(proposalsByState[_stateId]);
2803     }
2804 
2805     /// @notice get all information and details of the last proposal in state _stateId
2806     /// @param _stateId State ID of the proposal
2807     /// return {
2808     ///   "_id": ""
2809     /// }
2810     function getLastProposalInState(bytes32 _stateId)
2811         public
2812         view
2813         returns (bytes32 _id)
2814     {
2815         require(senderIsAllowedToRead());
2816         _id = read_last_from_bytesarray(proposalsByState[_stateId]);
2817     }
2818 
2819     /// @notice get all information and details of the next proposal to _proposalId in state _stateId
2820     /// @param _stateId State ID of the proposal
2821     /// return {
2822     ///   "_id": ""
2823     /// }
2824     function getNextProposalInState(bytes32 _stateId, bytes32 _proposalId)
2825         public
2826         view
2827         returns (bytes32 _id)
2828     {
2829         require(senderIsAllowedToRead());
2830         _id = read_next_from_bytesarray(
2831             proposalsByState[_stateId],
2832             _proposalId
2833         );
2834     }
2835 
2836     /// @notice get all information and details of the previous proposal to _proposalId in state _stateId
2837     /// @param _stateId State ID of the proposal
2838     /// return {
2839     ///   "_id": ""
2840     /// }
2841     function getPreviousProposalInState(bytes32 _stateId, bytes32 _proposalId)
2842         public
2843         view
2844         returns (bytes32 _id)
2845     {
2846         require(senderIsAllowedToRead());
2847         _id = read_previous_from_bytesarray(
2848             proposalsByState[_stateId],
2849             _proposalId
2850         );
2851     }
2852 
2853     /// @notice read proposal version details for a specific version
2854     /// @param _proposalId Proposal ID, i.e. hash of IPFS doc
2855     /// @param _version Version of proposal, i.e. hash of IPFS doc for specific version
2856     /// return {
2857     ///   "_doc": "",
2858     ///   "_created": "",
2859     ///   "_milestoneFundings": ""
2860     /// }
2861     function readProposalVersion(bytes32 _proposalId, bytes32 _version)
2862         public
2863         view
2864         returns (
2865             bytes32 _doc,
2866             uint256 _created,
2867             uint256[] _milestoneFundings,
2868             uint256 _finalReward
2869         )
2870     {
2871         return proposalsById[_proposalId].proposalVersions[_version].readVersion();
2872     }
2873 
2874     /**
2875     @notice Read the fundings of a finalized proposal
2876     @return {
2877         "_fundings": "fundings for the milestones",
2878         "_finalReward": "the final reward"
2879     }
2880     */
2881     function readProposalFunding(bytes32 _proposalId)
2882         public
2883         view
2884         returns (uint256[] memory _fundings, uint256 _finalReward)
2885     {
2886         require(senderIsAllowedToRead());
2887         bytes32 _finalVersion = proposalsById[_proposalId].finalVersion;
2888         require(_finalVersion != EMPTY_BYTES);
2889         _fundings = proposalsById[_proposalId].proposalVersions[_finalVersion].milestoneFundings;
2890         _finalReward = proposalsById[_proposalId].proposalVersions[_finalVersion].finalReward;
2891     }
2892 
2893     function readProposalMilestone(bytes32 _proposalId, uint256 _index)
2894         public
2895         view
2896         returns (uint256 _funding)
2897     {
2898         require(senderIsAllowedToRead());
2899         _funding = proposalsById[_proposalId].readProposalMilestone(_index);
2900     }
2901 
2902     /// @notice get proposal version details for the first version
2903     /// @param _proposalId Proposal ID, i.e. hash of IPFS doc
2904     /// return {
2905     ///   "_version": ""
2906     /// }
2907     function getFirstProposalVersion(bytes32 _proposalId)
2908         public
2909         view
2910         returns (bytes32 _version)
2911     {
2912         DaoStructs.Proposal storage _proposal = proposalsById[_proposalId];
2913         _version = read_first_from_bytesarray(_proposal.proposalVersionDocs);
2914     }
2915 
2916     /// @notice get proposal version details for the last version
2917     /// @param _proposalId Proposal ID, i.e. hash of IPFS doc
2918     /// return {
2919     ///   "_version": ""
2920     /// }
2921     function getLastProposalVersion(bytes32 _proposalId)
2922         public
2923         view
2924         returns (bytes32 _version)
2925     {
2926         DaoStructs.Proposal storage _proposal = proposalsById[_proposalId];
2927         _version = read_last_from_bytesarray(_proposal.proposalVersionDocs);
2928     }
2929 
2930     /// @notice get proposal version details for the next version to _version
2931     /// @param _proposalId Proposal ID, i.e. hash of IPFS doc
2932     /// @param _version Version of proposal
2933     /// return {
2934     ///   "_nextVersion": ""
2935     /// }
2936     function getNextProposalVersion(bytes32 _proposalId, bytes32 _version)
2937         public
2938         view
2939         returns (bytes32 _nextVersion)
2940     {
2941         DaoStructs.Proposal storage _proposal = proposalsById[_proposalId];
2942         _nextVersion = read_next_from_bytesarray(
2943             _proposal.proposalVersionDocs,
2944             _version
2945         );
2946     }
2947 
2948     /// @notice get proposal version details for the previous version to _version
2949     /// @param _proposalId Proposal ID, i.e. hash of IPFS doc
2950     /// @param _version Version of proposal
2951     /// return {
2952     ///   "_previousVersion": ""
2953     /// }
2954     function getPreviousProposalVersion(bytes32 _proposalId, bytes32 _version)
2955         public
2956         view
2957         returns (bytes32 _previousVersion)
2958     {
2959         DaoStructs.Proposal storage _proposal = proposalsById[_proposalId];
2960         _previousVersion = read_previous_from_bytesarray(
2961             _proposal.proposalVersionDocs,
2962             _version
2963         );
2964     }
2965 
2966     function isDraftClaimed(bytes32 _proposalId)
2967         public
2968         view
2969         returns (bool _claimed)
2970     {
2971         _claimed = proposalsById[_proposalId].draftVoting.claimed;
2972     }
2973 
2974     function isClaimed(bytes32 _proposalId, uint256 _index)
2975         public
2976         view
2977         returns (bool _claimed)
2978     {
2979         _claimed = proposalsById[_proposalId].votingRounds[_index].claimed;
2980     }
2981 
2982     function readProposalCollateralStatus(bytes32 _proposalId)
2983         public
2984         view
2985         returns (uint256 _status)
2986     {
2987         require(senderIsAllowedToRead());
2988         _status = proposalsById[_proposalId].collateralStatus;
2989     }
2990 
2991     function readProposalCollateralAmount(bytes32 _proposalId)
2992         public
2993         view
2994         returns (uint256 _amount)
2995     {
2996         _amount = proposalsById[_proposalId].collateralAmount;
2997     }
2998 
2999     /// @notice Read the additional docs that are added after the proposal is finalized
3000     /// @dev Will throw if the propsal is not finalized yet
3001     function readProposalDocs(bytes32 _proposalId)
3002         public
3003         view
3004         returns (bytes32[] _moreDocs)
3005     {
3006         bytes32 _finalVersion = proposalsById[_proposalId].finalVersion;
3007         require(_finalVersion != EMPTY_BYTES);
3008         _moreDocs = proposalsById[_proposalId].proposalVersions[_finalVersion].moreDocs;
3009     }
3010 
3011     function readIfMilestoneFunded(bytes32 _proposalId, uint256 _milestoneId)
3012         public
3013         view
3014         returns (bool _funded)
3015     {
3016         require(senderIsAllowedToRead());
3017         _funded = proposalsById[_proposalId].votingRounds[_milestoneId].funded;
3018     }
3019 
3020     ////////////////////////////// WRITE FUNCTIONS //////////////////////////////
3021 
3022     function addProposal(
3023         bytes32 _doc,
3024         address _proposer,
3025         uint256[] _milestoneFundings,
3026         uint256 _finalReward,
3027         bool _isFounder
3028     )
3029         external
3030     {
3031         require(sender_is(CONTRACT_DAO));
3032         require(
3033           (proposalsById[_doc].proposalId == EMPTY_BYTES) &&
3034           (_doc != EMPTY_BYTES)
3035         );
3036 
3037         allProposals.append(_doc);
3038         proposalsByState[PROPOSAL_STATE_PREPROPOSAL].append(_doc);
3039         proposalsById[_doc].proposalId = _doc;
3040         proposalsById[_doc].proposer = _proposer;
3041         proposalsById[_doc].currentState = PROPOSAL_STATE_PREPROPOSAL;
3042         proposalsById[_doc].timeCreated = now;
3043         proposalsById[_doc].isDigix = _isFounder;
3044         proposalsById[_doc].addProposalVersion(_doc, _milestoneFundings, _finalReward);
3045     }
3046 
3047     function editProposal(
3048         bytes32 _proposalId,
3049         bytes32 _newDoc,
3050         uint256[] _newMilestoneFundings,
3051         uint256 _finalReward
3052     )
3053         external
3054     {
3055         require(sender_is(CONTRACT_DAO));
3056 
3057         proposalsById[_proposalId].addProposalVersion(_newDoc, _newMilestoneFundings, _finalReward);
3058     }
3059 
3060     /// @notice change fundings of a proposal
3061     /// @dev Will throw if the proposal is not finalized yet
3062     function changeFundings(bytes32 _proposalId, uint256[] _newMilestoneFundings, uint256 _finalReward)
3063         external
3064     {
3065         require(sender_is(CONTRACT_DAO));
3066 
3067         bytes32 _finalVersion = proposalsById[_proposalId].finalVersion;
3068         require(_finalVersion != EMPTY_BYTES);
3069         proposalsById[_proposalId].proposalVersions[_finalVersion].milestoneFundings = _newMilestoneFundings;
3070         proposalsById[_proposalId].proposalVersions[_finalVersion].finalReward = _finalReward;
3071     }
3072 
3073     /// @dev Will throw if the proposal is not finalized yet
3074     function addProposalDoc(bytes32 _proposalId, bytes32 _newDoc)
3075         public
3076     {
3077         require(sender_is(CONTRACT_DAO));
3078 
3079         bytes32 _finalVersion = proposalsById[_proposalId].finalVersion;
3080         require(_finalVersion != EMPTY_BYTES); //already checked in interactive layer, but why not
3081         proposalsById[_proposalId].proposalVersions[_finalVersion].moreDocs.push(_newDoc);
3082     }
3083 
3084     function finalizeProposal(bytes32 _proposalId)
3085         public
3086     {
3087         require(sender_is(CONTRACT_DAO));
3088 
3089         proposalsById[_proposalId].finalVersion = getLastProposalVersion(_proposalId);
3090     }
3091 
3092     function updateProposalEndorse(
3093         bytes32 _proposalId,
3094         address _endorser
3095     )
3096         public
3097     {
3098         require(sender_is(CONTRACT_DAO));
3099 
3100         DaoStructs.Proposal storage _proposal = proposalsById[_proposalId];
3101         _proposal.endorser = _endorser;
3102         _proposal.currentState = PROPOSAL_STATE_DRAFT;
3103         proposalsByState[PROPOSAL_STATE_PREPROPOSAL].remove_item(_proposalId);
3104         proposalsByState[PROPOSAL_STATE_DRAFT].append(_proposalId);
3105     }
3106 
3107     function setProposalDraftPass(bytes32 _proposalId, bool _result)
3108         public
3109     {
3110         require(sender_is(CONTRACT_DAO_VOTING_CLAIMS));
3111 
3112         proposalsById[_proposalId].draftVoting.passed = _result;
3113         if (_result) {
3114             proposalsByState[PROPOSAL_STATE_DRAFT].remove_item(_proposalId);
3115             proposalsByState[PROPOSAL_STATE_MODERATED].append(_proposalId);
3116             proposalsById[_proposalId].currentState = PROPOSAL_STATE_MODERATED;
3117         } else {
3118             closeProposalInternal(_proposalId);
3119         }
3120     }
3121 
3122     function setProposalPass(bytes32 _proposalId, uint256 _index, bool _result)
3123         public
3124     {
3125         require(sender_is(CONTRACT_DAO_VOTING_CLAIMS));
3126 
3127         if (!_result) {
3128             closeProposalInternal(_proposalId);
3129         } else if (_index == 0) {
3130             proposalsByState[PROPOSAL_STATE_MODERATED].remove_item(_proposalId);
3131             proposalsByState[PROPOSAL_STATE_ONGOING].append(_proposalId);
3132             proposalsById[_proposalId].currentState = PROPOSAL_STATE_ONGOING;
3133         }
3134         proposalsById[_proposalId].votingRounds[_index].passed = _result;
3135     }
3136 
3137     function setProposalDraftVotingTime(
3138         bytes32 _proposalId,
3139         uint256 _time
3140     )
3141         public
3142     {
3143         require(sender_is(CONTRACT_DAO));
3144 
3145         proposalsById[_proposalId].draftVoting.startTime = _time;
3146     }
3147 
3148     function setProposalVotingTime(
3149         bytes32 _proposalId,
3150         uint256 _index,
3151         uint256 _time
3152     )
3153         public
3154     {
3155         require(sender_is_from([CONTRACT_DAO, CONTRACT_DAO_VOTING_CLAIMS, EMPTY_BYTES]));
3156 
3157         proposalsById[_proposalId].votingRounds[_index].startTime = _time;
3158     }
3159 
3160     function setDraftVotingClaim(bytes32 _proposalId, bool _claimed)
3161         public
3162     {
3163         require(sender_is(CONTRACT_DAO_VOTING_CLAIMS));
3164         proposalsById[_proposalId].draftVoting.claimed = _claimed;
3165     }
3166 
3167     function setVotingClaim(bytes32 _proposalId, uint256 _index, bool _claimed)
3168         public
3169     {
3170         require(sender_is(CONTRACT_DAO_VOTING_CLAIMS));
3171         proposalsById[_proposalId].votingRounds[_index].claimed = _claimed;
3172     }
3173 
3174     function setProposalCollateralStatus(bytes32 _proposalId, uint256 _status)
3175         public
3176     {
3177         require(sender_is_from([CONTRACT_DAO_VOTING_CLAIMS, CONTRACT_DAO_FUNDING_MANAGER, CONTRACT_DAO]));
3178         proposalsById[_proposalId].collateralStatus = _status;
3179     }
3180 
3181     function setProposalCollateralAmount(bytes32 _proposalId, uint256 _amount)
3182         public
3183     {
3184         require(sender_is(CONTRACT_DAO));
3185         proposalsById[_proposalId].collateralAmount = _amount;
3186     }
3187 
3188     function updateProposalPRL(
3189         bytes32 _proposalId,
3190         uint256 _action,
3191         bytes32 _doc,
3192         uint256 _time
3193     )
3194         public
3195     {
3196         require(sender_is(CONTRACT_DAO));
3197         require(proposalsById[_proposalId].currentState != PROPOSAL_STATE_CLOSED);
3198 
3199         DaoStructs.PrlAction memory prlAction;
3200         prlAction.at = _time;
3201         prlAction.doc = _doc;
3202         prlAction.actionId = _action;
3203         proposalsById[_proposalId].prlActions.push(prlAction);
3204 
3205         if (_action == PRL_ACTION_PAUSE) {
3206           proposalsById[_proposalId].isPausedOrStopped = true;
3207         } else if (_action == PRL_ACTION_UNPAUSE) {
3208           proposalsById[_proposalId].isPausedOrStopped = false;
3209         } else { // STOP
3210           proposalsById[_proposalId].isPausedOrStopped = true;
3211           closeProposalInternal(_proposalId);
3212         }
3213     }
3214 
3215     function closeProposalInternal(bytes32 _proposalId)
3216         internal
3217     {
3218         bytes32 _currentState = proposalsById[_proposalId].currentState;
3219         proposalsByState[_currentState].remove_item(_proposalId);
3220         proposalsByState[PROPOSAL_STATE_CLOSED].append(_proposalId);
3221         proposalsById[_proposalId].currentState = PROPOSAL_STATE_CLOSED;
3222     }
3223 
3224     function addDraftVote(
3225         bytes32 _proposalId,
3226         address _voter,
3227         bool _vote,
3228         uint256 _weight
3229     )
3230         public
3231     {
3232         require(sender_is(CONTRACT_DAO_VOTING));
3233 
3234         DaoStructs.Proposal storage _proposal = proposalsById[_proposalId];
3235         if (_vote) {
3236             _proposal.draftVoting.yesVotes[_voter] = _weight;
3237             if (_proposal.draftVoting.noVotes[_voter] > 0) { // minimize number of writes to storage, since EIP-1087 is not implemented yet
3238                 _proposal.draftVoting.noVotes[_voter] = 0;
3239             }
3240         } else {
3241             _proposal.draftVoting.noVotes[_voter] = _weight;
3242             if (_proposal.draftVoting.yesVotes[_voter] > 0) {
3243                 _proposal.draftVoting.yesVotes[_voter] = 0;
3244             }
3245         }
3246     }
3247 
3248     function commitVote(
3249         bytes32 _proposalId,
3250         bytes32 _hash,
3251         address _voter,
3252         uint256 _index
3253     )
3254         public
3255     {
3256         require(sender_is(CONTRACT_DAO_VOTING));
3257 
3258         proposalsById[_proposalId].votingRounds[_index].commits[_voter] = _hash;
3259     }
3260 
3261     function revealVote(
3262         bytes32 _proposalId,
3263         address _voter,
3264         bool _vote,
3265         uint256 _weight,
3266         uint256 _index
3267     )
3268         public
3269     {
3270         require(sender_is(CONTRACT_DAO_VOTING));
3271 
3272         proposalsById[_proposalId].votingRounds[_index].revealVote(_voter, _vote, _weight);
3273     }
3274 
3275     function closeProposal(bytes32 _proposalId)
3276         public
3277     {
3278         require(sender_is(CONTRACT_DAO));
3279         closeProposalInternal(_proposalId);
3280     }
3281 
3282     function archiveProposal(bytes32 _proposalId)
3283         public
3284     {
3285         require(sender_is(CONTRACT_DAO_VOTING_CLAIMS));
3286         bytes32 _currentState = proposalsById[_proposalId].currentState;
3287         proposalsByState[_currentState].remove_item(_proposalId);
3288         proposalsByState[PROPOSAL_STATE_ARCHIVED].append(_proposalId);
3289         proposalsById[_proposalId].currentState = PROPOSAL_STATE_ARCHIVED;
3290     }
3291 
3292     function setMilestoneFunded(bytes32 _proposalId, uint256 _milestoneId)
3293         public
3294     {
3295         require(sender_is(CONTRACT_DAO_FUNDING_MANAGER));
3296         proposalsById[_proposalId].votingRounds[_milestoneId].funded = true;
3297     }
3298 }
3299 
3300 // File: @digix/solidity-collections/contracts/abstract/AddressIteratorStorage.sol
3301 pragma solidity ^0.4.19;
3302 
3303 /**
3304   @title Address Iterator Storage
3305   @author DigixGlobal Pte Ltd
3306   @notice See: [Doubly Linked List](/DoublyLinkedList)
3307 */
3308 contract AddressIteratorStorage {
3309 
3310   // Initialize Doubly Linked List of Address
3311   using DoublyLinkedList for DoublyLinkedList.Address;
3312 
3313   /**
3314     @notice Reads the first item from the list of Address
3315     @param _list The source list
3316     @return {"_item" : "The first item from the list"}
3317   */
3318   function read_first_from_addresses(DoublyLinkedList.Address storage _list)
3319            internal
3320            constant
3321            returns (address _item)
3322   {
3323     _item = _list.start_item();
3324   }
3325 
3326 
3327   /**
3328     @notice Reads the last item from the list of Address
3329     @param _list The source list
3330     @return {"_item" : "The last item from the list"}
3331   */
3332   function read_last_from_addresses(DoublyLinkedList.Address storage _list)
3333            internal
3334            constant
3335            returns (address _item)
3336   {
3337     _item = _list.end_item();
3338   }
3339 
3340   /**
3341     @notice Reads the next item on the list of Address
3342     @param _list The source list
3343     @param _current_item The current item to be used as base line
3344     @return {"_item" : "The next item from the list based on the specieid `_current_item`"}
3345   */
3346   function read_next_from_addresses(DoublyLinkedList.Address storage _list, address _current_item)
3347            internal
3348            constant
3349            returns (address _item)
3350   {
3351     _item = _list.next_item(_current_item);
3352   }
3353 
3354   /**
3355     @notice Reads the previous item on the list of Address
3356     @param _list The source list
3357     @param _current_item The current item to be used as base line
3358     @return {"_item" : "The previous item from the list based on the spcified `_current_item`"}
3359   */
3360   function read_previous_from_addresses(DoublyLinkedList.Address storage _list, address _current_item)
3361            internal
3362            constant
3363            returns (address _item)
3364   {
3365     _item = _list.previous_item(_current_item);
3366   }
3367 
3368   /**
3369     @notice Reads the list of Address and returns the length of the list
3370     @param _list The source list
3371     @return {"_count": "The lenght of the list"}
3372   */
3373   function read_total_addresses(DoublyLinkedList.Address storage _list)
3374            internal
3375            constant
3376            returns (uint256 _count)
3377   {
3378     _count = _list.total();
3379   }
3380 
3381 }
3382 
3383 // File: contracts/storage/DaoStakeStorage.sol
3384 pragma solidity ^0.4.25;
3385 
3386 contract DaoStakeStorage is ResolverClient, DaoConstants, AddressIteratorStorage {
3387     using DoublyLinkedList for DoublyLinkedList.Address;
3388 
3389     // This is the DGD stake of a user (one that is considered in the DAO)
3390     mapping (address => uint256) public lockedDGDStake;
3391 
3392     // This is the actual number of DGDs locked by user
3393     // may be more than the lockedDGDStake
3394     // in case they locked during the main phase
3395     mapping (address => uint256) public actualLockedDGD;
3396 
3397     // The total locked DGDs in the DAO (summation of lockedDGDStake)
3398     uint256 public totalLockedDGDStake;
3399 
3400     // The total locked DGDs by moderators
3401     uint256 public totalModeratorLockedDGDStake;
3402 
3403     // The list of participants in DAO
3404     // actual participants will be subset of this list
3405     DoublyLinkedList.Address allParticipants;
3406 
3407     // The list of moderators in DAO
3408     // actual moderators will be subset of this list
3409     DoublyLinkedList.Address allModerators;
3410 
3411     // Boolean to mark if an address has redeemed
3412     // reputation points for their DGD Badge
3413     mapping (address => bool) public redeemedBadge;
3414 
3415     // mapping to note whether an address has claimed their
3416     // reputation bonus for carbon vote participation
3417     mapping (address => bool) public carbonVoteBonusClaimed;
3418 
3419     constructor(address _resolver) public {
3420         require(init(CONTRACT_STORAGE_DAO_STAKE, _resolver));
3421     }
3422 
3423     function redeemBadge(address _user)
3424         public
3425     {
3426         require(sender_is(CONTRACT_DAO_STAKE_LOCKING));
3427         redeemedBadge[_user] = true;
3428     }
3429 
3430     function setCarbonVoteBonusClaimed(address _user)
3431         public
3432     {
3433         require(sender_is(CONTRACT_DAO_STAKE_LOCKING));
3434         carbonVoteBonusClaimed[_user] = true;
3435     }
3436 
3437     function updateTotalLockedDGDStake(uint256 _totalLockedDGDStake)
3438         public
3439     {
3440         require(sender_is_from([CONTRACT_DAO_STAKE_LOCKING, CONTRACT_DAO_REWARDS_MANAGER, EMPTY_BYTES]));
3441         totalLockedDGDStake = _totalLockedDGDStake;
3442     }
3443 
3444     function updateTotalModeratorLockedDGDs(uint256 _totalLockedDGDStake)
3445         public
3446     {
3447         require(sender_is_from([CONTRACT_DAO_STAKE_LOCKING, CONTRACT_DAO_REWARDS_MANAGER, EMPTY_BYTES]));
3448         totalModeratorLockedDGDStake = _totalLockedDGDStake;
3449     }
3450 
3451     function updateUserDGDStake(address _user, uint256 _actualLockedDGD, uint256 _lockedDGDStake)
3452         public
3453     {
3454         require(sender_is(CONTRACT_DAO_STAKE_LOCKING));
3455         actualLockedDGD[_user] = _actualLockedDGD;
3456         lockedDGDStake[_user] = _lockedDGDStake;
3457     }
3458 
3459     function readUserDGDStake(address _user)
3460         public
3461         view
3462         returns (
3463             uint256 _actualLockedDGD,
3464             uint256 _lockedDGDStake
3465         )
3466     {
3467         _actualLockedDGD = actualLockedDGD[_user];
3468         _lockedDGDStake = lockedDGDStake[_user];
3469     }
3470 
3471     function addToParticipantList(address _user)
3472         public
3473         returns (bool _success)
3474     {
3475         require(sender_is(CONTRACT_DAO_STAKE_LOCKING));
3476         _success = allParticipants.append(_user);
3477     }
3478 
3479     function removeFromParticipantList(address _user)
3480         public
3481         returns (bool _success)
3482     {
3483         require(sender_is(CONTRACT_DAO_STAKE_LOCKING));
3484         _success = allParticipants.remove_item(_user);
3485     }
3486 
3487     function addToModeratorList(address _user)
3488         public
3489         returns (bool _success)
3490     {
3491         require(sender_is(CONTRACT_DAO_STAKE_LOCKING));
3492         _success = allModerators.append(_user);
3493     }
3494 
3495     function removeFromModeratorList(address _user)
3496         public
3497         returns (bool _success)
3498     {
3499         require(sender_is(CONTRACT_DAO_STAKE_LOCKING));
3500         _success = allModerators.remove_item(_user);
3501     }
3502 
3503     function isInParticipantList(address _user)
3504         public
3505         view
3506         returns (bool _is)
3507     {
3508         _is = allParticipants.find(_user) != 0;
3509     }
3510 
3511     function isInModeratorsList(address _user)
3512         public
3513         view
3514         returns (bool _is)
3515     {
3516         _is = allModerators.find(_user) != 0;
3517     }
3518 
3519     function readFirstModerator()
3520         public
3521         view
3522         returns (address _item)
3523     {
3524         _item = read_first_from_addresses(allModerators);
3525     }
3526 
3527     function readLastModerator()
3528         public
3529         view
3530         returns (address _item)
3531     {
3532         _item = read_last_from_addresses(allModerators);
3533     }
3534 
3535     function readNextModerator(address _current_item)
3536         public
3537         view
3538         returns (address _item)
3539     {
3540         _item = read_next_from_addresses(allModerators, _current_item);
3541     }
3542 
3543     function readPreviousModerator(address _current_item)
3544         public
3545         view
3546         returns (address _item)
3547     {
3548         _item = read_previous_from_addresses(allModerators, _current_item);
3549     }
3550 
3551     function readTotalModerators()
3552         public
3553         view
3554         returns (uint256 _total_count)
3555     {
3556         _total_count = read_total_addresses(allModerators);
3557     }
3558 
3559     function readFirstParticipant()
3560         public
3561         view
3562         returns (address _item)
3563     {
3564         _item = read_first_from_addresses(allParticipants);
3565     }
3566 
3567     function readLastParticipant()
3568         public
3569         view
3570         returns (address _item)
3571     {
3572         _item = read_last_from_addresses(allParticipants);
3573     }
3574 
3575     function readNextParticipant(address _current_item)
3576         public
3577         view
3578         returns (address _item)
3579     {
3580         _item = read_next_from_addresses(allParticipants, _current_item);
3581     }
3582 
3583     function readPreviousParticipant(address _current_item)
3584         public
3585         view
3586         returns (address _item)
3587     {
3588         _item = read_previous_from_addresses(allParticipants, _current_item);
3589     }
3590 
3591     function readTotalParticipant()
3592         public
3593         view
3594         returns (uint256 _total_count)
3595     {
3596         _total_count = read_total_addresses(allParticipants);
3597     }
3598 }
3599 
3600 // File: contracts/service/DaoListingService.sol
3601 pragma solidity ^0.4.25;
3602 
3603 /**
3604 @title Contract to list various storage states from DigixDAO
3605 @author Digix Holdings
3606 */
3607 contract DaoListingService is
3608     AddressIteratorInteractive,
3609     BytesIteratorInteractive,
3610     IndexedBytesIteratorInteractive,
3611     DaoWhitelistingCommon
3612 {
3613 
3614     /**
3615     @notice Constructor
3616     @param _resolver address of contract resolver
3617     */
3618     constructor(address _resolver) public {
3619         require(init(CONTRACT_SERVICE_DAO_LISTING, _resolver));
3620     }
3621 
3622     function daoStakeStorage()
3623         internal
3624         view
3625         returns (DaoStakeStorage _contract)
3626     {
3627         _contract = DaoStakeStorage(get_contract(CONTRACT_STORAGE_DAO_STAKE));
3628     }
3629 
3630     function daoStorage()
3631         internal
3632         view
3633         returns (DaoStorage _contract)
3634     {
3635         _contract = DaoStorage(get_contract(CONTRACT_STORAGE_DAO));
3636     }
3637 
3638     /**
3639     @notice function to list moderators
3640     @dev note that this list may include some additional entries that are
3641          not moderators in the current quarter. This may happen if they
3642          were moderators in the previous quarter, but have not confirmed
3643          their participation in the current quarter. For a single address,
3644          a better way to know if moderator or not is:
3645          Dao.isModerator(_user)
3646     @param _count number of addresses to list
3647     @param _from_start boolean, whether to list from start or end
3648     @return {
3649       "_moderators": "list of moderator addresses"
3650     }
3651     */
3652     function listModerators(uint256 _count, bool _from_start)
3653         public
3654         view
3655         returns (address[] _moderators)
3656     {
3657         _moderators = list_addresses(
3658             _count,
3659             daoStakeStorage().readFirstModerator,
3660             daoStakeStorage().readLastModerator,
3661             daoStakeStorage().readNextModerator,
3662             daoStakeStorage().readPreviousModerator,
3663             _from_start
3664         );
3665     }
3666 
3667     /**
3668     @notice function to list moderators from a particular moderator
3669     @dev note that this list may include some additional entries that are
3670          not moderators in the current quarter. This may happen if they
3671          were moderators in the previous quarter, but have not confirmed
3672          their participation in the current quarter. For a single address,
3673          a better way to know if moderator or not is:
3674          Dao.isModerator(_user)
3675 
3676          Another note: this function will start listing AFTER the _currentModerator
3677          For example: we have [address1, address2, address3, address4]. listModeratorsFrom(address1, 2, true) = [address2, address3]
3678     @param _currentModerator start the list after this moderator address
3679     @param _count number of addresses to list
3680     @param _from_start boolean, whether to list from start or end
3681     @return {
3682       "_moderators": "list of moderator addresses"
3683     }
3684     */
3685     function listModeratorsFrom(
3686         address _currentModerator,
3687         uint256 _count,
3688         bool _from_start
3689     )
3690         public
3691         view
3692         returns (address[] _moderators)
3693     {
3694         _moderators = list_addresses_from(
3695             _currentModerator,
3696             _count,
3697             daoStakeStorage().readFirstModerator,
3698             daoStakeStorage().readLastModerator,
3699             daoStakeStorage().readNextModerator,
3700             daoStakeStorage().readPreviousModerator,
3701             _from_start
3702         );
3703     }
3704 
3705     /**
3706     @notice function to list participants
3707     @dev note that this list may include some additional entries that are
3708          not participants in the current quarter. This may happen if they
3709          were participants in the previous quarter, but have not confirmed
3710          their participation in the current quarter. For a single address,
3711          a better way to know if participant or not is:
3712          Dao.isParticipant(_user)
3713     @param _count number of addresses to list
3714     @param _from_start boolean, whether to list from start or end
3715     @return {
3716       "_participants": "list of participant addresses"
3717     }
3718     */
3719     function listParticipants(uint256 _count, bool _from_start)
3720         public
3721         view
3722         returns (address[] _participants)
3723     {
3724         _participants = list_addresses(
3725             _count,
3726             daoStakeStorage().readFirstParticipant,
3727             daoStakeStorage().readLastParticipant,
3728             daoStakeStorage().readNextParticipant,
3729             daoStakeStorage().readPreviousParticipant,
3730             _from_start
3731         );
3732     }
3733 
3734     /**
3735     @notice function to list participants from a particular participant
3736     @dev note that this list may include some additional entries that are
3737          not participants in the current quarter. This may happen if they
3738          were participants in the previous quarter, but have not confirmed
3739          their participation in the current quarter. For a single address,
3740          a better way to know if participant or not is:
3741          contracts.dao.isParticipant(_user)
3742 
3743          Another note: this function will start listing AFTER the _currentParticipant
3744          For example: we have [address1, address2, address3, address4]. listParticipantsFrom(address1, 2, true) = [address2, address3]
3745     @param _currentParticipant list from AFTER this participant address
3746     @param _count number of addresses to list
3747     @param _from_start boolean, whether to list from start or end
3748     @return {
3749       "_participants": "list of participant addresses"
3750     }
3751     */
3752     function listParticipantsFrom(
3753         address _currentParticipant,
3754         uint256 _count,
3755         bool _from_start
3756     )
3757         public
3758         view
3759         returns (address[] _participants)
3760     {
3761         _participants = list_addresses_from(
3762             _currentParticipant,
3763             _count,
3764             daoStakeStorage().readFirstParticipant,
3765             daoStakeStorage().readLastParticipant,
3766             daoStakeStorage().readNextParticipant,
3767             daoStakeStorage().readPreviousParticipant,
3768             _from_start
3769         );
3770     }
3771 
3772     /**
3773     @notice function to list _count no. of proposals
3774     @param _count number of proposals to list
3775     @param _from_start boolean value, true if count from start, false if count from end
3776     @return {
3777       "_proposals": "the list of proposal IDs"
3778     }
3779     */
3780     function listProposals(
3781         uint256 _count,
3782         bool _from_start
3783     )
3784         public
3785         view
3786         returns (bytes32[] _proposals)
3787     {
3788         _proposals = list_bytesarray(
3789             _count,
3790             daoStorage().getFirstProposal,
3791             daoStorage().getLastProposal,
3792             daoStorage().getNextProposal,
3793             daoStorage().getPreviousProposal,
3794             _from_start
3795         );
3796     }
3797 
3798     /**
3799     @notice function to list _count no. of proposals from AFTER _currentProposal
3800     @param _currentProposal ID of proposal to list proposals from
3801     @param _count number of proposals to list
3802     @param _from_start boolean value, true if count forwards, false if count backwards
3803     @return {
3804       "_proposals": "the list of proposal IDs"
3805     }
3806     */
3807     function listProposalsFrom(
3808         bytes32 _currentProposal,
3809         uint256 _count,
3810         bool _from_start
3811     )
3812         public
3813         view
3814         returns (bytes32[] _proposals)
3815     {
3816         _proposals = list_bytesarray_from(
3817             _currentProposal,
3818             _count,
3819             daoStorage().getFirstProposal,
3820             daoStorage().getLastProposal,
3821             daoStorage().getNextProposal,
3822             daoStorage().getPreviousProposal,
3823             _from_start
3824         );
3825     }
3826 
3827     /**
3828     @notice function to list _count no. of proposals in state _stateId
3829     @param _stateId state of proposal
3830     @param _count number of proposals to list
3831     @param _from_start boolean value, true if count from start, false if count from end
3832     @return {
3833       "_proposals": "the list of proposal IDs"
3834     }
3835     */
3836     function listProposalsInState(
3837         bytes32 _stateId,
3838         uint256 _count,
3839         bool _from_start
3840     )
3841         public
3842         view
3843         returns (bytes32[] _proposals)
3844     {
3845         require(senderIsAllowedToRead());
3846         _proposals = list_indexed_bytesarray(
3847             _stateId,
3848             _count,
3849             daoStorage().getFirstProposalInState,
3850             daoStorage().getLastProposalInState,
3851             daoStorage().getNextProposalInState,
3852             daoStorage().getPreviousProposalInState,
3853             _from_start
3854         );
3855     }
3856 
3857     /**
3858     @notice function to list _count no. of proposals in state _stateId from AFTER _currentProposal
3859     @param _stateId state of proposal
3860     @param _currentProposal ID of proposal to list proposals from
3861     @param _count number of proposals to list
3862     @param _from_start boolean value, true if count forwards, false if count backwards
3863     @return {
3864       "_proposals": "the list of proposal IDs"
3865     }
3866     */
3867     function listProposalsInStateFrom(
3868         bytes32 _stateId,
3869         bytes32 _currentProposal,
3870         uint256 _count,
3871         bool _from_start
3872     )
3873         public
3874         view
3875         returns (bytes32[] _proposals)
3876     {
3877         require(senderIsAllowedToRead());
3878         _proposals = list_indexed_bytesarray_from(
3879             _stateId,
3880             _currentProposal,
3881             _count,
3882             daoStorage().getFirstProposalInState,
3883             daoStorage().getLastProposalInState,
3884             daoStorage().getNextProposalInState,
3885             daoStorage().getPreviousProposalInState,
3886             _from_start
3887         );
3888     }
3889 
3890     /**
3891     @notice function to list proposal versions
3892     @param _proposalId ID of the proposal
3893     @param _count number of proposal versions to list
3894     @param _from_start boolean, true to list from start, false to list from end
3895     @return {
3896       "_versions": "list of proposal versions"
3897     }
3898     */
3899     function listProposalVersions(
3900         bytes32 _proposalId,
3901         uint256 _count,
3902         bool _from_start
3903     )
3904         public
3905         view
3906         returns (bytes32[] _versions)
3907     {
3908         _versions = list_indexed_bytesarray(
3909             _proposalId,
3910             _count,
3911             daoStorage().getFirstProposalVersion,
3912             daoStorage().getLastProposalVersion,
3913             daoStorage().getNextProposalVersion,
3914             daoStorage().getPreviousProposalVersion,
3915             _from_start
3916         );
3917     }
3918 
3919     /**
3920     @notice function to list proposal versions from AFTER a particular version
3921     @param _proposalId ID of the proposal
3922     @param _currentVersion version to list _count versions from
3923     @param _count number of proposal versions to list
3924     @param _from_start boolean, true to list from start, false to list from end
3925     @return {
3926       "_versions": "list of proposal versions"
3927     }
3928     */
3929     function listProposalVersionsFrom(
3930         bytes32 _proposalId,
3931         bytes32 _currentVersion,
3932         uint256 _count,
3933         bool _from_start
3934     )
3935         public
3936         view
3937         returns (bytes32[] _versions)
3938     {
3939         _versions = list_indexed_bytesarray_from(
3940             _proposalId,
3941             _currentVersion,
3942             _count,
3943             daoStorage().getFirstProposalVersion,
3944             daoStorage().getLastProposalVersion,
3945             daoStorage().getNextProposalVersion,
3946             daoStorage().getPreviousProposalVersion,
3947             _from_start
3948         );
3949     }
3950 }
3951 
3952 // File: @digix/solidity-collections/contracts/abstract/IndexedAddressIteratorStorage.sol
3953 pragma solidity ^0.4.19;
3954 
3955 /**
3956   @title Indexed Address IteratorStorage
3957   @author DigixGlobal Pte Ltd
3958   @notice This contract utilizes: [Doubly Linked List](/DoublyLinkedList)
3959 */
3960 contract IndexedAddressIteratorStorage {
3961 
3962   using DoublyLinkedList for DoublyLinkedList.IndexedAddress;
3963   /**
3964     @notice Reads the first item from an Indexed Address Doubly Linked List
3965     @param _list The source list
3966     @param _collection_index Index of the Collection to evaluate
3967     @return {"_item" : "First item on the list"}
3968   */
3969   function read_first_from_indexed_addresses(DoublyLinkedList.IndexedAddress storage _list, bytes32 _collection_index)
3970            internal
3971            constant
3972            returns (address _item)
3973   {
3974     _item = _list.start_item(_collection_index);
3975   }
3976 
3977   /**
3978     @notice Reads the last item from an Indexed Address Doubly Linked list
3979     @param _list The source list
3980     @param _collection_index Index of the Collection to evaluate
3981     @return {"_item" : "First item on the list"}
3982   */
3983   function read_last_from_indexed_addresses(DoublyLinkedList.IndexedAddress storage _list, bytes32 _collection_index)
3984            internal
3985            constant
3986            returns (address _item)
3987   {
3988     _item = _list.end_item(_collection_index);
3989   }
3990 
3991   /**
3992     @notice Reads the next item from an Indexed Address Doubly Linked List based on the specified `_current_item`
3993     @param _list The source list
3994     @param _collection_index Index of the Collection to evaluate
3995     @param _current_item The current item to use as base line
3996     @return {"_item": "The next item on the list"}
3997   */
3998   function read_next_from_indexed_addresses(DoublyLinkedList.IndexedAddress storage _list, bytes32 _collection_index, address _current_item)
3999            internal
4000            constant
4001            returns (address _item)
4002   {
4003     _item = _list.next_item(_collection_index, _current_item);
4004   }
4005 
4006   /**
4007     @notice Reads the previous item from an Index Address Doubly Linked List based on the specified `_current_item`
4008     @param _list The source list
4009     @param _collection_index Index of the Collection to evaluate
4010     @param _current_item The current item to use as base line
4011     @return {"_item" : "The previous item on the list"}
4012   */
4013   function read_previous_from_indexed_addresses(DoublyLinkedList.IndexedAddress storage _list, bytes32 _collection_index, address _current_item)
4014            internal
4015            constant
4016            returns (address _item)
4017   {
4018     _item = _list.previous_item(_collection_index, _current_item);
4019   }
4020 
4021 
4022   /**
4023     @notice Reads the total number of items in an Indexed Address Doubly Linked List
4024     @param _list  The source list
4025     @param _collection_index Index of the Collection to evaluate
4026     @return {"_count": "Length of the Doubly Linked list"}
4027   */
4028   function read_total_indexed_addresses(DoublyLinkedList.IndexedAddress storage _list, bytes32 _collection_index)
4029            internal
4030            constant
4031            returns (uint256 _count)
4032   {
4033     _count = _list.total(_collection_index);
4034   }
4035 
4036 }
4037 
4038 // File: @digix/solidity-collections/contracts/abstract/UintIteratorStorage.sol
4039 pragma solidity ^0.4.19;
4040 
4041 /**
4042   @title Uint Iterator Storage
4043   @author DigixGlobal Pte Ltd
4044 */
4045 contract UintIteratorStorage {
4046 
4047   using DoublyLinkedList for DoublyLinkedList.Uint;
4048 
4049   /**
4050     @notice Returns the first item from a `DoublyLinkedList.Uint` list
4051     @param _list The DoublyLinkedList.Uint list
4052     @return {"_item": "The first item"}
4053   */
4054   function read_first_from_uints(DoublyLinkedList.Uint storage _list)
4055            internal
4056            constant
4057            returns (uint256 _item)
4058   {
4059     _item = _list.start_item();
4060   }
4061 
4062   /**
4063     @notice Returns the last item from a `DoublyLinkedList.Uint` list
4064     @param _list The DoublyLinkedList.Uint list
4065     @return {"_item": "The last item"}
4066   */
4067   function read_last_from_uints(DoublyLinkedList.Uint storage _list)
4068            internal
4069            constant
4070            returns (uint256 _item)
4071   {
4072     _item = _list.end_item();
4073   }
4074 
4075   /**
4076     @notice Returns the next item from a `DoublyLinkedList.Uint` list based on the specified `_current_item`
4077     @param _list The DoublyLinkedList.Uint list
4078     @param _current_item The current item
4079     @return {"_item": "The next item"}
4080   */
4081   function read_next_from_uints(DoublyLinkedList.Uint storage _list, uint256 _current_item)
4082            internal
4083            constant
4084            returns (uint256 _item)
4085   {
4086     _item = _list.next_item(_current_item);
4087   }
4088 
4089   /**
4090     @notice Returns the previous item from a `DoublyLinkedList.Uint` list based on the specified `_current_item`
4091     @param _list The DoublyLinkedList.Uint list
4092     @param _current_item The current item
4093     @return {"_item": "The previous item"}
4094   */
4095   function read_previous_from_uints(DoublyLinkedList.Uint storage _list, uint256 _current_item)
4096            internal
4097            constant
4098            returns (uint256 _item)
4099   {
4100     _item = _list.previous_item(_current_item);
4101   }
4102 
4103   /**
4104     @notice Returns the total count of itemsfrom a `DoublyLinkedList.Uint` list
4105     @param _list The DoublyLinkedList.Uint list
4106     @return {"_count": "The total count of items"}
4107   */
4108   function read_total_uints(DoublyLinkedList.Uint storage _list)
4109            internal
4110            constant
4111            returns (uint256 _count)
4112   {
4113     _count = _list.total();
4114   }
4115 
4116 }
4117 
4118 // File: @digix/cdap/contracts/storage/DirectoryStorage.sol
4119 pragma solidity ^0.4.16;
4120 
4121 /**
4122 @title Directory Storage contains information of a directory
4123 @author DigixGlobal
4124 */
4125 contract DirectoryStorage is IndexedAddressIteratorStorage, UintIteratorStorage {
4126 
4127   using DoublyLinkedList for DoublyLinkedList.IndexedAddress;
4128   using DoublyLinkedList for DoublyLinkedList.Uint;
4129 
4130   struct User {
4131     bytes32 document;
4132     bool active;
4133   }
4134 
4135   struct Group {
4136     bytes32 name;
4137     bytes32 document;
4138     uint256 role_id;
4139     mapping(address => User) members_by_address;
4140   }
4141 
4142   struct System {
4143     DoublyLinkedList.Uint groups;
4144     DoublyLinkedList.IndexedAddress groups_collection;
4145     mapping (uint256 => Group) groups_by_id;
4146     mapping (address => uint256) group_ids_by_address;
4147     mapping (uint256 => bytes32) roles_by_id;
4148     bool initialized;
4149     uint256 total_groups;
4150   }
4151 
4152   System system;
4153 
4154   /**
4155   @notice Initializes directory settings
4156   @return _success If directory initialization is successful
4157   */
4158   function initialize_directory()
4159            internal
4160            returns (bool _success)
4161   {
4162     require(system.initialized == false);
4163     system.total_groups = 0;
4164     system.initialized = true;
4165     internal_create_role(1, "root");
4166     internal_create_group(1, "root", "");
4167     _success = internal_update_add_user_to_group(1, tx.origin, "");
4168   }
4169 
4170   /**
4171   @notice Creates a new role with the given information
4172   @param _role_id Id of the new role
4173   @param _name Name of the new role
4174   @return {"_success": "If creation of new role is successful"}
4175   */
4176   function internal_create_role(uint256 _role_id, bytes32 _name)
4177            internal
4178            returns (bool _success)
4179   {
4180     require(_role_id > 0);
4181     require(_name != bytes32(0x0));
4182     system.roles_by_id[_role_id] = _name;
4183     _success = true;
4184   }
4185 
4186   /**
4187   @notice Returns the role's name of a role id
4188   @param _role_id Id of the role
4189   @return {"_name": "Name of the role"}
4190   */
4191   function read_role(uint256 _role_id)
4192            public
4193            constant
4194            returns (bytes32 _name)
4195   {
4196     _name = system.roles_by_id[_role_id];
4197   }
4198 
4199   /**
4200   @notice Creates a new group with the given information
4201   @param _role_id Role id of the new group
4202   @param _name Name of the new group
4203   @param _document Document of the new group
4204   @return {
4205     "_success": "If creation of the new group is successful",
4206     "_group_id: "Id of the new group"
4207   }
4208   */
4209   function internal_create_group(uint256 _role_id, bytes32 _name, bytes32 _document)
4210            internal
4211            returns (bool _success, uint256 _group_id)
4212   {
4213     require(_role_id > 0);
4214     require(read_role(_role_id) != bytes32(0x0));
4215     _group_id = ++system.total_groups;
4216     system.groups.append(_group_id);
4217     system.groups_by_id[_group_id].role_id = _role_id;
4218     system.groups_by_id[_group_id].name = _name;
4219     system.groups_by_id[_group_id].document = _document;
4220     _success = true;
4221   }
4222 
4223   /**
4224   @notice Returns the group's information
4225   @param _group_id Id of the group
4226   @return {
4227     "_role_id": "Role id of the group",
4228     "_name: "Name of the group",
4229     "_document: "Document of the group"
4230   }
4231   */
4232   function read_group(uint256 _group_id)
4233            public
4234            constant
4235            returns (uint256 _role_id, bytes32 _name, bytes32 _document, uint256 _members_count)
4236   {
4237     if (system.groups.valid_item(_group_id)) {
4238       _role_id = system.groups_by_id[_group_id].role_id;
4239       _name = system.groups_by_id[_group_id].name;
4240       _document = system.groups_by_id[_group_id].document;
4241       _members_count = read_total_indexed_addresses(system.groups_collection, bytes32(_group_id));
4242     } else {
4243       _role_id = 0;
4244       _name = "invalid";
4245       _document = "";
4246       _members_count = 0;
4247     }
4248   }
4249 
4250   /**
4251   @notice Adds new user with the given information to a group
4252   @param _group_id Id of the group
4253   @param _user Address of the new user
4254   @param _document Information of the new user
4255   @return {"_success": "If adding new user to a group is successful"}
4256   */
4257   function internal_update_add_user_to_group(uint256 _group_id, address _user, bytes32 _document)
4258            internal
4259            returns (bool _success)
4260   {
4261     if (system.groups_by_id[_group_id].members_by_address[_user].active == false && system.group_ids_by_address[_user] == 0 && system.groups_by_id[_group_id].role_id != 0) {
4262 
4263       system.groups_by_id[_group_id].members_by_address[_user].active = true;
4264       system.group_ids_by_address[_user] = _group_id;
4265       system.groups_collection.append(bytes32(_group_id), _user);
4266       system.groups_by_id[_group_id].members_by_address[_user].document = _document;
4267       _success = true;
4268     } else {
4269       _success = false;
4270     }
4271   }
4272 
4273   /**
4274   @notice Removes user from its group
4275   @param _user Address of the user
4276   @return {"_success": "If removing of user is successful"}
4277   */
4278   function internal_destroy_group_user(address _user)
4279            internal
4280            returns (bool _success)
4281   {
4282     uint256 _group_id = system.group_ids_by_address[_user];
4283     if ((_group_id == 1) && (system.groups_collection.total(bytes32(_group_id)) == 1)) {
4284       _success = false;
4285     } else {
4286       system.groups_by_id[_group_id].members_by_address[_user].active = false;
4287       system.group_ids_by_address[_user] = 0;
4288       delete system.groups_by_id[_group_id].members_by_address[_user];
4289       _success = system.groups_collection.remove_item(bytes32(_group_id), _user);
4290     }
4291   }
4292 
4293   /**
4294   @notice Returns the role id of a user
4295   @param _user Address of a user
4296   @return {"_role_id": "Role id of the user"}
4297   */
4298   function read_user_role_id(address _user)
4299            constant
4300            public
4301            returns (uint256 _role_id)
4302   {
4303     uint256 _group_id = system.group_ids_by_address[_user];
4304     _role_id = system.groups_by_id[_group_id].role_id;
4305   }
4306 
4307   /**
4308   @notice Returns the user's information
4309   @param _user Address of the user
4310   @return {
4311     "_group_id": "Group id of the user",
4312     "_role_id": "Role id of the user",
4313     "_document": "Information of the user"
4314   }
4315   */
4316   function read_user(address _user)
4317            public
4318            constant
4319            returns (uint256 _group_id, uint256 _role_id, bytes32 _document)
4320   {
4321     _group_id = system.group_ids_by_address[_user];
4322     _role_id = system.groups_by_id[_group_id].role_id;
4323     _document = system.groups_by_id[_group_id].members_by_address[_user].document;
4324   }
4325 
4326   /**
4327   @notice Returns the id of the first group
4328   @return {"_group_id": "Id of the first group"}
4329   */
4330   function read_first_group()
4331            view
4332            external
4333            returns (uint256 _group_id)
4334   {
4335     _group_id = read_first_from_uints(system.groups);
4336   }
4337 
4338   /**
4339   @notice Returns the id of the last group
4340   @return {"_group_id": "Id of the last group"}
4341   */
4342   function read_last_group()
4343            view
4344            external
4345            returns (uint256 _group_id)
4346   {
4347     _group_id = read_last_from_uints(system.groups);
4348   }
4349 
4350   /**
4351   @notice Returns the id of the previous group depending on the given current group
4352   @param _current_group_id Id of the current group
4353   @return {"_group_id": "Id of the previous group"}
4354   */
4355   function read_previous_group_from_group(uint256 _current_group_id)
4356            view
4357            external
4358            returns (uint256 _group_id)
4359   {
4360     _group_id = read_previous_from_uints(system.groups, _current_group_id);
4361   }
4362 
4363   /**
4364   @notice Returns the id of the next group depending on the given current group
4365   @param _current_group_id Id of the current group
4366   @return {"_group_id": "Id of the next group"}
4367   */
4368   function read_next_group_from_group(uint256 _current_group_id)
4369            view
4370            external
4371            returns (uint256 _group_id)
4372   {
4373     _group_id = read_next_from_uints(system.groups, _current_group_id);
4374   }
4375 
4376   /**
4377   @notice Returns the total number of groups
4378   @return {"_total_groups": "Total number of groups"}
4379   */
4380   function read_total_groups()
4381            view
4382            external
4383            returns (uint256 _total_groups)
4384   {
4385     _total_groups = read_total_uints(system.groups);
4386   }
4387 
4388   /**
4389   @notice Returns the first user of a group
4390   @param _group_id Id of the group
4391   @return {"_user": "Address of the user"}
4392   */
4393   function read_first_user_in_group(bytes32 _group_id)
4394            view
4395            external
4396            returns (address _user)
4397   {
4398     _user = read_first_from_indexed_addresses(system.groups_collection, bytes32(_group_id));
4399   }
4400 
4401   /**
4402   @notice Returns the last user of a group
4403   @param _group_id Id of the group
4404   @return {"_user": "Address of the user"}
4405   */
4406   function read_last_user_in_group(bytes32 _group_id)
4407            view
4408            external
4409            returns (address _user)
4410   {
4411     _user = read_last_from_indexed_addresses(system.groups_collection, bytes32(_group_id));
4412   }
4413 
4414   /**
4415   @notice Returns the next user of a group depending on the given current user
4416   @param _group_id Id of the group
4417   @param _current_user Address of the current user
4418   @return {"_user": "Address of the next user"}
4419   */
4420   function read_next_user_in_group(bytes32 _group_id, address _current_user)
4421            view
4422            external
4423            returns (address _user)
4424   {
4425     _user = read_next_from_indexed_addresses(system.groups_collection, bytes32(_group_id), _current_user);
4426   }
4427 
4428   /**
4429   @notice Returns the previous user of a group depending on the given current user
4430   @param _group_id Id of the group
4431   @param _current_user Address of the current user
4432   @return {"_user": "Address of the last user"}
4433   */
4434   function read_previous_user_in_group(bytes32 _group_id, address _current_user)
4435            view
4436            external
4437            returns (address _user)
4438   {
4439     _user = read_previous_from_indexed_addresses(system.groups_collection, bytes32(_group_id), _current_user);
4440   }
4441 
4442   /**
4443   @notice Returns the total number of users of a group
4444   @param _group_id Id of the group
4445   @return {"_total_users": "Total number of users"}
4446   */
4447   function read_total_users_in_group(bytes32 _group_id)
4448            view
4449            external
4450            returns (uint256 _total_users)
4451   {
4452     _total_users = read_total_indexed_addresses(system.groups_collection, bytes32(_group_id));
4453   }
4454 }
4455 
4456 // File: contracts/storage/DaoIdentityStorage.sol
4457 pragma solidity ^0.4.25;
4458 
4459 contract DaoIdentityStorage is ResolverClient, DaoConstants, DirectoryStorage {
4460 
4461     // struct for KYC details
4462     // doc is the IPFS doc hash for any information regarding this KYC
4463     // id_expiration is the UTC timestamp at which this KYC will expire
4464     // at any time after this, the user's KYC is invalid, and that user
4465     // MUST re-KYC before doing any proposer related operation in DigixDAO
4466     struct KycDetails {
4467         bytes32 doc;
4468         uint256 id_expiration;
4469     }
4470 
4471     // a mapping of address to the KYC details
4472     mapping (address => KycDetails) kycInfo;
4473 
4474     constructor(address _resolver)
4475         public
4476     {
4477         require(init(CONTRACT_STORAGE_DAO_IDENTITY, _resolver));
4478         require(initialize_directory());
4479     }
4480 
4481     function create_group(uint256 _role_id, bytes32 _name, bytes32 _document)
4482         public
4483         returns (bool _success, uint256 _group_id)
4484     {
4485         require(sender_is(CONTRACT_DAO_IDENTITY));
4486         (_success, _group_id) = internal_create_group(_role_id, _name, _document);
4487         require(_success);
4488     }
4489 
4490     function create_role(uint256 _role_id, bytes32 _name)
4491         public
4492         returns (bool _success)
4493     {
4494         require(sender_is(CONTRACT_DAO_IDENTITY));
4495         _success = internal_create_role(_role_id, _name);
4496         require(_success);
4497     }
4498 
4499     function update_add_user_to_group(uint256 _group_id, address _user, bytes32 _document)
4500         public
4501         returns (bool _success)
4502     {
4503         require(sender_is(CONTRACT_DAO_IDENTITY));
4504         _success = internal_update_add_user_to_group(_group_id, _user, _document);
4505         require(_success);
4506     }
4507 
4508     function update_remove_group_user(address _user)
4509         public
4510         returns (bool _success)
4511     {
4512         require(sender_is(CONTRACT_DAO_IDENTITY));
4513         _success = internal_destroy_group_user(_user);
4514         require(_success);
4515     }
4516 
4517     function update_kyc(address _user, bytes32 _doc, uint256 _id_expiration)
4518         public
4519     {
4520         require(sender_is(CONTRACT_DAO_IDENTITY));
4521         kycInfo[_user].doc = _doc;
4522         kycInfo[_user].id_expiration = _id_expiration;
4523     }
4524 
4525     function read_kyc_info(address _user)
4526         public
4527         view
4528         returns (bytes32 _doc, uint256 _id_expiration)
4529     {
4530         _doc = kycInfo[_user].doc;
4531         _id_expiration = kycInfo[_user].id_expiration;
4532     }
4533 
4534     function is_kyc_approved(address _user)
4535         public
4536         view
4537         returns (bool _approved)
4538     {
4539         uint256 _id_expiration;
4540         (,_id_expiration) = read_kyc_info(_user);
4541         _approved = _id_expiration > now;
4542     }
4543 }
4544 
4545 // File: contracts/common/IdentityCommon.sol
4546 pragma solidity ^0.4.25;
4547 
4548 contract IdentityCommon is DaoWhitelistingCommon {
4549 
4550     modifier if_root() {
4551         require(identity_storage().read_user_role_id(msg.sender) == ROLES_ROOT);
4552         _;
4553     }
4554 
4555     modifier if_founder() {
4556         require(is_founder());
4557         _;
4558     }
4559 
4560     function is_founder()
4561         internal
4562         view
4563         returns (bool _isFounder)
4564     {
4565         _isFounder = identity_storage().read_user_role_id(msg.sender) == ROLES_FOUNDERS;
4566     }
4567 
4568     modifier if_prl() {
4569         require(identity_storage().read_user_role_id(msg.sender) == ROLES_PRLS);
4570         _;
4571     }
4572 
4573     modifier if_kyc_admin() {
4574         require(identity_storage().read_user_role_id(msg.sender) == ROLES_KYC_ADMINS);
4575         _;
4576     }
4577 
4578     function identity_storage()
4579         internal
4580         view
4581         returns (DaoIdentityStorage _contract)
4582     {
4583         _contract = DaoIdentityStorage(get_contract(CONTRACT_STORAGE_DAO_IDENTITY));
4584     }
4585 }
4586 
4587 // File: contracts/storage/DaoConfigsStorage.sol
4588 pragma solidity ^0.4.25;
4589 
4590 contract DaoConfigsStorage is ResolverClient, DaoConstants {
4591 
4592     // mapping of config name to config value
4593     // config names can be found in DaoConstants contract
4594     mapping (bytes32 => uint256) public uintConfigs;
4595 
4596     // mapping of config name to config value
4597     // config names can be found in DaoConstants contract
4598     mapping (bytes32 => address) public addressConfigs;
4599 
4600     // mapping of config name to config value
4601     // config names can be found in DaoConstants contract
4602     mapping (bytes32 => bytes32) public bytesConfigs;
4603 
4604     uint256 ONE_BILLION = 1000000000;
4605     uint256 ONE_MILLION = 1000000;
4606 
4607     constructor(address _resolver)
4608         public
4609     {
4610         require(init(CONTRACT_STORAGE_DAO_CONFIG, _resolver));
4611 
4612         uintConfigs[CONFIG_LOCKING_PHASE_DURATION] = 10 days;
4613         uintConfigs[CONFIG_QUARTER_DURATION] = QUARTER_DURATION;
4614         uintConfigs[CONFIG_VOTING_COMMIT_PHASE] = 14 days;
4615         uintConfigs[CONFIG_VOTING_PHASE_TOTAL] = 21 days;
4616         uintConfigs[CONFIG_INTERIM_COMMIT_PHASE] = 7 days;
4617         uintConfigs[CONFIG_INTERIM_PHASE_TOTAL] = 14 days;
4618 
4619 
4620 
4621         uintConfigs[CONFIG_DRAFT_QUORUM_FIXED_PORTION_NUMERATOR] = 5; // 5%
4622         uintConfigs[CONFIG_DRAFT_QUORUM_FIXED_PORTION_DENOMINATOR] = 100; // 5%
4623         uintConfigs[CONFIG_DRAFT_QUORUM_SCALING_FACTOR_NUMERATOR] = 35; // 35%
4624         uintConfigs[CONFIG_DRAFT_QUORUM_SCALING_FACTOR_DENOMINATOR] = 100; // 35%
4625 
4626 
4627         uintConfigs[CONFIG_VOTING_QUORUM_FIXED_PORTION_NUMERATOR] = 5; // 5%
4628         uintConfigs[CONFIG_VOTING_QUORUM_FIXED_PORTION_DENOMINATOR] = 100; // 5%
4629         uintConfigs[CONFIG_VOTING_QUORUM_SCALING_FACTOR_NUMERATOR] = 25; // 25%
4630         uintConfigs[CONFIG_VOTING_QUORUM_SCALING_FACTOR_DENOMINATOR] = 100; // 25%
4631 
4632         uintConfigs[CONFIG_DRAFT_QUOTA_NUMERATOR] = 1; // >50%
4633         uintConfigs[CONFIG_DRAFT_QUOTA_DENOMINATOR] = 2; // >50%
4634         uintConfigs[CONFIG_VOTING_QUOTA_NUMERATOR] = 1; // >50%
4635         uintConfigs[CONFIG_VOTING_QUOTA_DENOMINATOR] = 2; // >50%
4636 
4637 
4638         uintConfigs[CONFIG_QUARTER_POINT_DRAFT_VOTE] = ONE_BILLION;
4639         uintConfigs[CONFIG_QUARTER_POINT_VOTE] = ONE_BILLION;
4640         uintConfigs[CONFIG_QUARTER_POINT_INTERIM_VOTE] = ONE_BILLION;
4641 
4642         uintConfigs[CONFIG_QUARTER_POINT_MILESTONE_COMPLETION_PER_10000ETH] = 20000 * ONE_BILLION;
4643 
4644         uintConfigs[CONFIG_BONUS_REPUTATION_NUMERATOR] = 15; // 15% bonus for consistent votes
4645         uintConfigs[CONFIG_BONUS_REPUTATION_DENOMINATOR] = 100; // 15% bonus for consistent votes
4646 
4647         uintConfigs[CONFIG_SPECIAL_PROPOSAL_COMMIT_PHASE] = 28 days;
4648         uintConfigs[CONFIG_SPECIAL_PROPOSAL_PHASE_TOTAL] = 35 days;
4649 
4650 
4651 
4652         uintConfigs[CONFIG_SPECIAL_QUOTA_NUMERATOR] = 1; // >50%
4653         uintConfigs[CONFIG_SPECIAL_QUOTA_DENOMINATOR] = 2; // >50%
4654 
4655         uintConfigs[CONFIG_SPECIAL_PROPOSAL_QUORUM_NUMERATOR] = 40; // 40%
4656         uintConfigs[CONFIG_SPECIAL_PROPOSAL_QUORUM_DENOMINATOR] = 100; // 40%
4657 
4658         uintConfigs[CONFIG_MAXIMUM_REPUTATION_DEDUCTION] = 8334 * ONE_MILLION;
4659 
4660         uintConfigs[CONFIG_PUNISHMENT_FOR_NOT_LOCKING] = 1666 * ONE_MILLION;
4661         uintConfigs[CONFIG_REPUTATION_PER_EXTRA_QP_NUM] = 1; // 1 extra QP gains 1/1 RP
4662         uintConfigs[CONFIG_REPUTATION_PER_EXTRA_QP_DEN] = 1;
4663 
4664 
4665         uintConfigs[CONFIG_MINIMAL_QUARTER_POINT] = 2 * ONE_BILLION;
4666         uintConfigs[CONFIG_QUARTER_POINT_SCALING_FACTOR] = 400 * ONE_BILLION;
4667         uintConfigs[CONFIG_REPUTATION_POINT_SCALING_FACTOR] = 2000 * ONE_BILLION;
4668 
4669         uintConfigs[CONFIG_MODERATOR_MINIMAL_QUARTER_POINT] = 4 * ONE_BILLION;
4670         uintConfigs[CONFIG_MODERATOR_QUARTER_POINT_SCALING_FACTOR] = 400 * ONE_BILLION;
4671         uintConfigs[CONFIG_MODERATOR_REPUTATION_POINT_SCALING_FACTOR] = 2000 * ONE_BILLION;
4672 
4673         uintConfigs[CONFIG_PORTION_TO_MODERATORS_NUM] = 42; //4.2% of DGX to moderator voting activity
4674         uintConfigs[CONFIG_PORTION_TO_MODERATORS_DEN] = 1000;
4675 
4676         uintConfigs[CONFIG_DRAFT_VOTING_PHASE] = 10 days;
4677 
4678         uintConfigs[CONFIG_REPUTATION_POINT_BOOST_FOR_BADGE] = 412500 * ONE_MILLION;
4679 
4680         uintConfigs[CONFIG_FINAL_REWARD_SCALING_FACTOR_NUMERATOR] = 7; // 7%
4681         uintConfigs[CONFIG_FINAL_REWARD_SCALING_FACTOR_DENOMINATOR] = 100; // 7%
4682 
4683         uintConfigs[CONFIG_MAXIMUM_MODERATOR_REPUTATION_DEDUCTION] = 12500 * ONE_MILLION;
4684         uintConfigs[CONFIG_REPUTATION_PER_EXTRA_MODERATOR_QP_NUM] = 1;
4685         uintConfigs[CONFIG_REPUTATION_PER_EXTRA_MODERATOR_QP_DEN] = 1;
4686 
4687         uintConfigs[CONFIG_VOTE_CLAIMING_DEADLINE] = 10 days;
4688 
4689         uintConfigs[CONFIG_MINIMUM_LOCKED_DGD] = 10 * ONE_BILLION;
4690         uintConfigs[CONFIG_MINIMUM_DGD_FOR_MODERATOR] = 842 * ONE_BILLION;
4691         uintConfigs[CONFIG_MINIMUM_REPUTATION_FOR_MODERATOR] = 400 * ONE_BILLION;
4692 
4693         uintConfigs[CONFIG_PREPROPOSAL_COLLATERAL] = 2 ether;
4694 
4695         uintConfigs[CONFIG_MAX_FUNDING_FOR_NON_DIGIX] = 100 ether;
4696         uintConfigs[CONFIG_MAX_MILESTONES_FOR_NON_DIGIX] = 5;
4697         uintConfigs[CONFIG_NON_DIGIX_PROPOSAL_CAP_PER_QUARTER] = 80;
4698 
4699         uintConfigs[CONFIG_PROPOSAL_DEAD_DURATION] = 90 days;
4700         uintConfigs[CONFIG_CARBON_VOTE_REPUTATION_BONUS] = 10 * ONE_BILLION;
4701     }
4702 
4703     function updateUintConfigs(uint256[] _uintConfigs)
4704         external
4705     {
4706         require(sender_is(CONTRACT_DAO_SPECIAL_VOTING_CLAIMS));
4707         uintConfigs[CONFIG_LOCKING_PHASE_DURATION] = _uintConfigs[0];
4708         /*
4709         This used to be a config that can be changed. Now, _uintConfigs[1] is just a dummy config that doesnt do anything
4710         uintConfigs[CONFIG_QUARTER_DURATION] = _uintConfigs[1];
4711         */
4712         uintConfigs[CONFIG_VOTING_COMMIT_PHASE] = _uintConfigs[2];
4713         uintConfigs[CONFIG_VOTING_PHASE_TOTAL] = _uintConfigs[3];
4714         uintConfigs[CONFIG_INTERIM_COMMIT_PHASE] = _uintConfigs[4];
4715         uintConfigs[CONFIG_INTERIM_PHASE_TOTAL] = _uintConfigs[5];
4716         uintConfigs[CONFIG_DRAFT_QUORUM_FIXED_PORTION_NUMERATOR] = _uintConfigs[6];
4717         uintConfigs[CONFIG_DRAFT_QUORUM_FIXED_PORTION_DENOMINATOR] = _uintConfigs[7];
4718         uintConfigs[CONFIG_DRAFT_QUORUM_SCALING_FACTOR_NUMERATOR] = _uintConfigs[8];
4719         uintConfigs[CONFIG_DRAFT_QUORUM_SCALING_FACTOR_DENOMINATOR] = _uintConfigs[9];
4720         uintConfigs[CONFIG_VOTING_QUORUM_FIXED_PORTION_NUMERATOR] = _uintConfigs[10];
4721         uintConfigs[CONFIG_VOTING_QUORUM_FIXED_PORTION_DENOMINATOR] = _uintConfigs[11];
4722         uintConfigs[CONFIG_VOTING_QUORUM_SCALING_FACTOR_NUMERATOR] = _uintConfigs[12];
4723         uintConfigs[CONFIG_VOTING_QUORUM_SCALING_FACTOR_DENOMINATOR] = _uintConfigs[13];
4724         uintConfigs[CONFIG_DRAFT_QUOTA_NUMERATOR] = _uintConfigs[14];
4725         uintConfigs[CONFIG_DRAFT_QUOTA_DENOMINATOR] = _uintConfigs[15];
4726         uintConfigs[CONFIG_VOTING_QUOTA_NUMERATOR] = _uintConfigs[16];
4727         uintConfigs[CONFIG_VOTING_QUOTA_DENOMINATOR] = _uintConfigs[17];
4728         uintConfigs[CONFIG_QUARTER_POINT_DRAFT_VOTE] = _uintConfigs[18];
4729         uintConfigs[CONFIG_QUARTER_POINT_VOTE] = _uintConfigs[19];
4730         uintConfigs[CONFIG_QUARTER_POINT_INTERIM_VOTE] = _uintConfigs[20];
4731         uintConfigs[CONFIG_MINIMAL_QUARTER_POINT] = _uintConfigs[21];
4732         uintConfigs[CONFIG_QUARTER_POINT_MILESTONE_COMPLETION_PER_10000ETH] = _uintConfigs[22];
4733         uintConfigs[CONFIG_BONUS_REPUTATION_NUMERATOR] = _uintConfigs[23];
4734         uintConfigs[CONFIG_BONUS_REPUTATION_DENOMINATOR] = _uintConfigs[24];
4735         uintConfigs[CONFIG_SPECIAL_PROPOSAL_COMMIT_PHASE] = _uintConfigs[25];
4736         uintConfigs[CONFIG_SPECIAL_PROPOSAL_PHASE_TOTAL] = _uintConfigs[26];
4737         uintConfigs[CONFIG_SPECIAL_QUOTA_NUMERATOR] = _uintConfigs[27];
4738         uintConfigs[CONFIG_SPECIAL_QUOTA_DENOMINATOR] = _uintConfigs[28];
4739         uintConfigs[CONFIG_SPECIAL_PROPOSAL_QUORUM_NUMERATOR] = _uintConfigs[29];
4740         uintConfigs[CONFIG_SPECIAL_PROPOSAL_QUORUM_DENOMINATOR] = _uintConfigs[30];
4741         uintConfigs[CONFIG_MAXIMUM_REPUTATION_DEDUCTION] = _uintConfigs[31];
4742         uintConfigs[CONFIG_PUNISHMENT_FOR_NOT_LOCKING] = _uintConfigs[32];
4743         uintConfigs[CONFIG_REPUTATION_PER_EXTRA_QP_NUM] = _uintConfigs[33];
4744         uintConfigs[CONFIG_REPUTATION_PER_EXTRA_QP_DEN] = _uintConfigs[34];
4745         uintConfigs[CONFIG_QUARTER_POINT_SCALING_FACTOR] = _uintConfigs[35];
4746         uintConfigs[CONFIG_REPUTATION_POINT_SCALING_FACTOR] = _uintConfigs[36];
4747         uintConfigs[CONFIG_MODERATOR_MINIMAL_QUARTER_POINT] = _uintConfigs[37];
4748         uintConfigs[CONFIG_MODERATOR_QUARTER_POINT_SCALING_FACTOR] = _uintConfigs[38];
4749         uintConfigs[CONFIG_MODERATOR_REPUTATION_POINT_SCALING_FACTOR] = _uintConfigs[39];
4750         uintConfigs[CONFIG_PORTION_TO_MODERATORS_NUM] = _uintConfigs[40];
4751         uintConfigs[CONFIG_PORTION_TO_MODERATORS_DEN] = _uintConfigs[41];
4752         uintConfigs[CONFIG_DRAFT_VOTING_PHASE] = _uintConfigs[42];
4753         uintConfigs[CONFIG_REPUTATION_POINT_BOOST_FOR_BADGE] = _uintConfigs[43];
4754         uintConfigs[CONFIG_FINAL_REWARD_SCALING_FACTOR_NUMERATOR] = _uintConfigs[44];
4755         uintConfigs[CONFIG_FINAL_REWARD_SCALING_FACTOR_DENOMINATOR] = _uintConfigs[45];
4756         uintConfigs[CONFIG_MAXIMUM_MODERATOR_REPUTATION_DEDUCTION] = _uintConfigs[46];
4757         uintConfigs[CONFIG_REPUTATION_PER_EXTRA_MODERATOR_QP_NUM] = _uintConfigs[47];
4758         uintConfigs[CONFIG_REPUTATION_PER_EXTRA_MODERATOR_QP_DEN] = _uintConfigs[48];
4759         uintConfigs[CONFIG_VOTE_CLAIMING_DEADLINE] = _uintConfigs[49];
4760         uintConfigs[CONFIG_MINIMUM_LOCKED_DGD] = _uintConfigs[50];
4761         uintConfigs[CONFIG_MINIMUM_DGD_FOR_MODERATOR] = _uintConfigs[51];
4762         uintConfigs[CONFIG_MINIMUM_REPUTATION_FOR_MODERATOR] = _uintConfigs[52];
4763         uintConfigs[CONFIG_PREPROPOSAL_COLLATERAL] = _uintConfigs[53];
4764         uintConfigs[CONFIG_MAX_FUNDING_FOR_NON_DIGIX] = _uintConfigs[54];
4765         uintConfigs[CONFIG_MAX_MILESTONES_FOR_NON_DIGIX] = _uintConfigs[55];
4766         uintConfigs[CONFIG_NON_DIGIX_PROPOSAL_CAP_PER_QUARTER] = _uintConfigs[56];
4767         uintConfigs[CONFIG_PROPOSAL_DEAD_DURATION] = _uintConfigs[57];
4768         uintConfigs[CONFIG_CARBON_VOTE_REPUTATION_BONUS] = _uintConfigs[58];
4769     }
4770 
4771     function readUintConfigs()
4772         public
4773         view
4774         returns (uint256[])
4775     {
4776         uint256[] memory _uintConfigs = new uint256[](59);
4777         _uintConfigs[0] = uintConfigs[CONFIG_LOCKING_PHASE_DURATION];
4778         _uintConfigs[1] = uintConfigs[CONFIG_QUARTER_DURATION];
4779         _uintConfigs[2] = uintConfigs[CONFIG_VOTING_COMMIT_PHASE];
4780         _uintConfigs[3] = uintConfigs[CONFIG_VOTING_PHASE_TOTAL];
4781         _uintConfigs[4] = uintConfigs[CONFIG_INTERIM_COMMIT_PHASE];
4782         _uintConfigs[5] = uintConfigs[CONFIG_INTERIM_PHASE_TOTAL];
4783         _uintConfigs[6] = uintConfigs[CONFIG_DRAFT_QUORUM_FIXED_PORTION_NUMERATOR];
4784         _uintConfigs[7] = uintConfigs[CONFIG_DRAFT_QUORUM_FIXED_PORTION_DENOMINATOR];
4785         _uintConfigs[8] = uintConfigs[CONFIG_DRAFT_QUORUM_SCALING_FACTOR_NUMERATOR];
4786         _uintConfigs[9] = uintConfigs[CONFIG_DRAFT_QUORUM_SCALING_FACTOR_DENOMINATOR];
4787         _uintConfigs[10] = uintConfigs[CONFIG_VOTING_QUORUM_FIXED_PORTION_NUMERATOR];
4788         _uintConfigs[11] = uintConfigs[CONFIG_VOTING_QUORUM_FIXED_PORTION_DENOMINATOR];
4789         _uintConfigs[12] = uintConfigs[CONFIG_VOTING_QUORUM_SCALING_FACTOR_NUMERATOR];
4790         _uintConfigs[13] = uintConfigs[CONFIG_VOTING_QUORUM_SCALING_FACTOR_DENOMINATOR];
4791         _uintConfigs[14] = uintConfigs[CONFIG_DRAFT_QUOTA_NUMERATOR];
4792         _uintConfigs[15] = uintConfigs[CONFIG_DRAFT_QUOTA_DENOMINATOR];
4793         _uintConfigs[16] = uintConfigs[CONFIG_VOTING_QUOTA_NUMERATOR];
4794         _uintConfigs[17] = uintConfigs[CONFIG_VOTING_QUOTA_DENOMINATOR];
4795         _uintConfigs[18] = uintConfigs[CONFIG_QUARTER_POINT_DRAFT_VOTE];
4796         _uintConfigs[19] = uintConfigs[CONFIG_QUARTER_POINT_VOTE];
4797         _uintConfigs[20] = uintConfigs[CONFIG_QUARTER_POINT_INTERIM_VOTE];
4798         _uintConfigs[21] = uintConfigs[CONFIG_MINIMAL_QUARTER_POINT];
4799         _uintConfigs[22] = uintConfigs[CONFIG_QUARTER_POINT_MILESTONE_COMPLETION_PER_10000ETH];
4800         _uintConfigs[23] = uintConfigs[CONFIG_BONUS_REPUTATION_NUMERATOR];
4801         _uintConfigs[24] = uintConfigs[CONFIG_BONUS_REPUTATION_DENOMINATOR];
4802         _uintConfigs[25] = uintConfigs[CONFIG_SPECIAL_PROPOSAL_COMMIT_PHASE];
4803         _uintConfigs[26] = uintConfigs[CONFIG_SPECIAL_PROPOSAL_PHASE_TOTAL];
4804         _uintConfigs[27] = uintConfigs[CONFIG_SPECIAL_QUOTA_NUMERATOR];
4805         _uintConfigs[28] = uintConfigs[CONFIG_SPECIAL_QUOTA_DENOMINATOR];
4806         _uintConfigs[29] = uintConfigs[CONFIG_SPECIAL_PROPOSAL_QUORUM_NUMERATOR];
4807         _uintConfigs[30] = uintConfigs[CONFIG_SPECIAL_PROPOSAL_QUORUM_DENOMINATOR];
4808         _uintConfigs[31] = uintConfigs[CONFIG_MAXIMUM_REPUTATION_DEDUCTION];
4809         _uintConfigs[32] = uintConfigs[CONFIG_PUNISHMENT_FOR_NOT_LOCKING];
4810         _uintConfigs[33] = uintConfigs[CONFIG_REPUTATION_PER_EXTRA_QP_NUM];
4811         _uintConfigs[34] = uintConfigs[CONFIG_REPUTATION_PER_EXTRA_QP_DEN];
4812         _uintConfigs[35] = uintConfigs[CONFIG_QUARTER_POINT_SCALING_FACTOR];
4813         _uintConfigs[36] = uintConfigs[CONFIG_REPUTATION_POINT_SCALING_FACTOR];
4814         _uintConfigs[37] = uintConfigs[CONFIG_MODERATOR_MINIMAL_QUARTER_POINT];
4815         _uintConfigs[38] = uintConfigs[CONFIG_MODERATOR_QUARTER_POINT_SCALING_FACTOR];
4816         _uintConfigs[39] = uintConfigs[CONFIG_MODERATOR_REPUTATION_POINT_SCALING_FACTOR];
4817         _uintConfigs[40] = uintConfigs[CONFIG_PORTION_TO_MODERATORS_NUM];
4818         _uintConfigs[41] = uintConfigs[CONFIG_PORTION_TO_MODERATORS_DEN];
4819         _uintConfigs[42] = uintConfigs[CONFIG_DRAFT_VOTING_PHASE];
4820         _uintConfigs[43] = uintConfigs[CONFIG_REPUTATION_POINT_BOOST_FOR_BADGE];
4821         _uintConfigs[44] = uintConfigs[CONFIG_FINAL_REWARD_SCALING_FACTOR_NUMERATOR];
4822         _uintConfigs[45] = uintConfigs[CONFIG_FINAL_REWARD_SCALING_FACTOR_DENOMINATOR];
4823         _uintConfigs[46] = uintConfigs[CONFIG_MAXIMUM_MODERATOR_REPUTATION_DEDUCTION];
4824         _uintConfigs[47] = uintConfigs[CONFIG_REPUTATION_PER_EXTRA_MODERATOR_QP_NUM];
4825         _uintConfigs[48] = uintConfigs[CONFIG_REPUTATION_PER_EXTRA_MODERATOR_QP_DEN];
4826         _uintConfigs[49] = uintConfigs[CONFIG_VOTE_CLAIMING_DEADLINE];
4827         _uintConfigs[50] = uintConfigs[CONFIG_MINIMUM_LOCKED_DGD];
4828         _uintConfigs[51] = uintConfigs[CONFIG_MINIMUM_DGD_FOR_MODERATOR];
4829         _uintConfigs[52] = uintConfigs[CONFIG_MINIMUM_REPUTATION_FOR_MODERATOR];
4830         _uintConfigs[53] = uintConfigs[CONFIG_PREPROPOSAL_COLLATERAL];
4831         _uintConfigs[54] = uintConfigs[CONFIG_MAX_FUNDING_FOR_NON_DIGIX];
4832         _uintConfigs[55] = uintConfigs[CONFIG_MAX_MILESTONES_FOR_NON_DIGIX];
4833         _uintConfigs[56] = uintConfigs[CONFIG_NON_DIGIX_PROPOSAL_CAP_PER_QUARTER];
4834         _uintConfigs[57] = uintConfigs[CONFIG_PROPOSAL_DEAD_DURATION];
4835         _uintConfigs[58] = uintConfigs[CONFIG_CARBON_VOTE_REPUTATION_BONUS];
4836         return _uintConfigs;
4837     }
4838 }
4839 
4840 // File: contracts/storage/DaoProposalCounterStorage.sol
4841 pragma solidity ^0.4.25;
4842 
4843 contract DaoProposalCounterStorage is ResolverClient, DaoConstants {
4844 
4845     constructor(address _resolver) public {
4846         require(init(CONTRACT_STORAGE_DAO_COUNTER, _resolver));
4847     }
4848 
4849     // This is to mark the number of proposals that have been funded in a specific quarter
4850     // this is to take care of the cap on the number of funded proposals in a quarter
4851     mapping (uint256 => uint256) public proposalCountByQuarter;
4852 
4853     function addNonDigixProposalCountInQuarter(uint256 _quarterNumber)
4854         public
4855     {
4856         require(sender_is(CONTRACT_DAO_VOTING_CLAIMS));
4857         proposalCountByQuarter[_quarterNumber] = proposalCountByQuarter[_quarterNumber].add(1);
4858     }
4859 }
4860 
4861 // File: contracts/storage/DaoUpgradeStorage.sol
4862 pragma solidity ^0.4.25;
4863 
4864 contract DaoUpgradeStorage is ResolverClient, DaoConstants {
4865 
4866     // this UTC timestamp marks the start of the first quarter
4867     // of DigixDAO. All time related calculations in DaoCommon
4868     // depend on this value
4869     uint256 public startOfFirstQuarter;
4870 
4871     // this boolean marks whether the DAO contracts have been replaced
4872     // by newer versions or not. The process of migration is done by deploying
4873     // a new set of contracts, transferring funds from these contracts to the new ones
4874     // migrating some state variables, and finally setting this boolean to true
4875     // All operations in these contracts that may transfer tokens, claim ether,
4876     // boost one's reputation, etc. SHOULD fail if this is true
4877     bool public isReplacedByNewDao;
4878 
4879     // this is the address of the new Dao contract
4880     address public newDaoContract;
4881 
4882     // this is the address of the new DaoFundingManager contract
4883     // ether funds will be moved from the current version's contract to this
4884     // new contract
4885     address public newDaoFundingManager;
4886 
4887     // this is the address of the new DaoRewardsManager contract
4888     // DGX funds will be moved from the current version of contract to this
4889     // new contract
4890     address public newDaoRewardsManager;
4891 
4892     constructor(address _resolver) public {
4893         require(init(CONTRACT_STORAGE_DAO_UPGRADE, _resolver));
4894     }
4895 
4896     function setStartOfFirstQuarter(uint256 _start)
4897         public
4898     {
4899         require(sender_is(CONTRACT_DAO));
4900         startOfFirstQuarter = _start;
4901     }
4902 
4903 
4904     function setNewContractAddresses(
4905         address _newDaoContract,
4906         address _newDaoFundingManager,
4907         address _newDaoRewardsManager
4908     )
4909         public
4910     {
4911         require(sender_is(CONTRACT_DAO));
4912         newDaoContract = _newDaoContract;
4913         newDaoFundingManager = _newDaoFundingManager;
4914         newDaoRewardsManager = _newDaoRewardsManager;
4915     }
4916 
4917 
4918     function updateForDaoMigration()
4919         public
4920     {
4921         require(sender_is(CONTRACT_DAO));
4922         isReplacedByNewDao = true;
4923     }
4924 }
4925 
4926 // File: contracts/storage/DaoSpecialStorage.sol
4927 pragma solidity ^0.4.25;
4928 
4929 contract DaoSpecialStorage is DaoWhitelistingCommon {
4930     using DoublyLinkedList for DoublyLinkedList.Bytes;
4931     using DaoStructs for DaoStructs.SpecialProposal;
4932     using DaoStructs for DaoStructs.Voting;
4933 
4934     // List of all the special proposals ever created in DigixDAO
4935     DoublyLinkedList.Bytes proposals;
4936 
4937     // mapping of the SpecialProposal struct by its ID
4938     // ID is also the IPFS doc hash of the proposal
4939     mapping (bytes32 => DaoStructs.SpecialProposal) proposalsById;
4940 
4941     constructor(address _resolver) public {
4942         require(init(CONTRACT_STORAGE_DAO_SPECIAL, _resolver));
4943     }
4944 
4945     function addSpecialProposal(
4946         bytes32 _proposalId,
4947         address _proposer,
4948         uint256[] _uintConfigs,
4949         address[] _addressConfigs,
4950         bytes32[] _bytesConfigs
4951     )
4952         public
4953     {
4954         require(sender_is(CONTRACT_DAO_SPECIAL_PROPOSAL));
4955         require(
4956           (proposalsById[_proposalId].proposalId == EMPTY_BYTES) &&
4957           (_proposalId != EMPTY_BYTES)
4958         );
4959         proposals.append(_proposalId);
4960         proposalsById[_proposalId].proposalId = _proposalId;
4961         proposalsById[_proposalId].proposer = _proposer;
4962         proposalsById[_proposalId].timeCreated = now;
4963         proposalsById[_proposalId].uintConfigs = _uintConfigs;
4964         proposalsById[_proposalId].addressConfigs = _addressConfigs;
4965         proposalsById[_proposalId].bytesConfigs = _bytesConfigs;
4966     }
4967 
4968     function readProposal(bytes32 _proposalId)
4969         public
4970         view
4971         returns (
4972             bytes32 _id,
4973             address _proposer,
4974             uint256 _timeCreated,
4975             uint256 _timeVotingStarted
4976         )
4977     {
4978         _id = proposalsById[_proposalId].proposalId;
4979         _proposer = proposalsById[_proposalId].proposer;
4980         _timeCreated = proposalsById[_proposalId].timeCreated;
4981         _timeVotingStarted = proposalsById[_proposalId].voting.startTime;
4982     }
4983 
4984     function readProposalProposer(bytes32 _proposalId)
4985         public
4986         view
4987         returns (address _proposer)
4988     {
4989         _proposer = proposalsById[_proposalId].proposer;
4990     }
4991 
4992     function readConfigs(bytes32 _proposalId)
4993         public
4994         view
4995         returns (
4996             uint256[] memory _uintConfigs,
4997             address[] memory _addressConfigs,
4998             bytes32[] memory _bytesConfigs
4999         )
5000     {
5001         _uintConfigs = proposalsById[_proposalId].uintConfigs;
5002         _addressConfigs = proposalsById[_proposalId].addressConfigs;
5003         _bytesConfigs = proposalsById[_proposalId].bytesConfigs;
5004     }
5005 
5006     function readVotingCount(bytes32 _proposalId, address[] _allUsers)
5007         external
5008         view
5009         returns (uint256 _for, uint256 _against)
5010     {
5011         require(senderIsAllowedToRead());
5012         return proposalsById[_proposalId].voting.countVotes(_allUsers);
5013     }
5014 
5015     function readVotingTime(bytes32 _proposalId)
5016         public
5017         view
5018         returns (uint256 _start)
5019     {
5020         require(senderIsAllowedToRead());
5021         _start = proposalsById[_proposalId].voting.startTime;
5022     }
5023 
5024     function commitVote(
5025         bytes32 _proposalId,
5026         bytes32 _hash,
5027         address _voter
5028     )
5029         public
5030     {
5031         require(sender_is(CONTRACT_DAO_VOTING));
5032         proposalsById[_proposalId].voting.commits[_voter] = _hash;
5033     }
5034 
5035     function readComittedVote(bytes32 _proposalId, address _voter)
5036         public
5037         view
5038         returns (bytes32 _commitHash)
5039     {
5040         require(senderIsAllowedToRead());
5041         _commitHash = proposalsById[_proposalId].voting.commits[_voter];
5042     }
5043 
5044     function setVotingTime(bytes32 _proposalId, uint256 _time)
5045         public
5046     {
5047         require(sender_is(CONTRACT_DAO_SPECIAL_PROPOSAL));
5048         proposalsById[_proposalId].voting.startTime = _time;
5049     }
5050 
5051     function readVotingResult(bytes32 _proposalId)
5052         public
5053         view
5054         returns (bool _result)
5055     {
5056         require(senderIsAllowedToRead());
5057         _result = proposalsById[_proposalId].voting.passed;
5058     }
5059 
5060     function setPass(bytes32 _proposalId, bool _result)
5061         public
5062     {
5063         require(sender_is(CONTRACT_DAO_SPECIAL_VOTING_CLAIMS));
5064         proposalsById[_proposalId].voting.passed = _result;
5065     }
5066 
5067     function setVotingClaim(bytes32 _proposalId, bool _claimed)
5068         public
5069     {
5070         require(sender_is(CONTRACT_DAO_SPECIAL_VOTING_CLAIMS));
5071         DaoStructs.SpecialProposal storage _proposal = proposalsById[_proposalId];
5072         _proposal.voting.claimed = _claimed;
5073     }
5074 
5075     function isClaimed(bytes32 _proposalId)
5076         public
5077         view
5078         returns (bool _claimed)
5079     {
5080         require(senderIsAllowedToRead());
5081         _claimed = proposalsById[_proposalId].voting.claimed;
5082     }
5083 
5084     function readVote(bytes32 _proposalId, address _voter)
5085         public
5086         view
5087         returns (bool _vote, uint256 _weight)
5088     {
5089         require(senderIsAllowedToRead());
5090         return proposalsById[_proposalId].voting.readVote(_voter);
5091     }
5092 
5093     function revealVote(
5094         bytes32 _proposalId,
5095         address _voter,
5096         bool _vote,
5097         uint256 _weight
5098     )
5099         public
5100     {
5101         require(sender_is(CONTRACT_DAO_VOTING));
5102         proposalsById[_proposalId].voting.revealVote(_voter, _vote, _weight);
5103     }
5104 }
5105 
5106 // File: contracts/storage/DaoPointsStorage.sol
5107 pragma solidity ^0.4.25;
5108 
5109 contract DaoPointsStorage is ResolverClient, DaoConstants {
5110 
5111     // struct for a non-transferrable token
5112     struct Token {
5113         uint256 totalSupply;
5114         mapping (address => uint256) balance;
5115     }
5116 
5117     // the reputation point token
5118     // since reputation is cumulative, we only need to store one value
5119     Token reputationPoint;
5120 
5121     // since quarter points are specific to quarters, we need a mapping from
5122     // quarter number to the quarter point token for that quarter
5123     mapping (uint256 => Token) quarterPoint;
5124 
5125     // the same is the case with quarter moderator points
5126     // these are specific to quarters
5127     mapping (uint256 => Token) quarterModeratorPoint;
5128 
5129     constructor(address _resolver)
5130         public
5131     {
5132         require(init(CONTRACT_STORAGE_DAO_POINTS, _resolver));
5133     }
5134 
5135     /// @notice add quarter points for a _participant for a _quarterNumber
5136     function addQuarterPoint(address _participant, uint256 _point, uint256 _quarterNumber)
5137         public
5138         returns (uint256 _newPoint, uint256 _newTotalPoint)
5139     {
5140         require(sender_is_from([CONTRACT_DAO_VOTING, CONTRACT_DAO_VOTING_CLAIMS, EMPTY_BYTES]));
5141         quarterPoint[_quarterNumber].totalSupply = quarterPoint[_quarterNumber].totalSupply.add(_point);
5142         quarterPoint[_quarterNumber].balance[_participant] = quarterPoint[_quarterNumber].balance[_participant].add(_point);
5143 
5144         _newPoint = quarterPoint[_quarterNumber].balance[_participant];
5145         _newTotalPoint = quarterPoint[_quarterNumber].totalSupply;
5146     }
5147 
5148     function addModeratorQuarterPoint(address _participant, uint256 _point, uint256 _quarterNumber)
5149         public
5150         returns (uint256 _newPoint, uint256 _newTotalPoint)
5151     {
5152         require(sender_is_from([CONTRACT_DAO_VOTING, CONTRACT_DAO_VOTING_CLAIMS, EMPTY_BYTES]));
5153         quarterModeratorPoint[_quarterNumber].totalSupply = quarterModeratorPoint[_quarterNumber].totalSupply.add(_point);
5154         quarterModeratorPoint[_quarterNumber].balance[_participant] = quarterModeratorPoint[_quarterNumber].balance[_participant].add(_point);
5155 
5156         _newPoint = quarterModeratorPoint[_quarterNumber].balance[_participant];
5157         _newTotalPoint = quarterModeratorPoint[_quarterNumber].totalSupply;
5158     }
5159 
5160     /// @notice get quarter points for a _participant in a _quarterNumber
5161     function getQuarterPoint(address _participant, uint256 _quarterNumber)
5162         public
5163         view
5164         returns (uint256 _point)
5165     {
5166         _point = quarterPoint[_quarterNumber].balance[_participant];
5167     }
5168 
5169     function getQuarterModeratorPoint(address _participant, uint256 _quarterNumber)
5170         public
5171         view
5172         returns (uint256 _point)
5173     {
5174         _point = quarterModeratorPoint[_quarterNumber].balance[_participant];
5175     }
5176 
5177     /// @notice get total quarter points for a particular _quarterNumber
5178     function getTotalQuarterPoint(uint256 _quarterNumber)
5179         public
5180         view
5181         returns (uint256 _totalPoint)
5182     {
5183         _totalPoint = quarterPoint[_quarterNumber].totalSupply;
5184     }
5185 
5186     function getTotalQuarterModeratorPoint(uint256 _quarterNumber)
5187         public
5188         view
5189         returns (uint256 _totalPoint)
5190     {
5191         _totalPoint = quarterModeratorPoint[_quarterNumber].totalSupply;
5192     }
5193 
5194     /// @notice add reputation points for a _participant
5195     function increaseReputation(address _participant, uint256 _point)
5196         public
5197         returns (uint256 _newPoint, uint256 _totalPoint)
5198     {
5199         require(sender_is_from([CONTRACT_DAO_VOTING_CLAIMS, CONTRACT_DAO_REWARDS_MANAGER, CONTRACT_DAO_STAKE_LOCKING]));
5200         reputationPoint.totalSupply = reputationPoint.totalSupply.add(_point);
5201         reputationPoint.balance[_participant] = reputationPoint.balance[_participant].add(_point);
5202 
5203         _newPoint = reputationPoint.balance[_participant];
5204         _totalPoint = reputationPoint.totalSupply;
5205     }
5206 
5207     /// @notice subtract reputation points for a _participant
5208     function reduceReputation(address _participant, uint256 _point)
5209         public
5210         returns (uint256 _newPoint, uint256 _totalPoint)
5211     {
5212         require(sender_is_from([CONTRACT_DAO_VOTING_CLAIMS, CONTRACT_DAO_REWARDS_MANAGER, EMPTY_BYTES]));
5213         uint256 _toDeduct = _point;
5214         if (reputationPoint.balance[_participant] > _point) {
5215             reputationPoint.balance[_participant] = reputationPoint.balance[_participant].sub(_point);
5216         } else {
5217             _toDeduct = reputationPoint.balance[_participant];
5218             reputationPoint.balance[_participant] = 0;
5219         }
5220 
5221         reputationPoint.totalSupply = reputationPoint.totalSupply.sub(_toDeduct);
5222 
5223         _newPoint = reputationPoint.balance[_participant];
5224         _totalPoint = reputationPoint.totalSupply;
5225     }
5226 
5227   /// @notice get reputation points for a _participant
5228   function getReputation(address _participant)
5229       public
5230       view
5231       returns (uint256 _point)
5232   {
5233       _point = reputationPoint.balance[_participant];
5234   }
5235 
5236   /// @notice get total reputation points distributed in the dao
5237   function getTotalReputation()
5238       public
5239       view
5240       returns (uint256 _totalPoint)
5241   {
5242       _totalPoint = reputationPoint.totalSupply;
5243   }
5244 }
5245 
5246 // File: contracts/storage/DaoRewardsStorage.sol
5247 pragma solidity ^0.4.25;
5248 
5249 // this contract will receive DGXs fees from the DGX fees distributors
5250 contract DaoRewardsStorage is ResolverClient, DaoConstants {
5251     using DaoStructs for DaoStructs.DaoQuarterInfo;
5252 
5253     // DaoQuarterInfo is a struct that stores the quarter specific information
5254     // regarding totalEffectiveDGDs, DGX distribution day, etc. pls check
5255     // docs in lib/DaoStructs
5256     mapping(uint256 => DaoStructs.DaoQuarterInfo) public allQuartersInfo;
5257 
5258     // Mapping that stores the DGX that can be claimed as rewards by
5259     // an address (a participant of DigixDAO)
5260     mapping(address => uint256) public claimableDGXs;
5261 
5262     // This stores the total DGX value that has been claimed by participants
5263     // this can be done by calling the DaoRewardsManager.claimRewards method
5264     // Note that this value is the only outgoing DGX from DaoRewardsManager contract
5265     // Note that this value also takes into account the demurrage that has been paid
5266     // by participants for simply holding their DGXs in the DaoRewardsManager contract
5267     uint256 public totalDGXsClaimed;
5268 
5269     // The Quarter ID in which the user last participated in
5270     // To participate means they had locked more than CONFIG_MINIMUM_LOCKED_DGD
5271     // DGD tokens. In addition, they should not have withdrawn those tokens in the same
5272     // quarter. Basically, in the main phase of the quarter, if DaoCommon.isParticipant(_user)
5273     // was true, they were participants. And that quarter was their lastParticipatedQuarter
5274     mapping (address => uint256) public lastParticipatedQuarter;
5275 
5276     // This mapping is only used to update the lastParticipatedQuarter to the
5277     // previousLastParticipatedQuarter in case users lock and withdraw DGDs
5278     // within the same quarter's locking phase
5279     mapping (address => uint256) public previousLastParticipatedQuarter;
5280 
5281     // This number marks the Quarter in which the rewards were last updated for that user
5282     // Since the rewards calculation for a specific quarter is only done once that
5283     // quarter is completed, we need this value to note the last quarter when the rewards were updated
5284     // We then start adding the rewards for all quarters after that quarter, until the current quarter
5285     mapping (address => uint256) public lastQuarterThatRewardsWasUpdated;
5286 
5287     // Similar as the lastQuarterThatRewardsWasUpdated, but this is for reputation updates
5288     // Note that reputation can also be deducted for no participation (not locking DGDs)
5289     // This value is used to update the reputation based on all quarters from the lastQuarterThatReputationWasUpdated
5290     // to the current quarter
5291     mapping (address => uint256) public lastQuarterThatReputationWasUpdated;
5292 
5293     constructor(address _resolver)
5294            public
5295     {
5296         require(init(CONTRACT_STORAGE_DAO_REWARDS, _resolver));
5297     }
5298 
5299     function updateQuarterInfo(
5300         uint256 _quarterNumber,
5301         uint256 _minimalParticipationPoint,
5302         uint256 _quarterPointScalingFactor,
5303         uint256 _reputationPointScalingFactor,
5304         uint256 _totalEffectiveDGDPreviousQuarter,
5305 
5306         uint256 _moderatorMinimalQuarterPoint,
5307         uint256 _moderatorQuarterPointScalingFactor,
5308         uint256 _moderatorReputationPointScalingFactor,
5309         uint256 _totalEffectiveModeratorDGDLastQuarter,
5310 
5311         uint256 _dgxDistributionDay,
5312         uint256 _dgxRewardsPoolLastQuarter,
5313         uint256 _sumRewardsFromBeginning
5314     )
5315         public
5316     {
5317         require(sender_is(CONTRACT_DAO_REWARDS_MANAGER));
5318         allQuartersInfo[_quarterNumber].minimalParticipationPoint = _minimalParticipationPoint;
5319         allQuartersInfo[_quarterNumber].quarterPointScalingFactor = _quarterPointScalingFactor;
5320         allQuartersInfo[_quarterNumber].reputationPointScalingFactor = _reputationPointScalingFactor;
5321         allQuartersInfo[_quarterNumber].totalEffectiveDGDPreviousQuarter = _totalEffectiveDGDPreviousQuarter;
5322 
5323         allQuartersInfo[_quarterNumber].moderatorMinimalParticipationPoint = _moderatorMinimalQuarterPoint;
5324         allQuartersInfo[_quarterNumber].moderatorQuarterPointScalingFactor = _moderatorQuarterPointScalingFactor;
5325         allQuartersInfo[_quarterNumber].moderatorReputationPointScalingFactor = _moderatorReputationPointScalingFactor;
5326         allQuartersInfo[_quarterNumber].totalEffectiveModeratorDGDLastQuarter = _totalEffectiveModeratorDGDLastQuarter;
5327 
5328         allQuartersInfo[_quarterNumber].dgxDistributionDay = _dgxDistributionDay;
5329         allQuartersInfo[_quarterNumber].dgxRewardsPoolLastQuarter = _dgxRewardsPoolLastQuarter;
5330         allQuartersInfo[_quarterNumber].sumRewardsFromBeginning = _sumRewardsFromBeginning;
5331     }
5332 
5333     function updateClaimableDGX(address _user, uint256 _newClaimableDGX)
5334         public
5335     {
5336         require(sender_is(CONTRACT_DAO_REWARDS_MANAGER));
5337         claimableDGXs[_user] = _newClaimableDGX;
5338     }
5339 
5340     function updateLastParticipatedQuarter(address _user, uint256 _lastQuarter)
5341         public
5342     {
5343         require(sender_is(CONTRACT_DAO_STAKE_LOCKING));
5344         lastParticipatedQuarter[_user] = _lastQuarter;
5345     }
5346 
5347     function updatePreviousLastParticipatedQuarter(address _user, uint256 _lastQuarter)
5348         public
5349     {
5350         require(sender_is(CONTRACT_DAO_STAKE_LOCKING));
5351         previousLastParticipatedQuarter[_user] = _lastQuarter;
5352     }
5353 
5354     function updateLastQuarterThatRewardsWasUpdated(address _user, uint256 _lastQuarter)
5355         public
5356     {
5357         require(sender_is_from([CONTRACT_DAO_REWARDS_MANAGER, CONTRACT_DAO_STAKE_LOCKING, EMPTY_BYTES]));
5358         lastQuarterThatRewardsWasUpdated[_user] = _lastQuarter;
5359     }
5360 
5361     function updateLastQuarterThatReputationWasUpdated(address _user, uint256 _lastQuarter)
5362         public
5363     {
5364         require(sender_is_from([CONTRACT_DAO_REWARDS_MANAGER, CONTRACT_DAO_STAKE_LOCKING, EMPTY_BYTES]));
5365         lastQuarterThatReputationWasUpdated[_user] = _lastQuarter;
5366     }
5367 
5368     function addToTotalDgxClaimed(uint256 _dgxClaimed)
5369         public
5370     {
5371         require(sender_is(CONTRACT_DAO_REWARDS_MANAGER));
5372         totalDGXsClaimed = totalDGXsClaimed.add(_dgxClaimed);
5373     }
5374 
5375     function readQuarterInfo(uint256 _quarterNumber)
5376         public
5377         view
5378         returns (
5379             uint256 _minimalParticipationPoint,
5380             uint256 _quarterPointScalingFactor,
5381             uint256 _reputationPointScalingFactor,
5382             uint256 _totalEffectiveDGDPreviousQuarter,
5383 
5384             uint256 _moderatorMinimalQuarterPoint,
5385             uint256 _moderatorQuarterPointScalingFactor,
5386             uint256 _moderatorReputationPointScalingFactor,
5387             uint256 _totalEffectiveModeratorDGDLastQuarter,
5388 
5389             uint256 _dgxDistributionDay,
5390             uint256 _dgxRewardsPoolLastQuarter,
5391             uint256 _sumRewardsFromBeginning
5392         )
5393     {
5394         _minimalParticipationPoint = allQuartersInfo[_quarterNumber].minimalParticipationPoint;
5395         _quarterPointScalingFactor = allQuartersInfo[_quarterNumber].quarterPointScalingFactor;
5396         _reputationPointScalingFactor = allQuartersInfo[_quarterNumber].reputationPointScalingFactor;
5397         _totalEffectiveDGDPreviousQuarter = allQuartersInfo[_quarterNumber].totalEffectiveDGDPreviousQuarter;
5398         _moderatorMinimalQuarterPoint = allQuartersInfo[_quarterNumber].moderatorMinimalParticipationPoint;
5399         _moderatorQuarterPointScalingFactor = allQuartersInfo[_quarterNumber].moderatorQuarterPointScalingFactor;
5400         _moderatorReputationPointScalingFactor = allQuartersInfo[_quarterNumber].moderatorReputationPointScalingFactor;
5401         _totalEffectiveModeratorDGDLastQuarter = allQuartersInfo[_quarterNumber].totalEffectiveModeratorDGDLastQuarter;
5402         _dgxDistributionDay = allQuartersInfo[_quarterNumber].dgxDistributionDay;
5403         _dgxRewardsPoolLastQuarter = allQuartersInfo[_quarterNumber].dgxRewardsPoolLastQuarter;
5404         _sumRewardsFromBeginning = allQuartersInfo[_quarterNumber].sumRewardsFromBeginning;
5405     }
5406 
5407     function readQuarterGeneralInfo(uint256 _quarterNumber)
5408         public
5409         view
5410         returns (
5411             uint256 _dgxDistributionDay,
5412             uint256 _dgxRewardsPoolLastQuarter,
5413             uint256 _sumRewardsFromBeginning
5414         )
5415     {
5416         _dgxDistributionDay = allQuartersInfo[_quarterNumber].dgxDistributionDay;
5417         _dgxRewardsPoolLastQuarter = allQuartersInfo[_quarterNumber].dgxRewardsPoolLastQuarter;
5418         _sumRewardsFromBeginning = allQuartersInfo[_quarterNumber].sumRewardsFromBeginning;
5419     }
5420 
5421     function readQuarterModeratorInfo(uint256 _quarterNumber)
5422         public
5423         view
5424         returns (
5425             uint256 _moderatorMinimalQuarterPoint,
5426             uint256 _moderatorQuarterPointScalingFactor,
5427             uint256 _moderatorReputationPointScalingFactor,
5428             uint256 _totalEffectiveModeratorDGDLastQuarter
5429         )
5430     {
5431         _moderatorMinimalQuarterPoint = allQuartersInfo[_quarterNumber].moderatorMinimalParticipationPoint;
5432         _moderatorQuarterPointScalingFactor = allQuartersInfo[_quarterNumber].moderatorQuarterPointScalingFactor;
5433         _moderatorReputationPointScalingFactor = allQuartersInfo[_quarterNumber].moderatorReputationPointScalingFactor;
5434         _totalEffectiveModeratorDGDLastQuarter = allQuartersInfo[_quarterNumber].totalEffectiveModeratorDGDLastQuarter;
5435     }
5436 
5437     function readQuarterParticipantInfo(uint256 _quarterNumber)
5438         public
5439         view
5440         returns (
5441             uint256 _minimalParticipationPoint,
5442             uint256 _quarterPointScalingFactor,
5443             uint256 _reputationPointScalingFactor,
5444             uint256 _totalEffectiveDGDPreviousQuarter
5445         )
5446     {
5447         _minimalParticipationPoint = allQuartersInfo[_quarterNumber].minimalParticipationPoint;
5448         _quarterPointScalingFactor = allQuartersInfo[_quarterNumber].quarterPointScalingFactor;
5449         _reputationPointScalingFactor = allQuartersInfo[_quarterNumber].reputationPointScalingFactor;
5450         _totalEffectiveDGDPreviousQuarter = allQuartersInfo[_quarterNumber].totalEffectiveDGDPreviousQuarter;
5451     }
5452 
5453     function readDgxDistributionDay(uint256 _quarterNumber)
5454         public
5455         view
5456         returns (uint256 _distributionDay)
5457     {
5458         _distributionDay = allQuartersInfo[_quarterNumber].dgxDistributionDay;
5459     }
5460 
5461     function readTotalEffectiveDGDLastQuarter(uint256 _quarterNumber)
5462         public
5463         view
5464         returns (uint256 _totalEffectiveDGDPreviousQuarter)
5465     {
5466         _totalEffectiveDGDPreviousQuarter = allQuartersInfo[_quarterNumber].totalEffectiveDGDPreviousQuarter;
5467     }
5468 
5469     function readTotalEffectiveModeratorDGDLastQuarter(uint256 _quarterNumber)
5470         public
5471         view
5472         returns (uint256 _totalEffectiveModeratorDGDLastQuarter)
5473     {
5474         _totalEffectiveModeratorDGDLastQuarter = allQuartersInfo[_quarterNumber].totalEffectiveModeratorDGDLastQuarter;
5475     }
5476 
5477     function readRewardsPoolOfLastQuarter(uint256 _quarterNumber)
5478         public
5479         view
5480         returns (uint256 _rewardsPool)
5481     {
5482         _rewardsPool = allQuartersInfo[_quarterNumber].dgxRewardsPoolLastQuarter;
5483     }
5484 }
5485 
5486 // File: contracts/storage/IntermediateResultsStorage.sol
5487 pragma solidity ^0.4.25;
5488 
5489 contract IntermediateResultsStorage is ResolverClient, DaoConstants {
5490     using DaoStructs for DaoStructs.IntermediateResults;
5491 
5492     constructor(address _resolver) public {
5493         require(init(CONTRACT_STORAGE_INTERMEDIATE_RESULTS, _resolver));
5494     }
5495 
5496     // There are scenarios in which we must loop across all participants/moderators
5497     // in a function call. For a big number of operations, the function call may be short of gas
5498     // To tackle this, we use an IntermediateResults struct to store the intermediate results
5499     // The same function is then called multiple times until all operations are completed
5500     // If the operations cannot be done in that iteration, the intermediate results are stored
5501     // else, the final outcome is returned
5502     // Please check the lib/DaoStructs for docs on this struct
5503     mapping (bytes32 => DaoStructs.IntermediateResults) allIntermediateResults;
5504 
5505     function getIntermediateResults(bytes32 _key)
5506         public
5507         view
5508         returns (
5509             address _countedUntil,
5510             uint256 _currentForCount,
5511             uint256 _currentAgainstCount,
5512             uint256 _currentSumOfEffectiveBalance
5513         )
5514     {
5515         _countedUntil = allIntermediateResults[_key].countedUntil;
5516         _currentForCount = allIntermediateResults[_key].currentForCount;
5517         _currentAgainstCount = allIntermediateResults[_key].currentAgainstCount;
5518         _currentSumOfEffectiveBalance = allIntermediateResults[_key].currentSumOfEffectiveBalance;
5519     }
5520 
5521     function resetIntermediateResults(bytes32 _key)
5522         public
5523     {
5524         require(sender_is_from([CONTRACT_DAO_REWARDS_MANAGER, CONTRACT_DAO_VOTING_CLAIMS, CONTRACT_DAO_SPECIAL_VOTING_CLAIMS]));
5525         allIntermediateResults[_key].countedUntil = address(0x0);
5526     }
5527 
5528     function setIntermediateResults(
5529         bytes32 _key,
5530         address _countedUntil,
5531         uint256 _currentForCount,
5532         uint256 _currentAgainstCount,
5533         uint256 _currentSumOfEffectiveBalance
5534     )
5535         public
5536     {
5537         require(sender_is_from([CONTRACT_DAO_REWARDS_MANAGER, CONTRACT_DAO_VOTING_CLAIMS, CONTRACT_DAO_SPECIAL_VOTING_CLAIMS]));
5538         allIntermediateResults[_key].countedUntil = _countedUntil;
5539         allIntermediateResults[_key].currentForCount = _currentForCount;
5540         allIntermediateResults[_key].currentAgainstCount = _currentAgainstCount;
5541         allIntermediateResults[_key].currentSumOfEffectiveBalance = _currentSumOfEffectiveBalance;
5542     }
5543 }
5544 
5545 // File: contracts/common/DaoCommonMini.sol
5546 pragma solidity ^0.4.25;
5547 
5548 contract DaoCommonMini is IdentityCommon {
5549 
5550     using MathHelper for MathHelper;
5551 
5552     /**
5553     @notice Check if the DAO contracts have been replaced by a new set of contracts
5554     @return _isNotReplaced true if it is not replaced, false if it has already been replaced
5555     */
5556     function isDaoNotReplaced()
5557         public
5558         view
5559         returns (bool _isNotReplaced)
5560     {
5561         _isNotReplaced = !daoUpgradeStorage().isReplacedByNewDao();
5562     }
5563 
5564     /**
5565     @notice Check if it is currently in the locking phase
5566     @dev No governance activities can happen in the locking phase. The locking phase is from t=0 to t=CONFIG_LOCKING_PHASE_DURATION-1
5567     @return _isLockingPhase true if it is in the locking phase
5568     */
5569     function isLockingPhase()
5570         public
5571         view
5572         returns (bool _isLockingPhase)
5573     {
5574         _isLockingPhase = currentTimeInQuarter() < getUintConfig(CONFIG_LOCKING_PHASE_DURATION);
5575     }
5576 
5577     /**
5578     @notice Check if it is currently in a main phase.
5579     @dev The main phase is where all the governance activities could take plase. If the DAO is replaced, there can never be any more main phase.
5580     @return _isMainPhase true if it is in a main phase
5581     */
5582     function isMainPhase()
5583         public
5584         view
5585         returns (bool _isMainPhase)
5586     {
5587         _isMainPhase =
5588             isDaoNotReplaced() &&
5589             currentTimeInQuarter() >= getUintConfig(CONFIG_LOCKING_PHASE_DURATION);
5590     }
5591 
5592     /**
5593     @notice Check if the calculateGlobalRewardsBeforeNewQuarter function has been done for a certain quarter
5594     @dev However, there is no need to run calculateGlobalRewardsBeforeNewQuarter for the first quarter
5595     */
5596     modifier ifGlobalRewardsSet(uint256 _quarterNumber) {
5597         if (_quarterNumber > 1) {
5598             require(daoRewardsStorage().readDgxDistributionDay(_quarterNumber) > 0);
5599         }
5600         _;
5601     }
5602 
5603     /**
5604     @notice require that it is currently during a phase, which is within _relativePhaseStart and _relativePhaseEnd seconds, after the _startingPoint
5605     */
5606     function requireInPhase(uint256 _startingPoint, uint256 _relativePhaseStart, uint256 _relativePhaseEnd)
5607         internal
5608         view
5609     {
5610         require(_startingPoint > 0);
5611         require(now < _startingPoint.add(_relativePhaseEnd));
5612         require(now >= _startingPoint.add(_relativePhaseStart));
5613     }
5614 
5615     /**
5616     @notice Get the current quarter index
5617     @dev Quarter indexes starts from 1
5618     @return _quarterNumber the current quarter index
5619     */
5620     function currentQuarterNumber()
5621         public
5622         view
5623         returns(uint256 _quarterNumber)
5624     {
5625         _quarterNumber = getQuarterNumber(now);
5626     }
5627 
5628     /**
5629     @notice Get the quarter index of a timestamp
5630     @dev Quarter indexes starts from 1
5631     @return _index the quarter index
5632     */
5633     function getQuarterNumber(uint256 _time)
5634         internal
5635         view
5636         returns (uint256 _index)
5637     {
5638         require(startOfFirstQuarterIsSet());
5639         _index =
5640             _time.sub(daoUpgradeStorage().startOfFirstQuarter())
5641             .div(getUintConfig(CONFIG_QUARTER_DURATION))
5642             .add(1);
5643     }
5644 
5645     /**
5646     @notice Get the relative time in quarter of a timestamp
5647     @dev For example, the timeInQuarter of the first second of any quarter n-th is always 1
5648     */
5649     function timeInQuarter(uint256 _time)
5650         internal
5651         view
5652         returns (uint256 _timeInQuarter)
5653     {
5654         require(startOfFirstQuarterIsSet()); // must be already set
5655         _timeInQuarter =
5656             _time.sub(daoUpgradeStorage().startOfFirstQuarter())
5657             % getUintConfig(CONFIG_QUARTER_DURATION);
5658     }
5659 
5660     /**
5661     @notice Check if the start of first quarter is already set
5662     @return _isSet true if start of first quarter is already set
5663     */
5664     function startOfFirstQuarterIsSet()
5665         internal
5666         view
5667         returns (bool _isSet)
5668     {
5669         _isSet = daoUpgradeStorage().startOfFirstQuarter() != 0;
5670     }
5671 
5672     /**
5673     @notice Get the current relative time in the quarter
5674     @dev For example: the currentTimeInQuarter of the first second of any quarter is 1
5675     @return _currentT the current relative time in the quarter
5676     */
5677     function currentTimeInQuarter()
5678         public
5679         view
5680         returns (uint256 _currentT)
5681     {
5682         _currentT = timeInQuarter(now);
5683     }
5684 
5685     /**
5686     @notice Get the time remaining in the quarter
5687     */
5688     function getTimeLeftInQuarter(uint256 _time)
5689         internal
5690         view
5691         returns (uint256 _timeLeftInQuarter)
5692     {
5693         _timeLeftInQuarter = getUintConfig(CONFIG_QUARTER_DURATION).sub(timeInQuarter(_time));
5694     }
5695 
5696     function daoListingService()
5697         internal
5698         view
5699         returns (DaoListingService _contract)
5700     {
5701         _contract = DaoListingService(get_contract(CONTRACT_SERVICE_DAO_LISTING));
5702     }
5703 
5704     function daoConfigsStorage()
5705         internal
5706         view
5707         returns (DaoConfigsStorage _contract)
5708     {
5709         _contract = DaoConfigsStorage(get_contract(CONTRACT_STORAGE_DAO_CONFIG));
5710     }
5711 
5712     function daoStakeStorage()
5713         internal
5714         view
5715         returns (DaoStakeStorage _contract)
5716     {
5717         _contract = DaoStakeStorage(get_contract(CONTRACT_STORAGE_DAO_STAKE));
5718     }
5719 
5720     function daoStorage()
5721         internal
5722         view
5723         returns (DaoStorage _contract)
5724     {
5725         _contract = DaoStorage(get_contract(CONTRACT_STORAGE_DAO));
5726     }
5727 
5728     function daoProposalCounterStorage()
5729         internal
5730         view
5731         returns (DaoProposalCounterStorage _contract)
5732     {
5733         _contract = DaoProposalCounterStorage(get_contract(CONTRACT_STORAGE_DAO_COUNTER));
5734     }
5735 
5736     function daoUpgradeStorage()
5737         internal
5738         view
5739         returns (DaoUpgradeStorage _contract)
5740     {
5741         _contract = DaoUpgradeStorage(get_contract(CONTRACT_STORAGE_DAO_UPGRADE));
5742     }
5743 
5744     function daoSpecialStorage()
5745         internal
5746         view
5747         returns (DaoSpecialStorage _contract)
5748     {
5749         _contract = DaoSpecialStorage(get_contract(CONTRACT_STORAGE_DAO_SPECIAL));
5750     }
5751 
5752     function daoPointsStorage()
5753         internal
5754         view
5755         returns (DaoPointsStorage _contract)
5756     {
5757         _contract = DaoPointsStorage(get_contract(CONTRACT_STORAGE_DAO_POINTS));
5758     }
5759 
5760     function daoRewardsStorage()
5761         internal
5762         view
5763         returns (DaoRewardsStorage _contract)
5764     {
5765         _contract = DaoRewardsStorage(get_contract(CONTRACT_STORAGE_DAO_REWARDS));
5766     }
5767 
5768     function intermediateResultsStorage()
5769         internal
5770         view
5771         returns (IntermediateResultsStorage _contract)
5772     {
5773         _contract = IntermediateResultsStorage(get_contract(CONTRACT_STORAGE_INTERMEDIATE_RESULTS));
5774     }
5775 
5776     function getUintConfig(bytes32 _configKey)
5777         public
5778         view
5779         returns (uint256 _configValue)
5780     {
5781         _configValue = daoConfigsStorage().uintConfigs(_configKey);
5782     }
5783 }
5784 
5785 // File: contracts/common/DaoCommon.sol
5786 pragma solidity ^0.4.25;
5787 
5788 contract DaoCommon is DaoCommonMini {
5789 
5790     using MathHelper for MathHelper;
5791 
5792     /**
5793     @notice Check if the transaction is called by the proposer of a proposal
5794     @return _isFromProposer true if the caller is the proposer
5795     */
5796     function isFromProposer(bytes32 _proposalId)
5797         internal
5798         view
5799         returns (bool _isFromProposer)
5800     {
5801         _isFromProposer = msg.sender == daoStorage().readProposalProposer(_proposalId);
5802     }
5803 
5804     /**
5805     @notice Check if the proposal can still be "editted", or in other words, added more versions
5806     @dev Once the proposal is finalized, it can no longer be editted. The proposer will still be able to add docs and change fundings though.
5807     @return _isEditable true if the proposal is editable
5808     */
5809     function isEditable(bytes32 _proposalId)
5810         internal
5811         view
5812         returns (bool _isEditable)
5813     {
5814         bytes32 _finalVersion;
5815         (,,,,,,,_finalVersion,,) = daoStorage().readProposal(_proposalId);
5816         _isEditable = _finalVersion == EMPTY_BYTES;
5817     }
5818 
5819     /**
5820     @notice returns the balance of DaoFundingManager, which is the wei in DigixDAO
5821     */
5822     function weiInDao()
5823         internal
5824         view
5825         returns (uint256 _wei)
5826     {
5827         _wei = get_contract(CONTRACT_DAO_FUNDING_MANAGER).balance;
5828     }
5829 
5830     /**
5831     @notice Check if it is after the draft voting phase of the proposal
5832     */
5833     modifier ifAfterDraftVotingPhase(bytes32 _proposalId) {
5834         uint256 _start = daoStorage().readProposalDraftVotingTime(_proposalId);
5835         require(_start > 0); // Draft voting must have started. In other words, proposer must have finalized the proposal
5836         require(now >= _start.add(getUintConfig(CONFIG_DRAFT_VOTING_PHASE)));
5837         _;
5838     }
5839 
5840     modifier ifCommitPhase(bytes32 _proposalId, uint8 _index) {
5841         requireInPhase(
5842             daoStorage().readProposalVotingTime(_proposalId, _index),
5843             0,
5844             getUintConfig(_index == 0 ? CONFIG_VOTING_COMMIT_PHASE : CONFIG_INTERIM_COMMIT_PHASE)
5845         );
5846         _;
5847     }
5848 
5849     modifier ifRevealPhase(bytes32 _proposalId, uint256 _index) {
5850       requireInPhase(
5851           daoStorage().readProposalVotingTime(_proposalId, _index),
5852           getUintConfig(_index == 0 ? CONFIG_VOTING_COMMIT_PHASE : CONFIG_INTERIM_COMMIT_PHASE),
5853           getUintConfig(_index == 0 ? CONFIG_VOTING_PHASE_TOTAL : CONFIG_INTERIM_PHASE_TOTAL)
5854       );
5855       _;
5856     }
5857 
5858     modifier ifAfterProposalRevealPhase(bytes32 _proposalId, uint256 _index) {
5859       uint256 _start = daoStorage().readProposalVotingTime(_proposalId, _index);
5860       require(_start > 0);
5861       require(now >= _start.add(getUintConfig(_index == 0 ? CONFIG_VOTING_PHASE_TOTAL : CONFIG_INTERIM_PHASE_TOTAL)));
5862       _;
5863     }
5864 
5865     modifier ifDraftVotingPhase(bytes32 _proposalId) {
5866         requireInPhase(
5867             daoStorage().readProposalDraftVotingTime(_proposalId),
5868             0,
5869             getUintConfig(CONFIG_DRAFT_VOTING_PHASE)
5870         );
5871         _;
5872     }
5873 
5874     modifier isProposalState(bytes32 _proposalId, bytes32 _STATE) {
5875         bytes32 _currentState;
5876         (,,,_currentState,,,,,,) = daoStorage().readProposal(_proposalId);
5877         require(_currentState == _STATE);
5878         _;
5879     }
5880 
5881     /**
5882     @notice Check if the DAO has enough ETHs for a particular funding request
5883     */
5884     modifier ifFundingPossible(uint256[] _fundings, uint256 _finalReward) {
5885         require(MathHelper.sumNumbers(_fundings).add(_finalReward) <= weiInDao());
5886         _;
5887     }
5888 
5889     modifier ifDraftNotClaimed(bytes32 _proposalId) {
5890         require(daoStorage().isDraftClaimed(_proposalId) == false);
5891         _;
5892     }
5893 
5894     modifier ifNotClaimed(bytes32 _proposalId, uint256 _index) {
5895         require(daoStorage().isClaimed(_proposalId, _index) == false);
5896         _;
5897     }
5898 
5899     modifier ifNotClaimedSpecial(bytes32 _proposalId) {
5900         require(daoSpecialStorage().isClaimed(_proposalId) == false);
5901         _;
5902     }
5903 
5904     modifier hasNotRevealed(bytes32 _proposalId, uint256 _index) {
5905         uint256 _voteWeight;
5906         (, _voteWeight) = daoStorage().readVote(_proposalId, _index, msg.sender);
5907         require(_voteWeight == uint(0));
5908         _;
5909     }
5910 
5911     modifier hasNotRevealedSpecial(bytes32 _proposalId) {
5912         uint256 _weight;
5913         (,_weight) = daoSpecialStorage().readVote(_proposalId, msg.sender);
5914         require(_weight == uint256(0));
5915         _;
5916     }
5917 
5918     modifier ifAfterRevealPhaseSpecial(bytes32 _proposalId) {
5919       uint256 _start = daoSpecialStorage().readVotingTime(_proposalId);
5920       require(_start > 0);
5921       require(now.sub(_start) >= getUintConfig(CONFIG_SPECIAL_PROPOSAL_PHASE_TOTAL));
5922       _;
5923     }
5924 
5925     modifier ifCommitPhaseSpecial(bytes32 _proposalId) {
5926         requireInPhase(
5927             daoSpecialStorage().readVotingTime(_proposalId),
5928             0,
5929             getUintConfig(CONFIG_SPECIAL_PROPOSAL_COMMIT_PHASE)
5930         );
5931         _;
5932     }
5933 
5934     modifier ifRevealPhaseSpecial(bytes32 _proposalId) {
5935         requireInPhase(
5936             daoSpecialStorage().readVotingTime(_proposalId),
5937             getUintConfig(CONFIG_SPECIAL_PROPOSAL_COMMIT_PHASE),
5938             getUintConfig(CONFIG_SPECIAL_PROPOSAL_PHASE_TOTAL)
5939         );
5940         _;
5941     }
5942 
5943     function daoWhitelistingStorage()
5944         internal
5945         view
5946         returns (DaoWhitelistingStorage _contract)
5947     {
5948         _contract = DaoWhitelistingStorage(get_contract(CONTRACT_STORAGE_DAO_WHITELISTING));
5949     }
5950 
5951     function getAddressConfig(bytes32 _configKey)
5952         public
5953         view
5954         returns (address _configValue)
5955     {
5956         _configValue = daoConfigsStorage().addressConfigs(_configKey);
5957     }
5958 
5959     function getBytesConfig(bytes32 _configKey)
5960         public
5961         view
5962         returns (bytes32 _configValue)
5963     {
5964         _configValue = daoConfigsStorage().bytesConfigs(_configKey);
5965     }
5966 
5967     /**
5968     @notice Check if a user is a participant in the current quarter
5969     */
5970     function isParticipant(address _user)
5971         public
5972         view
5973         returns (bool _is)
5974     {
5975         _is =
5976             (daoRewardsStorage().lastParticipatedQuarter(_user) == currentQuarterNumber())
5977             && (daoStakeStorage().lockedDGDStake(_user) >= getUintConfig(CONFIG_MINIMUM_LOCKED_DGD));
5978     }
5979 
5980     /**
5981     @notice Check if a user is a moderator in the current quarter
5982     */
5983     function isModerator(address _user)
5984         public
5985         view
5986         returns (bool _is)
5987     {
5988         _is =
5989             (daoRewardsStorage().lastParticipatedQuarter(_user) == currentQuarterNumber())
5990             && (daoStakeStorage().lockedDGDStake(_user) >= getUintConfig(CONFIG_MINIMUM_DGD_FOR_MODERATOR))
5991             && (daoPointsStorage().getReputation(_user) >= getUintConfig(CONFIG_MINIMUM_REPUTATION_FOR_MODERATOR));
5992     }
5993 
5994     /**
5995     @notice Calculate the start of a specific milestone of a specific proposal.
5996     @dev This is calculated from the voting start of the voting round preceding the milestone
5997          This would throw if the voting start is 0 (the voting round has not started yet)
5998          Note that if the milestoneIndex is exactly the same as the number of milestones,
5999          This will just return the end of the last voting round.
6000     */
6001     function startOfMilestone(bytes32 _proposalId, uint256 _milestoneIndex)
6002         internal
6003         view
6004         returns (uint256 _milestoneStart)
6005     {
6006         uint256 _startOfPrecedingVotingRound = daoStorage().readProposalVotingTime(_proposalId, _milestoneIndex);
6007         require(_startOfPrecedingVotingRound > 0);
6008         // the preceding voting round must have started
6009 
6010         if (_milestoneIndex == 0) { // This is the 1st milestone, which starts after voting round 0
6011             _milestoneStart =
6012                 _startOfPrecedingVotingRound
6013                 .add(getUintConfig(CONFIG_VOTING_PHASE_TOTAL));
6014         } else { // if its the n-th milestone, it starts after voting round n-th
6015             _milestoneStart =
6016                 _startOfPrecedingVotingRound
6017                 .add(getUintConfig(CONFIG_INTERIM_PHASE_TOTAL));
6018         }
6019     }
6020 
6021     /**
6022     @notice Calculate the actual voting start for a voting round, given the tentative start
6023     @dev The tentative start is the ideal start. For example, when a proposer finish a milestone, it should be now
6024          However, sometimes the tentative start is too close to the end of the quarter, hence, the actual voting start should be pushed to the next quarter
6025     */
6026     function getTimelineForNextVote(
6027         uint256 _index,
6028         uint256 _tentativeVotingStart
6029     )
6030         internal
6031         view
6032         returns (uint256 _actualVotingStart)
6033     {
6034         uint256 _timeLeftInQuarter = getTimeLeftInQuarter(_tentativeVotingStart);
6035         uint256 _votingDuration = getUintConfig(_index == 0 ? CONFIG_VOTING_PHASE_TOTAL : CONFIG_INTERIM_PHASE_TOTAL);
6036         _actualVotingStart = _tentativeVotingStart;
6037         if (timeInQuarter(_tentativeVotingStart) < getUintConfig(CONFIG_LOCKING_PHASE_DURATION)) { // if the tentative start is during a locking phase
6038             _actualVotingStart = _tentativeVotingStart.add(
6039                 getUintConfig(CONFIG_LOCKING_PHASE_DURATION).sub(timeInQuarter(_tentativeVotingStart))
6040             );
6041         } else if (_timeLeftInQuarter < _votingDuration.add(getUintConfig(CONFIG_VOTE_CLAIMING_DEADLINE))) { // if the time left in quarter is not enough to vote and claim voting
6042             _actualVotingStart = _tentativeVotingStart.add(
6043                 _timeLeftInQuarter.add(getUintConfig(CONFIG_LOCKING_PHASE_DURATION)).add(1)
6044             );
6045         }
6046     }
6047 
6048     /**
6049     @notice Check if we can add another non-Digix proposal in this quarter
6050     @dev There is a max cap to the number of non-Digix proposals CONFIG_NON_DIGIX_PROPOSAL_CAP_PER_QUARTER
6051     */
6052     function checkNonDigixProposalLimit(bytes32 _proposalId)
6053         internal
6054         view
6055     {
6056         require(isNonDigixProposalsWithinLimit(_proposalId));
6057     }
6058 
6059     function isNonDigixProposalsWithinLimit(bytes32 _proposalId)
6060         internal
6061         view
6062         returns (bool _withinLimit)
6063     {
6064         bool _isDigixProposal;
6065         (,,,,,,,,,_isDigixProposal) = daoStorage().readProposal(_proposalId);
6066         _withinLimit = true;
6067         if (!_isDigixProposal) {
6068             _withinLimit = daoProposalCounterStorage().proposalCountByQuarter(currentQuarterNumber()) < getUintConfig(CONFIG_NON_DIGIX_PROPOSAL_CAP_PER_QUARTER);
6069         }
6070     }
6071 
6072     /**
6073     @notice If its a non-Digix proposal, check if the fundings are within limit
6074     @dev There is a max cap to the fundings and number of milestones for non-Digix proposals
6075     */
6076     function checkNonDigixFundings(uint256[] _milestonesFundings, uint256 _finalReward)
6077         internal
6078         view
6079     {
6080         if (!is_founder()) {
6081             require(_milestonesFundings.length <= getUintConfig(CONFIG_MAX_MILESTONES_FOR_NON_DIGIX));
6082             require(MathHelper.sumNumbers(_milestonesFundings).add(_finalReward) <= getUintConfig(CONFIG_MAX_FUNDING_FOR_NON_DIGIX));
6083         }
6084     }
6085 
6086     /**
6087     @notice Check if msg.sender can do operations as a proposer
6088     @dev Note that this function does not check if he is the proposer of the proposal
6089     */
6090     function senderCanDoProposerOperations()
6091         internal
6092         view
6093     {
6094         require(isMainPhase());
6095         require(isParticipant(msg.sender));
6096         require(identity_storage().is_kyc_approved(msg.sender));
6097     }
6098 }
6099 
6100 // File: contracts/interface/DgxDemurrageCalculator.sol
6101 pragma solidity ^0.4.25;
6102 
6103 /// @title Digix Gold Token Demurrage Calculator
6104 /// @author Digix Holdings Pte Ltd
6105 /// @notice This contract is meant to be used by exchanges/other parties who want to calculate the DGX demurrage fees, provided an initial balance and the days elapsed
6106 contract DgxDemurrageCalculator {
6107     function calculateDemurrage(uint256 _initial_balance, uint256 _days_elapsed)
6108         public
6109         view
6110         returns (uint256 _demurrage_fees, bool _no_demurrage_fees);
6111 }
6112 
6113 // File: contracts/service/DaoCalculatorService.sol
6114 pragma solidity ^0.4.25;
6115 
6116 contract DaoCalculatorService is DaoCommon {
6117 
6118     address public dgxDemurrageCalculatorAddress;
6119 
6120     using MathHelper for MathHelper;
6121 
6122     constructor(address _resolver, address _dgxDemurrageCalculatorAddress)
6123         public
6124     {
6125         require(init(CONTRACT_SERVICE_DAO_CALCULATOR, _resolver));
6126         dgxDemurrageCalculatorAddress = _dgxDemurrageCalculatorAddress;
6127     }
6128 
6129 
6130     /**
6131     @notice Calculate the additional lockedDGDStake, given the DGDs that the user has just locked in
6132     @dev The earlier the locking happens, the more lockedDGDStake the user will get
6133          The formula is: additionalLockedDGDStake = (90 - t)/80 * additionalDGD if t is more than 10. If t<=10, additionalLockedDGDStake = additionalDGD
6134     */
6135     function calculateAdditionalLockedDGDStake(uint256 _additionalDgd)
6136         public
6137         view
6138         returns (uint256 _additionalLockedDGDStake)
6139     {
6140         _additionalLockedDGDStake =
6141             _additionalDgd.mul(
6142                 getUintConfig(CONFIG_QUARTER_DURATION)
6143                 .sub(
6144                     MathHelper.max(
6145                         currentTimeInQuarter(),
6146                         getUintConfig(CONFIG_LOCKING_PHASE_DURATION)
6147                     )
6148                 )
6149             )
6150             .div(
6151                 getUintConfig(CONFIG_QUARTER_DURATION)
6152                 .sub(getUintConfig(CONFIG_LOCKING_PHASE_DURATION))
6153             );
6154     }
6155 
6156 
6157     // Quorum is in terms of lockedDGDStake
6158     function minimumDraftQuorum(bytes32 _proposalId)
6159         public
6160         view
6161         returns (uint256 _minQuorum)
6162     {
6163         uint256[] memory _fundings;
6164 
6165         (_fundings,) = daoStorage().readProposalFunding(_proposalId);
6166         _minQuorum = calculateMinQuorum(
6167             daoStakeStorage().totalModeratorLockedDGDStake(),
6168             getUintConfig(CONFIG_DRAFT_QUORUM_FIXED_PORTION_NUMERATOR),
6169             getUintConfig(CONFIG_DRAFT_QUORUM_FIXED_PORTION_DENOMINATOR),
6170             getUintConfig(CONFIG_DRAFT_QUORUM_SCALING_FACTOR_NUMERATOR),
6171             getUintConfig(CONFIG_DRAFT_QUORUM_SCALING_FACTOR_DENOMINATOR),
6172             _fundings[0]
6173         );
6174     }
6175 
6176 
6177     function draftQuotaPass(uint256 _for, uint256 _against)
6178         public
6179         view
6180         returns (bool _passed)
6181     {
6182         _passed = _for.mul(getUintConfig(CONFIG_DRAFT_QUOTA_DENOMINATOR))
6183                 > getUintConfig(CONFIG_DRAFT_QUOTA_NUMERATOR).mul(_for.add(_against));
6184     }
6185 
6186 
6187     // Quorum is in terms of lockedDGDStake
6188     function minimumVotingQuorum(bytes32 _proposalId, uint256 _milestone_id)
6189         public
6190         view
6191         returns (uint256 _minQuorum)
6192     {
6193         require(senderIsAllowedToRead());
6194         uint256[] memory _weiAskedPerMilestone;
6195         uint256 _finalReward;
6196         (_weiAskedPerMilestone,_finalReward) = daoStorage().readProposalFunding(_proposalId);
6197         require(_milestone_id <= _weiAskedPerMilestone.length);
6198         if (_milestone_id == _weiAskedPerMilestone.length) {
6199             // calculate quorum for the final voting round
6200             _minQuorum = calculateMinQuorum(
6201                 daoStakeStorage().totalLockedDGDStake(),
6202                 getUintConfig(CONFIG_VOTING_QUORUM_FIXED_PORTION_NUMERATOR),
6203                 getUintConfig(CONFIG_VOTING_QUORUM_FIXED_PORTION_DENOMINATOR),
6204                 getUintConfig(CONFIG_FINAL_REWARD_SCALING_FACTOR_NUMERATOR),
6205                 getUintConfig(CONFIG_FINAL_REWARD_SCALING_FACTOR_DENOMINATOR),
6206                 _finalReward
6207             );
6208         } else {
6209             // calculate quorum for a voting round
6210             _minQuorum = calculateMinQuorum(
6211                 daoStakeStorage().totalLockedDGDStake(),
6212                 getUintConfig(CONFIG_VOTING_QUORUM_FIXED_PORTION_NUMERATOR),
6213                 getUintConfig(CONFIG_VOTING_QUORUM_FIXED_PORTION_DENOMINATOR),
6214                 getUintConfig(CONFIG_VOTING_QUORUM_SCALING_FACTOR_NUMERATOR),
6215                 getUintConfig(CONFIG_VOTING_QUORUM_SCALING_FACTOR_DENOMINATOR),
6216                 _weiAskedPerMilestone[_milestone_id]
6217             );
6218         }
6219     }
6220 
6221 
6222     // Quorum is in terms of lockedDGDStake
6223     function minimumVotingQuorumForSpecial()
6224         public
6225         view
6226         returns (uint256 _minQuorum)
6227     {
6228       _minQuorum = getUintConfig(CONFIG_SPECIAL_PROPOSAL_QUORUM_NUMERATOR).mul(
6229                        daoStakeStorage().totalLockedDGDStake()
6230                    ).div(
6231                        getUintConfig(CONFIG_SPECIAL_PROPOSAL_QUORUM_DENOMINATOR)
6232                    );
6233     }
6234 
6235 
6236     function votingQuotaPass(uint256 _for, uint256 _against)
6237         public
6238         view
6239         returns (bool _passed)
6240     {
6241         _passed = _for.mul(getUintConfig(CONFIG_VOTING_QUOTA_DENOMINATOR))
6242                 > getUintConfig(CONFIG_VOTING_QUOTA_NUMERATOR).mul(_for.add(_against));
6243     }
6244 
6245 
6246     function votingQuotaForSpecialPass(uint256 _for, uint256 _against)
6247         public
6248         view
6249         returns (bool _passed)
6250     {
6251         _passed =_for.mul(getUintConfig(CONFIG_SPECIAL_QUOTA_DENOMINATOR))
6252                 > getUintConfig(CONFIG_SPECIAL_QUOTA_NUMERATOR).mul(_for.add(_against));
6253     }
6254 
6255 
6256     function calculateMinQuorum(
6257         uint256 _totalStake,
6258         uint256 _fixedQuorumPortionNumerator,
6259         uint256 _fixedQuorumPortionDenominator,
6260         uint256 _scalingFactorNumerator,
6261         uint256 _scalingFactorDenominator,
6262         uint256 _weiAsked
6263     )
6264         internal
6265         view
6266         returns (uint256 _minimumQuorum)
6267     {
6268         uint256 _weiInDao = weiInDao();
6269         // add the fixed portion of the quorum
6270         _minimumQuorum = (_totalStake.mul(_fixedQuorumPortionNumerator)).div(_fixedQuorumPortionDenominator);
6271 
6272         // add the dynamic portion of the quorum
6273         _minimumQuorum = _minimumQuorum.add(_totalStake.mul(_weiAsked.mul(_scalingFactorNumerator)).div(_weiInDao.mul(_scalingFactorDenominator)));
6274     }
6275 
6276 
6277     function calculateUserEffectiveBalance(
6278         uint256 _minimalParticipationPoint,
6279         uint256 _quarterPointScalingFactor,
6280         uint256 _reputationPointScalingFactor,
6281         uint256 _quarterPoint,
6282         uint256 _reputationPoint,
6283         uint256 _lockedDGDStake
6284     )
6285         public
6286         pure
6287         returns (uint256 _effectiveDGDBalance)
6288     {
6289         uint256 _baseDGDBalance = MathHelper.min(_quarterPoint, _minimalParticipationPoint).mul(_lockedDGDStake).div(_minimalParticipationPoint);
6290         _effectiveDGDBalance =
6291             _baseDGDBalance
6292             .mul(_quarterPointScalingFactor.add(_quarterPoint).sub(_minimalParticipationPoint))
6293             .mul(_reputationPointScalingFactor.add(_reputationPoint))
6294             .div(_quarterPointScalingFactor.mul(_reputationPointScalingFactor));
6295     }
6296 
6297 
6298     function calculateDemurrage(uint256 _balance, uint256 _daysElapsed)
6299         public
6300         view
6301         returns (uint256 _demurrageFees)
6302     {
6303         (_demurrageFees,) = DgxDemurrageCalculator(dgxDemurrageCalculatorAddress).calculateDemurrage(_balance, _daysElapsed);
6304     }
6305 
6306 }
6307 
6308 // File: contracts/common/DaoRewardsManagerCommon.sol
6309 pragma solidity ^0.4.25;
6310 
6311 contract DaoRewardsManagerCommon is DaoCommonMini {
6312 
6313     using DaoStructs for DaoStructs.DaoQuarterInfo;
6314 
6315     // this is a struct that store information relevant for calculating the user rewards
6316     // for the last participating quarter
6317     struct UserRewards {
6318         uint256 lastParticipatedQuarter;
6319         uint256 lastQuarterThatRewardsWasUpdated;
6320         uint256 effectiveDGDBalance;
6321         uint256 effectiveModeratorDGDBalance;
6322         DaoStructs.DaoQuarterInfo qInfo;
6323     }
6324 
6325     // struct to store variables needed in the execution of calculateGlobalRewardsBeforeNewQuarter
6326     struct QuarterRewardsInfo {
6327         uint256 previousQuarter;
6328         uint256 totalEffectiveDGDPreviousQuarter;
6329         uint256 totalEffectiveModeratorDGDLastQuarter;
6330         uint256 dgxRewardsPoolLastQuarter;
6331         uint256 userCount;
6332         uint256 i;
6333         DaoStructs.DaoQuarterInfo qInfo;
6334         address currentUser;
6335         address[] users;
6336         bool doneCalculatingEffectiveBalance;
6337         bool doneCalculatingModeratorEffectiveBalance;
6338     }
6339 
6340     // get the struct for the relevant information for calculating a user's DGX rewards for the last participated quarter
6341     function getUserRewardsStruct(address _user)
6342         internal
6343         view
6344         returns (UserRewards memory _data)
6345     {
6346         _data.lastParticipatedQuarter = daoRewardsStorage().lastParticipatedQuarter(_user);
6347         _data.lastQuarterThatRewardsWasUpdated = daoRewardsStorage().lastQuarterThatRewardsWasUpdated(_user);
6348         _data.qInfo = readQuarterInfo(_data.lastParticipatedQuarter);
6349     }
6350 
6351     // read the DaoQuarterInfo struct of a certain quarter
6352     function readQuarterInfo(uint256 _quarterNumber)
6353         internal
6354         view
6355         returns (DaoStructs.DaoQuarterInfo _qInfo)
6356     {
6357         (
6358             _qInfo.minimalParticipationPoint,
6359             _qInfo.quarterPointScalingFactor,
6360             _qInfo.reputationPointScalingFactor,
6361             _qInfo.totalEffectiveDGDPreviousQuarter
6362         ) = daoRewardsStorage().readQuarterParticipantInfo(_quarterNumber);
6363         (
6364             _qInfo.moderatorMinimalParticipationPoint,
6365             _qInfo.moderatorQuarterPointScalingFactor,
6366             _qInfo.moderatorReputationPointScalingFactor,
6367             _qInfo.totalEffectiveModeratorDGDLastQuarter
6368         ) = daoRewardsStorage().readQuarterModeratorInfo(_quarterNumber);
6369         (
6370             _qInfo.dgxDistributionDay,
6371             _qInfo.dgxRewardsPoolLastQuarter,
6372             _qInfo.sumRewardsFromBeginning
6373         ) = daoRewardsStorage().readQuarterGeneralInfo(_quarterNumber);
6374     }
6375 }
6376 
6377 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
6378 pragma solidity ^0.4.24;
6379 
6380 /**
6381  * @title ERC20Basic
6382  * @dev Simpler version of ERC20 interface
6383  * See https://github.com/ethereum/EIPs/issues/179
6384  */
6385 contract ERC20Basic {
6386   function totalSupply() public view returns (uint256);
6387   function balanceOf(address _who) public view returns (uint256);
6388   function transfer(address _to, uint256 _value) public returns (bool);
6389   event Transfer(address indexed from, address indexed to, uint256 value);
6390 }
6391 
6392 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
6393 pragma solidity ^0.4.24;
6394 
6395 /**
6396  * @title ERC20 interface
6397  * @dev see https://github.com/ethereum/EIPs/issues/20
6398  */
6399 contract ERC20 is ERC20Basic {
6400   function allowance(address _owner, address _spender)
6401     public view returns (uint256);
6402 
6403   function transferFrom(address _from, address _to, uint256 _value)
6404     public returns (bool);
6405 
6406   function approve(address _spender, uint256 _value) public returns (bool);
6407   event Approval(
6408     address indexed owner,
6409     address indexed spender,
6410     uint256 value
6411   );
6412 }
6413 
6414 // File: contracts/interactive/DaoRewardsManagerExtras.sol
6415 pragma solidity ^0.4.25;
6416 
6417 contract DaoRewardsManagerExtras is DaoRewardsManagerCommon {
6418 
6419     constructor(address _resolver) public {
6420         require(init(CONTRACT_DAO_REWARDS_MANAGER_EXTRAS, _resolver));
6421     }
6422 
6423     function daoCalculatorService()
6424         internal
6425         view
6426         returns (DaoCalculatorService _contract)
6427     {
6428         _contract = DaoCalculatorService(get_contract(CONTRACT_SERVICE_DAO_CALCULATOR));
6429     }
6430 
6431     // done
6432     // calculate dgx rewards; This is basically the DGXs that user has earned from participating in lastParticipatedQuarter, and can be withdrawn on the dgxDistributionDay of the (lastParticipatedQuarter + 1)
6433     // when user actually withdraw some time after that, he will be deducted demurrage.
6434     function calculateUserRewardsForLastParticipatingQuarter(address _user)
6435         public
6436         view
6437         returns (uint256 _dgxRewardsAsParticipant, uint256 _dgxRewardsAsModerator)
6438     {
6439         UserRewards memory data = getUserRewardsStruct(_user);
6440 
6441         data.effectiveDGDBalance = daoCalculatorService().calculateUserEffectiveBalance(
6442             data.qInfo.minimalParticipationPoint,
6443             data.qInfo.quarterPointScalingFactor,
6444             data.qInfo.reputationPointScalingFactor,
6445             daoPointsStorage().getQuarterPoint(_user, data.lastParticipatedQuarter),
6446 
6447             // RP has been updated at the beginning of the lastParticipatedQuarter in
6448             // a call to updateRewardsAndReputationBeforeNewQuarter(); It should not have changed since then
6449             daoPointsStorage().getReputation(_user),
6450 
6451             // lockedDGDStake should have stayed the same throughout since the lastParticipatedQuarter
6452             // if this participant has done anything (lock/unlock/continue) to change the lockedDGDStake,
6453             // updateUserRewardsForLastParticipatingQuarter, and hence this function, would have been called first before the lockedDGDStake is changed
6454             daoStakeStorage().lockedDGDStake(_user)
6455         );
6456 
6457         data.effectiveModeratorDGDBalance = daoCalculatorService().calculateUserEffectiveBalance(
6458             data.qInfo.moderatorMinimalParticipationPoint,
6459             data.qInfo.moderatorQuarterPointScalingFactor,
6460             data.qInfo.moderatorReputationPointScalingFactor,
6461             daoPointsStorage().getQuarterModeratorPoint(_user, data.lastParticipatedQuarter),
6462 
6463             // RP has been updated at the beginning of the lastParticipatedQuarter in
6464             // a call to updateRewardsAndReputationBeforeNewQuarter();
6465             daoPointsStorage().getReputation(_user),
6466 
6467             // lockedDGDStake should have stayed the same throughout since the lastParticipatedQuarter
6468             // if this participant has done anything (lock/unlock/continue) to change the lockedDGDStake,
6469             // updateUserRewardsForLastParticipatingQuarter would have been called first before the lockedDGDStake is changed
6470             daoStakeStorage().lockedDGDStake(_user)
6471         );
6472 
6473         // will not need to calculate if the totalEffectiveDGDLastQuarter is 0 (no one participated)
6474         if (daoRewardsStorage().readTotalEffectiveDGDLastQuarter(data.lastParticipatedQuarter.add(1)) > 0) {
6475             _dgxRewardsAsParticipant =
6476                 data.effectiveDGDBalance
6477                 .mul(daoRewardsStorage().readRewardsPoolOfLastQuarter(
6478                     data.lastParticipatedQuarter.add(1)
6479                 ))
6480                 .mul(
6481                     getUintConfig(CONFIG_PORTION_TO_MODERATORS_DEN)
6482                     .sub(getUintConfig(CONFIG_PORTION_TO_MODERATORS_NUM))
6483                 )
6484                 .div(daoRewardsStorage().readTotalEffectiveDGDLastQuarter(
6485                     data.lastParticipatedQuarter.add(1)
6486                 ))
6487                 .div(getUintConfig(CONFIG_PORTION_TO_MODERATORS_DEN));
6488         }
6489 
6490         // will not need to calculate if the totalEffectiveModeratorDGDLastQuarter is 0 (no one participated)
6491         if (daoRewardsStorage().readTotalEffectiveModeratorDGDLastQuarter(data.lastParticipatedQuarter.add(1)) > 0) {
6492             _dgxRewardsAsModerator =
6493                 data.effectiveModeratorDGDBalance
6494                 .mul(daoRewardsStorage().readRewardsPoolOfLastQuarter(
6495                     data.lastParticipatedQuarter.add(1)
6496                 ))
6497                 .mul(
6498                      getUintConfig(CONFIG_PORTION_TO_MODERATORS_NUM)
6499                 )
6500                 .div(daoRewardsStorage().readTotalEffectiveModeratorDGDLastQuarter(
6501                     data.lastParticipatedQuarter.add(1)
6502                 ))
6503                 .div(getUintConfig(CONFIG_PORTION_TO_MODERATORS_DEN));
6504         }
6505     }
6506 }
6507 
6508 // File: contracts/interactive/DaoRewardsManager.sol
6509 pragma solidity ^0.4.25;
6510 
6511 /**
6512 @title Contract to manage DGX rewards
6513 @author Digix Holdings
6514 */
6515 contract DaoRewardsManager is DaoRewardsManagerCommon {
6516     using MathHelper for MathHelper;
6517     using DaoStructs for DaoStructs.DaoQuarterInfo;
6518     using DaoStructs for DaoStructs.IntermediateResults;
6519 
6520     // is emitted when calculateGlobalRewardsBeforeNewQuarter has been done in the beginning of the quarter
6521     // after which, all the other DAO activities could happen
6522     event StartNewQuarter(uint256 indexed _quarterNumber);
6523 
6524     address public ADDRESS_DGX_TOKEN;
6525 
6526     function daoCalculatorService()
6527         internal
6528         view
6529         returns (DaoCalculatorService _contract)
6530     {
6531         _contract = DaoCalculatorService(get_contract(CONTRACT_SERVICE_DAO_CALCULATOR));
6532     }
6533 
6534     function daoRewardsManagerExtras()
6535         internal
6536         view
6537         returns (DaoRewardsManagerExtras _contract)
6538     {
6539         _contract = DaoRewardsManagerExtras(get_contract(CONTRACT_DAO_REWARDS_MANAGER_EXTRAS));
6540     }
6541 
6542     /**
6543     @notice Constructor (set the DaoQuarterInfo struct for the first quarter)
6544     @param _resolver Address of the Contract Resolver contract
6545     @param _dgxAddress Address of the Digix Gold Token contract
6546     */
6547     constructor(address _resolver, address _dgxAddress)
6548         public
6549     {
6550         require(init(CONTRACT_DAO_REWARDS_MANAGER, _resolver));
6551         ADDRESS_DGX_TOKEN = _dgxAddress;
6552 
6553         // set the DaoQuarterInfo for the first quarter
6554         daoRewardsStorage().updateQuarterInfo(
6555             1,
6556             getUintConfig(CONFIG_MINIMAL_QUARTER_POINT),
6557             getUintConfig(CONFIG_QUARTER_POINT_SCALING_FACTOR),
6558             getUintConfig(CONFIG_REPUTATION_POINT_SCALING_FACTOR),
6559             0, // totalEffectiveDGDPreviousQuarter, Not Applicable, this value should not be used ever
6560             getUintConfig(CONFIG_MODERATOR_MINIMAL_QUARTER_POINT),
6561             getUintConfig(CONFIG_MODERATOR_QUARTER_POINT_SCALING_FACTOR),
6562             getUintConfig(CONFIG_MODERATOR_REPUTATION_POINT_SCALING_FACTOR),
6563             0, // _totalEffectiveModeratorDGDLastQuarter , Not applicable, this value should not be used ever
6564 
6565             // _dgxDistributionDay, Not applicable, there shouldnt be any DGX rewards in the DAO now. The actual DGX fees that have been collected
6566             // before the deployment of DigixDAO contracts would be counted as part of the DGX fees incurred in the first quarter
6567             // this value should not be used ever
6568             now,
6569 
6570             0, // _dgxRewardsPoolLastQuarter, not applicable, this value should not be used ever
6571             0 // sumRewardsFromBeginning, which is 0
6572         );
6573     }
6574 
6575 
6576     /**
6577     @notice Function to transfer the claimableDGXs to the new DaoRewardsManager
6578     @dev This is done during the migrateToNewDao procedure
6579     @param _newDaoRewardsManager Address of the new daoRewardsManager contract
6580     */
6581     function moveDGXsToNewDao(address _newDaoRewardsManager)
6582         public
6583     {
6584         require(sender_is(CONTRACT_DAO));
6585         uint256 _dgxBalance = ERC20(ADDRESS_DGX_TOKEN).balanceOf(address(this));
6586         ERC20(ADDRESS_DGX_TOKEN).transfer(_newDaoRewardsManager, _dgxBalance);
6587     }
6588 
6589 
6590     /**
6591     @notice Function for users to claim the claimable DGX rewards
6592     @dev Will revert if _claimableDGX < MINIMUM_TRANSFER_AMOUNT of DGX.
6593          Can only be called after calculateGlobalRewardsBeforeNewQuarter() has been called in the current quarter
6594          This cannot be called once the current version of Dao contracts have been migrated to newer version
6595     */
6596     function claimRewards()
6597         public
6598         ifGlobalRewardsSet(currentQuarterNumber())
6599     {
6600         require(isDaoNotReplaced());
6601 
6602         address _user = msg.sender;
6603         uint256 _claimableDGX;
6604 
6605         // update rewards for the quarter that he last participated in
6606         (, _claimableDGX) = updateUserRewardsForLastParticipatingQuarter(_user);
6607 
6608         // withdraw from his claimableDGXs
6609         // This has to take into account demurrage
6610         // Basically, the value of claimableDGXs in the contract is for the dgxDistributionDay of (lastParticipatedQuarter + 1)
6611         // if now is after that, we need to deduct demurrage
6612         uint256 _days_elapsed = now
6613             .sub(
6614                 daoRewardsStorage().readDgxDistributionDay(
6615                     daoRewardsStorage().lastQuarterThatRewardsWasUpdated(_user).add(1) // lastQuarterThatRewardsWasUpdated should be the same as lastParticipatedQuarter now
6616                 )
6617             )
6618             .div(1 days);
6619 
6620          // similar logic as in the similar step in updateUserRewardsForLastParticipatingQuarter.
6621          // it is as if the user has withdrawn all _claimableDGX, and the demurrage is paid back into the DAO immediately
6622         daoRewardsStorage().addToTotalDgxClaimed(_claimableDGX);
6623 
6624         _claimableDGX = _claimableDGX.sub(
6625             daoCalculatorService().calculateDemurrage(
6626                 _claimableDGX,
6627                 _days_elapsed
6628             ));
6629 
6630         daoRewardsStorage().updateClaimableDGX(_user, 0);
6631         ERC20(ADDRESS_DGX_TOKEN).transfer(_user, _claimableDGX);
6632         // the _demurrageFees is implicitly "transfered" back into the DAO, and would be counted in the dgxRewardsPool of this quarter (in other words, dgxRewardsPoolLastQuarter of next quarter)
6633     }
6634 
6635 
6636     /**
6637     @notice Function to update DGX rewards of user. This is only called during locking/withdrawing DGDs, or continuing participation for new quarter
6638     @param _user Address of the DAO participant
6639     */
6640     function updateRewardsAndReputationBeforeNewQuarter(address _user)
6641         public
6642     {
6643         require(sender_is(CONTRACT_DAO_STAKE_LOCKING));
6644 
6645         updateUserRewardsForLastParticipatingQuarter(_user);
6646         updateUserReputationUntilPreviousQuarter(_user);
6647     }
6648 
6649 
6650     // This function would ALWAYS make sure that the user's Reputation Point is updated for ALL activities that has happened
6651     // BEFORE this current quarter. These activities include:
6652     //  - Reputation bonus/penalty due to participation in all of the previous quarters
6653     //  - Reputation penalty for not participating for a few quarters, up until and including the previous quarter
6654     //  - Badges redemption and carbon vote reputation redemption (that happens in the first time locking)
6655     // As such, after this function is called on quarter N, the updated reputation point of the user would tentatively be used to calculate the rewards for quarter N
6656     // Its tentative because the user can also redeem a badge during the period of quarter N to add to his reputation point.
6657     function updateUserReputationUntilPreviousQuarter (address _user)
6658         private
6659     {
6660         uint256 _lastParticipatedQuarter = daoRewardsStorage().lastParticipatedQuarter(_user);
6661         uint256 _lastQuarterThatReputationWasUpdated = daoRewardsStorage().lastQuarterThatReputationWasUpdated(_user);
6662         uint256 _reputationDeduction;
6663 
6664         // If the reputation was already updated until the previous quarter
6665         // nothing needs to be done
6666         if (
6667             _lastQuarterThatReputationWasUpdated.add(1) >= currentQuarterNumber()
6668         ) {
6669             return;
6670         }
6671 
6672         // first, we calculate and update the reputation change due to the user's governance activities in lastParticipatedQuarter, if it is not already updated.
6673         // reputation is not updated for lastParticipatedQuarter yet is equivalent to _lastQuarterThatReputationWasUpdated == _lastParticipatedQuarter - 1
6674         if (
6675             (_lastQuarterThatReputationWasUpdated.add(1) == _lastParticipatedQuarter)
6676         ) {
6677             updateRPfromQP(
6678                 _user,
6679                 daoPointsStorage().getQuarterPoint(_user, _lastParticipatedQuarter),
6680                 getUintConfig(CONFIG_MINIMAL_QUARTER_POINT),
6681                 getUintConfig(CONFIG_MAXIMUM_REPUTATION_DEDUCTION),
6682                 getUintConfig(CONFIG_REPUTATION_PER_EXTRA_QP_NUM),
6683                 getUintConfig(CONFIG_REPUTATION_PER_EXTRA_QP_DEN)
6684             );
6685 
6686             // this user is not a Moderator for current quarter
6687             // coz this step is done before updating the refreshModerator.
6688             // But may have been a Moderator before, and if was moderator in their
6689             // lastParticipatedQuarter, we will find them in the DoublyLinkedList.
6690             if (daoStakeStorage().isInModeratorsList(_user)) {
6691                 updateRPfromQP(
6692                     _user,
6693                     daoPointsStorage().getQuarterModeratorPoint(_user, _lastParticipatedQuarter),
6694                     getUintConfig(CONFIG_MODERATOR_MINIMAL_QUARTER_POINT),
6695                     getUintConfig(CONFIG_MAXIMUM_MODERATOR_REPUTATION_DEDUCTION),
6696                     getUintConfig(CONFIG_REPUTATION_PER_EXTRA_MODERATOR_QP_NUM),
6697                     getUintConfig(CONFIG_REPUTATION_PER_EXTRA_MODERATOR_QP_DEN)
6698                 );
6699             }
6700             _lastQuarterThatReputationWasUpdated = _lastParticipatedQuarter;
6701         }
6702 
6703         // at this point, the _lastQuarterThatReputationWasUpdated MUST be at least the _lastParticipatedQuarter already
6704         // Hence, any quarters between the _lastQuarterThatReputationWasUpdated and now must be a non-participating quarter,
6705         // and this participant should be penalized for those.
6706 
6707         // If this is their first ever participation, It is fine as well, as the reputation would be still be 0 after this step.
6708         // note that the carbon vote's reputation bonus will be added after this, so its fine
6709 
6710         _reputationDeduction =
6711             (currentQuarterNumber().sub(1).sub(_lastQuarterThatReputationWasUpdated))
6712             .mul(
6713                 getUintConfig(CONFIG_MAXIMUM_REPUTATION_DEDUCTION)
6714                 .add(getUintConfig(CONFIG_PUNISHMENT_FOR_NOT_LOCKING))
6715             );
6716 
6717         if (_reputationDeduction > 0) daoPointsStorage().reduceReputation(_user, _reputationDeduction);
6718         daoRewardsStorage().updateLastQuarterThatReputationWasUpdated(_user, currentQuarterNumber().sub(1));
6719     }
6720 
6721 
6722     // update ReputationPoint of a participant based on QuarterPoint/ModeratorQuarterPoint in a quarter
6723     function updateRPfromQP (
6724         address _user,
6725         uint256 _userQP,
6726         uint256 _minimalQP,
6727         uint256 _maxRPDeduction,
6728         uint256 _rpPerExtraQP_num,
6729         uint256 _rpPerExtraQP_den
6730     ) internal {
6731         uint256 _reputationDeduction;
6732         uint256 _reputationAddition;
6733         if (_userQP < _minimalQP) {
6734             _reputationDeduction =
6735                 _minimalQP.sub(_userQP)
6736                 .mul(_maxRPDeduction)
6737                 .div(_minimalQP);
6738 
6739             daoPointsStorage().reduceReputation(_user, _reputationDeduction);
6740         } else {
6741             _reputationAddition =
6742                 _userQP.sub(_minimalQP)
6743                 .mul(_rpPerExtraQP_num)
6744                 .div(_rpPerExtraQP_den);
6745 
6746             daoPointsStorage().increaseReputation(_user, _reputationAddition);
6747         }
6748     }
6749 
6750     // if the DGX rewards has not been calculated for the user's lastParticipatedQuarter, calculate and update it
6751     function updateUserRewardsForLastParticipatingQuarter(address _user)
6752         internal
6753         returns (bool _valid, uint256 _userClaimableDgx)
6754     {
6755         UserRewards memory data = getUserRewardsStruct(_user);
6756         _userClaimableDgx = daoRewardsStorage().claimableDGXs(_user);
6757 
6758         // There is nothing to do if:
6759         //   - The participant is already participating this quarter and hence this function has been called in this quarter
6760         //   - We have updated the rewards to the lastParticipatedQuarter
6761         // In ANY other cases: it means that the lastParticipatedQuarter is NOT this quarter, and its greater than lastQuarterThatRewardsWasUpdated, hence
6762         // This also means that this participant has ALREADY PARTICIPATED at least once IN THE PAST, and we have not calculated for this quarter
6763         // Thus, we need to calculate the Rewards for the lastParticipatedQuarter
6764         if (
6765             (currentQuarterNumber() == data.lastParticipatedQuarter) ||
6766             (data.lastParticipatedQuarter <= data.lastQuarterThatRewardsWasUpdated)
6767         ) {
6768             return (false, _userClaimableDgx);
6769         }
6770 
6771         // now we will calculate the user rewards based on info of the data.lastParticipatedQuarter
6772 
6773         // first we "deduct the demurrage" for the existing claimable DGXs for time period from
6774         // dgxDistributionDay of (lastQuarterThatRewardsWasUpdated + 1) to dgxDistributionDay of (lastParticipatedQuarter + 1)
6775         // (note that, when people participate in quarter n, the DGX rewards for quarter n is only released at the dgxDistributionDay of (n+1)th quarter)
6776         uint256 _days_elapsed = daoRewardsStorage().readDgxDistributionDay(data.lastParticipatedQuarter.add(1))
6777             .sub(daoRewardsStorage().readDgxDistributionDay(data.lastQuarterThatRewardsWasUpdated.add(1)))
6778             .div(1 days);
6779         uint256 _demurrageFees = daoCalculatorService().calculateDemurrage(
6780             _userClaimableDgx,
6781             _days_elapsed
6782         );
6783         _userClaimableDgx = _userClaimableDgx.sub(_demurrageFees);
6784         // this demurrage fees will not be accurate to the hours, but we will leave it as this.
6785 
6786         // this deducted demurrage is then added to the totalDGXsClaimed
6787         // This is as if, the user claims exactly _demurrageFees DGXs, which would be used immediately to pay for the demurrage on his claimableDGXs,
6788         // from dgxDistributionDay of (lastQuarterThatRewardsWasUpdated + 1) to dgxDistributionDay of (lastParticipatedQuarter + 1)
6789         // This is done as such, so that this _demurrageFees would "flow back into the DAO" and be counted in the dgxRewardsPool of this current quarter (in other words, dgxRewardsPoolLastQuarter of the next quarter, as will be calculated in calculateGlobalRewardsBeforeNewQuarter of the next quarter)
6790         // this is not 100% techinally correct as a demurrage concept, because this demurrage fees could have been incurred for the duration of the quarters in the past, but we will account them this way, as if its demurrage fees for this quarter, for simplicity.
6791         daoRewardsStorage().addToTotalDgxClaimed(_demurrageFees);
6792 
6793         uint256 _dgxRewardsAsParticipant;
6794         uint256 _dgxRewardsAsModerator;
6795         (_dgxRewardsAsParticipant, _dgxRewardsAsModerator) = daoRewardsManagerExtras().calculateUserRewardsForLastParticipatingQuarter(_user);
6796         _userClaimableDgx = _userClaimableDgx.add(_dgxRewardsAsParticipant).add(_dgxRewardsAsModerator);
6797 
6798         // update claimableDGXs. The calculation just now should have taken into account demurrage
6799         // such that the demurrage has been paid until dgxDistributionDay of (lastParticipatedQuarter + 1)
6800         daoRewardsStorage().updateClaimableDGX(_user, _userClaimableDgx);
6801 
6802         // update lastQuarterThatRewardsWasUpdated
6803         daoRewardsStorage().updateLastQuarterThatRewardsWasUpdated(_user, data.lastParticipatedQuarter);
6804         _valid = true;
6805     }
6806 
6807     /**
6808     @notice Function called by the founder after transfering the DGX fees into the DAO at the beginning of the quarter
6809     @dev This function needs to do lots of calculation, so it might not fit into one transaction
6810          As such, it could be done in multiple transactions, each time passing _operations which is the number of operations we want to calculate.
6811          When the value of _done is finally true, that's when the calculation is done.
6812          Only after this function runs, any other activities in the DAO could happen.
6813 
6814          Basically, if there were M participants and N moderators in the previous quarter, it takes M+N "operations".
6815 
6816          In summary, the function populates the DaoQuarterInfo of this quarter.
6817          The bulk of the calculation is to go through every participant in the previous quarter to calculate their effectiveDGDBalance and sum them to get the
6818          totalEffectiveDGDLastQuarter
6819     */
6820     function calculateGlobalRewardsBeforeNewQuarter(uint256 _operations)
6821         public
6822         if_founder()
6823         returns (bool _done)
6824     {
6825         require(isDaoNotReplaced());
6826         require(daoUpgradeStorage().startOfFirstQuarter() != 0); // start of first quarter must have been set already
6827         require(isLockingPhase());
6828         require(daoRewardsStorage().readDgxDistributionDay(currentQuarterNumber()) == 0); // throw if this function has already finished running this quarter
6829 
6830         QuarterRewardsInfo memory info;
6831         info.previousQuarter = currentQuarterNumber().sub(1);
6832         require(info.previousQuarter > 0); // throw if this is the first quarter
6833         info.qInfo = readQuarterInfo(info.previousQuarter);
6834 
6835         DaoStructs.IntermediateResults memory interResults;
6836         (
6837             interResults.countedUntil,,,
6838             info.totalEffectiveDGDPreviousQuarter
6839         ) = intermediateResultsStorage().getIntermediateResults(
6840             getIntermediateResultsIdForGlobalRewards(info.previousQuarter, false)
6841         );
6842 
6843         uint256 _operationsLeft = sumEffectiveBalance(info, false, _operations, interResults);
6844         // now we are left with _operationsLeft operations
6845         // the results is saved in interResults
6846 
6847         // if we have not done with calculating the effective balance, quit.
6848         if (!info.doneCalculatingEffectiveBalance) { return false; }
6849 
6850         (
6851             interResults.countedUntil,,,
6852             info.totalEffectiveModeratorDGDLastQuarter
6853         ) = intermediateResultsStorage().getIntermediateResults(
6854             getIntermediateResultsIdForGlobalRewards(info.previousQuarter, true)
6855         );
6856 
6857         sumEffectiveBalance(info, true, _operationsLeft, interResults);
6858 
6859         // if we have not done with calculating the moderator effective balance, quit.
6860         if (!info.doneCalculatingModeratorEffectiveBalance) { return false; }
6861 
6862         // we have done the heavey calculation, now save the quarter info
6863         processGlobalRewardsUpdate(info);
6864         _done = true;
6865 
6866         emit StartNewQuarter(currentQuarterNumber());
6867     }
6868 
6869 
6870     // get the Id for the intermediateResult for a quarter's global rewards calculation
6871     function getIntermediateResultsIdForGlobalRewards(uint256 _quarterNumber, bool _forModerator) internal view returns (bytes32 _id) {
6872         _id = keccak256(abi.encodePacked(
6873             _forModerator ? INTERMEDIATE_MODERATOR_DGD_IDENTIFIER : INTERMEDIATE_DGD_IDENTIFIER,
6874             _quarterNumber
6875         ));
6876     }
6877 
6878 
6879     // final step in calculateGlobalRewardsBeforeNewQuarter, which is to save the DaoQuarterInfo struct for this quarter
6880     function processGlobalRewardsUpdate(QuarterRewardsInfo memory info) internal {
6881         // calculate how much DGX rewards we got for this quarter
6882         info.dgxRewardsPoolLastQuarter =
6883             ERC20(ADDRESS_DGX_TOKEN).balanceOf(address(this))
6884             .add(daoRewardsStorage().totalDGXsClaimed())
6885             .sub(info.qInfo.sumRewardsFromBeginning);
6886 
6887         // starting new quarter, no one locked in DGDs yet
6888         daoStakeStorage().updateTotalLockedDGDStake(0);
6889         daoStakeStorage().updateTotalModeratorLockedDGDs(0);
6890 
6891         daoRewardsStorage().updateQuarterInfo(
6892             info.previousQuarter.add(1),
6893             getUintConfig(CONFIG_MINIMAL_QUARTER_POINT),
6894             getUintConfig(CONFIG_QUARTER_POINT_SCALING_FACTOR),
6895             getUintConfig(CONFIG_REPUTATION_POINT_SCALING_FACTOR),
6896             info.totalEffectiveDGDPreviousQuarter,
6897 
6898             getUintConfig(CONFIG_MODERATOR_MINIMAL_QUARTER_POINT),
6899             getUintConfig(CONFIG_MODERATOR_QUARTER_POINT_SCALING_FACTOR),
6900             getUintConfig(CONFIG_MODERATOR_REPUTATION_POINT_SCALING_FACTOR),
6901             info.totalEffectiveModeratorDGDLastQuarter,
6902 
6903             now,
6904             info.dgxRewardsPoolLastQuarter,
6905             info.qInfo.sumRewardsFromBeginning.add(info.dgxRewardsPoolLastQuarter)
6906         );
6907     }
6908 
6909 
6910     // Sum the effective balance (could be effectiveDGDBalance or effectiveModeratorDGDBalance), given that we have _operations left
6911     function sumEffectiveBalance (
6912         QuarterRewardsInfo memory info,
6913         bool _badgeCalculation, // false if this is the first step, true if its the second step
6914         uint256 _operations,
6915         DaoStructs.IntermediateResults memory _interResults
6916     )
6917         internal
6918         returns (uint _operationsLeft)
6919     {
6920         if (_operations == 0) return _operations; // no more operations left, quit
6921 
6922         if (_interResults.countedUntil == EMPTY_ADDRESS) {
6923             // if this is the first time we are doing this calculation, we need to
6924             // get the list of the participants to calculate by querying the first _operations participants
6925             info.users = _badgeCalculation ?
6926                 daoListingService().listModerators(_operations, true)
6927                 : daoListingService().listParticipants(_operations, true);
6928         } else {
6929             info.users = _badgeCalculation ?
6930                 daoListingService().listModeratorsFrom(_interResults.countedUntil, _operations, true)
6931                 : daoListingService().listParticipantsFrom(_interResults.countedUntil, _operations, true);
6932 
6933             // if this list is the already empty, it means this is the first step (calculating effective balance), and its already done;
6934             if (info.users.length == 0) {
6935                 info.doneCalculatingEffectiveBalance = true;
6936                 return _operations;
6937             }
6938         }
6939 
6940         address _lastAddress;
6941         _lastAddress = info.users[info.users.length - 1];
6942 
6943         info.userCount = info.users.length;
6944         for (info.i=0;info.i<info.userCount;info.i++) {
6945             info.currentUser = info.users[info.i];
6946             // check if this participant really did participate in the previous quarter
6947             if (daoRewardsStorage().lastParticipatedQuarter(info.currentUser) != info.previousQuarter) {
6948                 continue;
6949             }
6950             if (_badgeCalculation) {
6951                 info.totalEffectiveModeratorDGDLastQuarter = info.totalEffectiveModeratorDGDLastQuarter.add(daoCalculatorService().calculateUserEffectiveBalance(
6952                     info.qInfo.moderatorMinimalParticipationPoint,
6953                     info.qInfo.moderatorQuarterPointScalingFactor,
6954                     info.qInfo.moderatorReputationPointScalingFactor,
6955                     daoPointsStorage().getQuarterModeratorPoint(info.currentUser, info.previousQuarter),
6956                     daoPointsStorage().getReputation(info.currentUser),
6957                     daoStakeStorage().lockedDGDStake(info.currentUser)
6958                 ));
6959             } else {
6960                 info.totalEffectiveDGDPreviousQuarter = info.totalEffectiveDGDPreviousQuarter.add(daoCalculatorService().calculateUserEffectiveBalance(
6961                     info.qInfo.minimalParticipationPoint,
6962                     info.qInfo.quarterPointScalingFactor,
6963                     info.qInfo.reputationPointScalingFactor,
6964                     daoPointsStorage().getQuarterPoint(info.currentUser, info.previousQuarter),
6965                     daoPointsStorage().getReputation(info.currentUser),
6966                     daoStakeStorage().lockedDGDStake(info.currentUser)
6967                 ));
6968             }
6969         }
6970 
6971         // check if we have reached the last guy in the current list
6972         if (_lastAddress == daoStakeStorage().readLastModerator() && _badgeCalculation) {
6973             info.doneCalculatingModeratorEffectiveBalance = true;
6974         }
6975         if (_lastAddress == daoStakeStorage().readLastParticipant() && !_badgeCalculation) {
6976             info.doneCalculatingEffectiveBalance = true;
6977         }
6978         // save to the intermediateResult storage
6979         intermediateResultsStorage().setIntermediateResults(
6980             getIntermediateResultsIdForGlobalRewards(info.previousQuarter, _badgeCalculation),
6981             _lastAddress,
6982             0,0,
6983             _badgeCalculation ? info.totalEffectiveModeratorDGDLastQuarter : info.totalEffectiveDGDPreviousQuarter
6984         );
6985 
6986         _operationsLeft = _operations.sub(info.userCount);
6987     }
6988 }
6989 
6990 // File: contracts/interface/NumberCarbonVoting.sol
6991 pragma solidity ^0.4.25;
6992 
6993 contract NumberCarbonVoting {
6994     function voted(address _voter) public view returns (bool);
6995 }
6996 
6997 // File: contracts/interactive/DaoStakeLocking.sol
6998 pragma solidity ^0.4.25;
6999 
7000 /**
7001 @title Contract to handle staking/withdrawing of DGDs for participation in DAO
7002 @author Digix Holdings
7003 */
7004 contract DaoStakeLocking is DaoCommon {
7005 
7006     event RedeemBadge(address indexed _user);
7007     event LockDGD(address indexed _user, uint256 _amount, uint256 _currentLockedDGDStake);
7008     event WithdrawDGD(address indexed _user, uint256 _amount, uint256 _currentLockedDGDStake);
7009 
7010     address public dgdToken;
7011     address public dgdBadgeToken;
7012 
7013     // carbonVoting1 refers to this carbon vote: https://digix.global/carbonvote/1/#/
7014     // the contract is at: https://etherscan.io/address/0x9f56f330bceb9d4e756be94581298673e94ed592#code
7015     address public carbonVoting1;
7016 
7017     // carbonVoting2 refers to this carbon vote: https://digix.global/carbonvote/2/#/
7018     // the contract is at: https://etherscan.io/address/0xdec6c0dc7004ba23940c9ee7cb4a0528ec4c0580#code
7019     address public carbonVoting2;
7020 
7021     // The two carbon votes implement the NumberCarbonVoting interface, which has a voted(address) function to find out
7022     // whether an address has voted in the carbon vote.
7023     // Addresses will be awarded a fixed amount of Reputation Point (CONFIG_CARBON_VOTE_REPUTATION_BONUS) for every carbon votes that they participated in
7024 
7025     struct StakeInformation {
7026         // this is the amount of DGDs that a user has actualy locked up
7027         uint256 userActualLockedDGD;
7028 
7029         // this is the DGDStake that the user get from locking up their DGDs.
7030         // this amount might be smaller than the userActualLockedDGD, because the user has locked some DGDs in the middle of the quarter
7031         // and those DGDs will not fetch as much DGDStake
7032         uint256 userLockedDGDStake;
7033 
7034         // this is the sum of everyone's DGD Stake
7035         uint256 totalLockedDGDStake;
7036     }
7037 
7038 
7039     constructor(
7040         address _resolver,
7041         address _dgdToken,
7042         address _dgdBadgeToken,
7043         address _carbonVoting1,
7044         address _carbonVoting2
7045     ) public {
7046         require(init(CONTRACT_DAO_STAKE_LOCKING, _resolver));
7047         dgdToken = _dgdToken;
7048         dgdBadgeToken = _dgdBadgeToken;
7049         carbonVoting1 = _carbonVoting1;
7050         carbonVoting2 = _carbonVoting2;
7051     }
7052 
7053     function daoCalculatorService()
7054         internal
7055         view
7056         returns (DaoCalculatorService _contract)
7057     {
7058         _contract = DaoCalculatorService(get_contract(CONTRACT_SERVICE_DAO_CALCULATOR));
7059     }
7060 
7061     function daoRewardsManager()
7062         internal
7063         view
7064         returns (DaoRewardsManager _contract)
7065     {
7066         _contract = DaoRewardsManager(get_contract(CONTRACT_DAO_REWARDS_MANAGER));
7067     }
7068 
7069 
7070     /**
7071     @notice Function to convert a DGD Badge to Reputation Points
7072     @dev The Badge holder can redeem the Badge anytime in the first quarter, or
7073          Otherwise, the participant must either lock/withdraw/continue in the current quarter first, before he can redeem a badge
7074          Only 1 DGD Badge is accepted from an address, so holders with multiple badges
7075          should either sell their other badges or redeem reputation to another address
7076     */
7077     function redeemBadge()
7078         public
7079     {
7080         // should not have redeemed a badge
7081         require(!daoStakeStorage().redeemedBadge(msg.sender));
7082 
7083         // Can only redeem a badge if the reputation has been updated to the previous quarter.
7084         // In other words, this holder must have called either lockDGD/withdrawDGD/confirmContinuedParticipation in this quarter (hence, rewards for last quarter was already calculated)
7085         // This is to prevent users from changing the Reputation point that would be used to calculate their rewards for the previous quarter.
7086 
7087         // Note that after lockDGD/withdrawDGD/confirmContinuedParticipation is called, the reputation is always updated to the previous quarter
7088         require(
7089             daoRewardsStorage().lastQuarterThatReputationWasUpdated(msg.sender) == (currentQuarterNumber() - 1)
7090         );
7091 
7092         daoStakeStorage().redeemBadge(msg.sender);
7093         daoPointsStorage().increaseReputation(msg.sender, getUintConfig(CONFIG_REPUTATION_POINT_BOOST_FOR_BADGE));
7094 
7095         // update moderator status
7096         StakeInformation memory _info = getStakeInformation(msg.sender);
7097         refreshModeratorStatus(msg.sender, _info, _info);
7098 
7099         // transfer the badge to this contract
7100         require(ERC20(dgdBadgeToken).transferFrom(msg.sender, address(this), 1));
7101 
7102         emit RedeemBadge(msg.sender);
7103     }
7104 
7105     function lockDGD(uint256 _amount) public {
7106         require(_amount > 0);
7107         lockDGDInternal(_amount);
7108     }
7109 
7110 
7111     /**
7112     @notice Function to lock DGD tokens to participate in the DAO
7113     @dev Users must `approve` the DaoStakeLocking contract to transfer DGDs from them
7114          Contracts are not allowed to participate in DigixDAO
7115     @param _amount Amount of DGDs to lock
7116     */
7117     function lockDGDInternal(uint256 _amount)
7118         internal
7119         ifGlobalRewardsSet(currentQuarterNumber())
7120     {
7121         // msg.sender must be an EOA. Disallows any contract from participating in the DAO.
7122         require(msg.sender == tx.origin);
7123 
7124         StakeInformation memory _info = getStakeInformation(msg.sender);
7125         StakeInformation memory _newInfo = refreshDGDStake(msg.sender, _info);
7126 
7127         uint256 _additionalStake = 0;
7128         if (_amount > 0) _additionalStake = daoCalculatorService().calculateAdditionalLockedDGDStake(_amount);
7129 
7130         _newInfo.userActualLockedDGD = _newInfo.userActualLockedDGD.add(_amount);
7131         _newInfo.userLockedDGDStake = _newInfo.userLockedDGDStake.add(_additionalStake);
7132         _newInfo.totalLockedDGDStake = _newInfo.totalLockedDGDStake.add(_additionalStake);
7133 
7134         // This has to happen at least once before user can participate in next quarter
7135         daoRewardsManager().updateRewardsAndReputationBeforeNewQuarter(msg.sender);
7136 
7137         daoStakeStorage().updateUserDGDStake(msg.sender, _newInfo.userActualLockedDGD, _newInfo.userLockedDGDStake);
7138 
7139 
7140         //since Reputation is updated, we need to refresh moderator status
7141         refreshModeratorStatus(msg.sender, _info, _newInfo);
7142 
7143         uint256 _lastParticipatedQuarter = daoRewardsStorage().lastParticipatedQuarter(msg.sender);
7144         uint256 _currentQuarter = currentQuarterNumber();
7145 
7146         // Note: there might be a case when user locked in very small amount A that is less than Minimum locked DGD
7147         // then, lock again in the middle of the quarter. This will not take into account that A was staked in earlier. Its as if A is only staked in now.
7148         // Its not ideal, but we will keep it this way.
7149         if (_newInfo.userLockedDGDStake >= getUintConfig(CONFIG_MINIMUM_LOCKED_DGD)) {
7150             daoStakeStorage().addToParticipantList(msg.sender); // this will not add a second duplicate of the address if its already there
7151 
7152             // if this is the first time we lock/unlock/continue in this quarter, save the previous lastParticipatedQuarter
7153             // the purpose of the previousLastParticipatedQuarter is so that, if this participant withdraw all his DGD after locking in,
7154             // we will revert his lastParticipatedQuarter to the previousLastParticipatedQuarter, so as to not screw up any calculation
7155             // that uses the lastParticipatedQuarter (for example, for calculating the Reputation penalty for not participating in a number of quarters)
7156             if (_lastParticipatedQuarter < _currentQuarter) {
7157                 daoRewardsStorage().updatePreviousLastParticipatedQuarter(msg.sender, _lastParticipatedQuarter);
7158                 daoRewardsStorage().updateLastParticipatedQuarter(msg.sender, _currentQuarter);
7159             }
7160 
7161             // if this is the first time they're locking tokens, ever,
7162             // reward them with bonus for carbon voting activity
7163             if (_lastParticipatedQuarter == 0) {
7164                 rewardCarbonVotingBonus(msg.sender);
7165             }
7166         } else { // this participant doesnt have enough DGD to be a participant
7167             // Absolute: The lastParticipatedQuarter of this participant WILL NEVER be the current quarter
7168             // Otherwise, his lockedDGDStake must be above the CONFIG_MINIMUM_LOCKED_DGDd
7169 
7170             // Hence, the refreshDGDStake() function must have added _newInfo.userLockedDGDStake to _newInfo.totalLockedDGDStake
7171 
7172             // Since this participant is not counted as a participant, we need to deduct _newInfo.userLockedDGDStake from _newInfo.totalLockedDGDStake
7173             _newInfo.totalLockedDGDStake = _newInfo.totalLockedDGDStake.sub(_newInfo.userLockedDGDStake);
7174             daoStakeStorage().removeFromParticipantList(msg.sender);
7175         }
7176 
7177         daoStakeStorage().updateTotalLockedDGDStake(_newInfo.totalLockedDGDStake);
7178 
7179         // interaction happens last
7180         require(ERC20(dgdToken).transferFrom(msg.sender, address(this), _amount));
7181         emit LockDGD(msg.sender, _amount, _newInfo.userLockedDGDStake);
7182     }
7183 
7184 
7185     /**
7186     @notice Function to withdraw DGD tokens from this contract (can only be withdrawn in the locking phase of quarter)
7187     @param _amount Number of DGD tokens to withdraw
7188     @return {
7189       "_success": "Boolean, true if the withdrawal was successful, revert otherwise"
7190     }
7191     */
7192     function withdrawDGD(uint256 _amount)
7193         public
7194         ifGlobalRewardsSet(currentQuarterNumber())
7195     {
7196         require(isLockingPhase() || daoUpgradeStorage().isReplacedByNewDao()); // If the DAO is already replaced, everyone is free to withdraw their DGDs anytime
7197         StakeInformation memory _info = getStakeInformation(msg.sender);
7198         StakeInformation memory _newInfo = refreshDGDStake(msg.sender, _info);
7199 
7200         // This address must have at least some DGDs locked in, to withdraw
7201         // Otherwise, its meaningless anw
7202         // This also makes sure that the first participation ever must be a lockDGD() call, to avoid unnecessary complications
7203         require(_info.userActualLockedDGD > 0);
7204 
7205         require(_info.userActualLockedDGD >= _amount);
7206         _newInfo.userActualLockedDGD = _newInfo.userActualLockedDGD.sub(_amount);
7207         _newInfo.userLockedDGDStake = _newInfo.userLockedDGDStake.sub(_amount);
7208         _newInfo.totalLockedDGDStake = _newInfo.totalLockedDGDStake.sub(_amount);
7209 
7210         //_newInfo.totalLockedDGDStake = _newInfo.totalLockedDGDStake.sub(_amount);
7211 
7212         // This has to happen at least once before user can participate in next quarter
7213         daoRewardsManager().updateRewardsAndReputationBeforeNewQuarter(msg.sender);
7214 
7215         //since Reputation is updated, we need to refresh moderator status
7216         refreshModeratorStatus(msg.sender, _info, _newInfo);
7217 
7218         uint256 _lastParticipatedQuarter = daoRewardsStorage().lastParticipatedQuarter(msg.sender);
7219         uint256 _currentQuarter = currentQuarterNumber();
7220 
7221         if (_newInfo.userLockedDGDStake < getUintConfig(CONFIG_MINIMUM_LOCKED_DGD)) { // this participant doesnt have enough DGD to be a participant
7222             // if this participant has lock/unlock/continue in this quarter before, we need to revert the lastParticipatedQuarter to the previousLastParticipatedQuarter
7223             if (_lastParticipatedQuarter == _currentQuarter) {
7224                 daoRewardsStorage().updateLastParticipatedQuarter(msg.sender, daoRewardsStorage().previousLastParticipatedQuarter(msg.sender));
7225             }
7226 
7227             // if this participant is not counted as a participant, the totalLockedDGDStake should not take into account the userLockedDGDStake at all
7228             _newInfo.totalLockedDGDStake = _newInfo.totalLockedDGDStake.sub(_newInfo.userLockedDGDStake);
7229 
7230             daoStakeStorage().removeFromParticipantList(msg.sender);
7231         } else { // This participant still remains as a participant
7232             // if this is the first time we lock/unlock/continue in this quarter, save the previous lastParticipatedQuarter
7233             if (_lastParticipatedQuarter < _currentQuarter) {
7234                 daoRewardsStorage().updatePreviousLastParticipatedQuarter(msg.sender, _lastParticipatedQuarter);
7235                 daoRewardsStorage().updateLastParticipatedQuarter(msg.sender, _currentQuarter);
7236 
7237             }
7238             // the totalLockedDGDStake after refreshDGDStake() should decrease by _amount, since this guy withdraws _amount
7239         }
7240 
7241         daoStakeStorage().updateUserDGDStake(msg.sender, _newInfo.userActualLockedDGD, _newInfo.userLockedDGDStake);
7242         daoStakeStorage().updateTotalLockedDGDStake(_newInfo.totalLockedDGDStake);
7243 
7244         require(ERC20(dgdToken).transfer(msg.sender, _amount));
7245 
7246         emit WithdrawDGD(msg.sender, _amount, _newInfo.userLockedDGDStake);
7247     }
7248 
7249 
7250     /**
7251     @notice Function to be called by someone who doesnt change their DGDStake for the next quarter to confirm that they're participating
7252     @dev This can be done in the middle of the quarter as well.
7253          If someone just lets their DGDs sit in the DAO, and don't call this function, they are not counted as a participant in the quarter.
7254     */
7255     function confirmContinuedParticipation()
7256         public
7257     {
7258         lockDGDInternal(0);
7259     }
7260 
7261 
7262     /**
7263     @notice This function refreshes the DGD stake of a user before doing any staking action(locking/withdrawing/continuing) in a new quarter
7264     @dev We need to do this because sometimes, the user locked DGDs in the middle of the previous quarter. Hence, his DGDStake in the record now
7265          is not correct. Note that this function might be called in the middle of the current quarter as well.
7266 
7267         This has no effect if the user has already done some staking action in the current quarter
7268          _infoBefore has the user's current stake information
7269          _infoAfter will be the user's stake information after refreshing
7270 
7271          This function updates the totalLockedDGDStake as if, the _user is participating in this quarter
7272          Therefore, if the _user actually will not qualify as a participant, the caller of this function needs to deduct
7273          _infoAfter.userLockedDGDStake from _infoAfter.totalLockedDGDStake
7274     */
7275     function refreshDGDStake(address _user, StakeInformation _infoBefore)
7276         internal
7277         view
7278         returns (StakeInformation memory _infoAfter)
7279     {
7280         _infoAfter.userLockedDGDStake = _infoBefore.userLockedDGDStake;
7281         _infoAfter.userActualLockedDGD = _infoBefore.userActualLockedDGD;
7282         _infoAfter.totalLockedDGDStake = _infoBefore.totalLockedDGDStake;
7283 
7284         // only need to refresh if this is the first refresh in this new quarter;
7285         uint256 _currentQuarter = currentQuarterNumber();
7286         if (daoRewardsStorage().lastParticipatedQuarter(_user) < _currentQuarter) {
7287             _infoAfter.userLockedDGDStake = daoCalculatorService().calculateAdditionalLockedDGDStake(_infoBefore.userActualLockedDGD);
7288 
7289             _infoAfter.totalLockedDGDStake = _infoAfter.totalLockedDGDStake.add(
7290                 _infoAfter.userLockedDGDStake
7291             );
7292         }
7293     }
7294 
7295 
7296     /**
7297     @notice This function refreshes the Moderator status of a user, to be done right after ANY STEP where a user's reputation or DGDStake is changed
7298     @dev _infoBefore is the stake information of the user before this transaction, _infoAfter is the stake information after this transaction
7299          This function needs to:
7300             - add/remove addresses from the moderator list accordingly
7301             - adjust the totalModeratorLockedDGDStake accordingly as well
7302     */
7303     function refreshModeratorStatus(address _user, StakeInformation _infoBefore, StakeInformation _infoAfter)
7304         internal
7305     {
7306         bool _alreadyParticipatedInThisQuarter = daoRewardsStorage().lastParticipatedQuarter(_user) == currentQuarterNumber();
7307         uint256 _currentTotalModeratorLockedDGDs = daoStakeStorage().totalModeratorLockedDGDStake();
7308 
7309         if (daoStakeStorage().isInModeratorsList(_user) == true) {
7310             // this participant was already in the moderator list
7311 
7312             if (_infoAfter.userLockedDGDStake < getUintConfig(CONFIG_MINIMUM_DGD_FOR_MODERATOR) ||
7313                 daoPointsStorage().getReputation(_user) < getUintConfig(CONFIG_MINIMUM_REPUTATION_FOR_MODERATOR)) {
7314                 // this participant is no longer a moderator this quarter, should be removed
7315 
7316                 // Throw if this is the last moderator. There must be at least one moderator in the moderator list. Otherwise calculateGlobalRewardsBeforeNewQuarter() will fail.
7317                 // after replacing DAO, we will want all moderators to withdraw their DGDs, hence the check
7318                 require(
7319                     (daoStakeStorage().readTotalModerators() > 1) ||
7320                     (!isDaoNotReplaced())
7321                 );
7322 
7323                 daoStakeStorage().removeFromModeratorList(_user);
7324 
7325                 // only need to deduct the dgdStake from the totalModeratorLockedDGDStake if this participant has participated in this quarter before this transaction
7326                 if (_alreadyParticipatedInThisQuarter) {
7327                     daoStakeStorage().updateTotalModeratorLockedDGDs(
7328                         _currentTotalModeratorLockedDGDs.sub(_infoBefore.userLockedDGDStake)
7329                     );
7330                 }
7331 
7332             } else { // this moderator was in the moderator list and still remains a moderator now
7333                 if (_alreadyParticipatedInThisQuarter) { // if already participated in this quarter, just account for the difference in dgdStake
7334                     daoStakeStorage().updateTotalModeratorLockedDGDs(
7335                         _currentTotalModeratorLockedDGDs.sub(_infoBefore.userLockedDGDStake).add(_infoAfter.userLockedDGDStake)
7336                     );
7337                 } else { // has not participated in this quarter before this transaction
7338                     daoStakeStorage().updateTotalModeratorLockedDGDs(
7339                         _currentTotalModeratorLockedDGDs.add(_infoAfter.userLockedDGDStake)
7340                     );
7341                 }
7342             }
7343         } else { // was not in moderator list
7344             if (_infoAfter.userLockedDGDStake >= getUintConfig(CONFIG_MINIMUM_DGD_FOR_MODERATOR) &&
7345                 daoPointsStorage().getReputation(_user) >= getUintConfig(CONFIG_MINIMUM_REPUTATION_FOR_MODERATOR)) {
7346 
7347                 daoStakeStorage().addToModeratorList(_user);
7348                 daoStakeStorage().updateTotalModeratorLockedDGDs(
7349                     _currentTotalModeratorLockedDGDs.add(_infoAfter.userLockedDGDStake)
7350                 );
7351             }
7352         }
7353     }
7354 
7355 
7356     /**
7357     @notice Get the actualLockedDGD and lockedDGDStake of a user, as well as the totalLockedDGDStake of all users
7358     */
7359     function getStakeInformation(address _user)
7360         internal
7361         view
7362         returns (StakeInformation _info)
7363     {
7364         (_info.userActualLockedDGD, _info.userLockedDGDStake) = daoStakeStorage().readUserDGDStake(_user);
7365         _info.totalLockedDGDStake = daoStakeStorage().totalLockedDGDStake();
7366     }
7367 
7368 
7369     /**
7370     @notice Reward the voters of carbon voting rounds with initial bonus reputation
7371     @dev This is only called when they're locking tokens for the first time, enough tokens to be a participant
7372     */
7373     function rewardCarbonVotingBonus(address _user)
7374         internal
7375     {
7376         // if the bonus has already been given out once to this user, return
7377         if (daoStakeStorage().carbonVoteBonusClaimed(_user)) return;
7378 
7379         // for carbon voting 1, if voted, give out a bonus
7380         if (NumberCarbonVoting(carbonVoting1).voted(_user)) {
7381             daoPointsStorage().increaseReputation(_user, getUintConfig(CONFIG_CARBON_VOTE_REPUTATION_BONUS));
7382         }
7383         // for carbon voting 2, if voted, give out a bonus
7384         if (NumberCarbonVoting(carbonVoting2).voted(_user)) {
7385             daoPointsStorage().increaseReputation(_user, getUintConfig(CONFIG_CARBON_VOTE_REPUTATION_BONUS));
7386         }
7387 
7388         // we changed reputation, so we need to update the last quarter that reputation was updated
7389         // This is to take care of this situation:
7390         // Holder A locks DGD for the first time in quarter 5, gets some bonus RP for the carbon votes
7391         // Then, A withdraw all his DGDs right away. Essentially, he's not participating in quarter 5 anymore
7392         // Now, when he comes back at quarter 10, he should be deducted reputation for 5 quarters that he didnt participated in: from quarter 5 to quarter 9
7393         daoRewardsStorage().updateLastQuarterThatReputationWasUpdated(msg.sender, currentQuarterNumber().sub(1));
7394 
7395         // set that this user's carbon voting bonus has been given out
7396         daoStakeStorage().setCarbonVoteBonusClaimed(_user);
7397     }
7398 }