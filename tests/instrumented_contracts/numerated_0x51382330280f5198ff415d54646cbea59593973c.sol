1 pragma solidity 0.5.7;
2 contract DCN {
3   event UserCreated(address indexed creator, uint64 user_id);
4   event UserTradeAddressUpdated(uint64 user_id);
5   event SessionUpdated(uint64 user_id, uint64 exchange_id);
6   event ExchangeDeposit(uint64 user_id, uint64 exchange_id, uint32 asset_id);
7   uint256 creator;
8   uint256 creator_recovery;
9   uint256 creator_recovery_proposed;
10   uint256 user_count;
11   uint256 exchange_count;
12   uint256 asset_count;
13   uint256 security_locked_features;
14   uint256 security_locked_features_proposed;
15   uint256 security_proposed_unlock_timestamp;
16   struct Exchange {
17     uint88 name;
18     uint8 locked;
19     address owner;
20     uint256 withdraw_address;
21     uint256 recovery_address;
22     uint256 recovery_address_proposed;
23     uint256[4294967296] balances;
24   }
25   struct Asset {
26     uint64 symbol;
27     uint192 unit_scale;
28     uint256 contract_address;
29   }
30   struct MarketState {
31     int64 quote_qty;
32     int64 base_qty;
33     uint64 fee_used;
34     uint64 fee_limit;
35     int64 min_quote_qty;
36     int64 min_base_qty;
37     uint64 long_max_price;
38     uint64 short_min_price;
39     uint64 limit_version;
40     int96 quote_shift;
41     int96 base_shift;
42   }
43   struct SessionBalance {
44     uint128 total_deposit;
45     uint64 unsettled_withdraw_total;
46     uint64 asset_balance;
47   }
48   struct ExchangeSession {
49     uint256 unlock_at;
50     uint256 trade_address;
51     SessionBalance[4294967296] balances;
52     MarketState[18446744073709551616] market_states;
53   }
54   struct User {
55     uint256 trade_address;
56     uint256 withdraw_address;
57     uint256 recovery_address;
58     uint256 recovery_address_proposed;
59     uint256[4294967296] balances;
60     ExchangeSession[4294967296] exchange_sessions;
61   }
62   User[18446744073709551616] users;
63   Asset[4294967296] assets;
64   Exchange[4294967296] exchanges;
65   
66   constructor() public  {
67     assembly {
68       sstore(creator_slot, caller)
69       sstore(creator_recovery_slot, caller)
70     }
71   }
72   
73   function get_security_state() public view 
74   returns (uint256 locked_features, uint256 locked_features_proposed, uint256 proposed_unlock_timestamp) {
75     
76     uint256[3] memory return_value_mem;
77     assembly {
78       mstore(return_value_mem, sload(security_locked_features_slot))
79       mstore(add(return_value_mem, 32), sload(security_locked_features_proposed_slot))
80       mstore(add(return_value_mem, 64), sload(security_proposed_unlock_timestamp_slot))
81       return(return_value_mem, 96)
82     }
83   }
84   
85   function get_creator() public view 
86   returns (address dcn_creator, address dcn_creator_recovery, address dcn_creator_recovery_proposed) {
87     
88     uint256[3] memory return_value_mem;
89     assembly {
90       mstore(return_value_mem, sload(creator_slot))
91       mstore(add(return_value_mem, 32), sload(creator_recovery_slot))
92       mstore(add(return_value_mem, 64), sload(creator_recovery_proposed_slot))
93       return(return_value_mem, 96)
94     }
95   }
96   
97   function get_asset(uint32 asset_id) public view 
98   returns (string memory symbol, uint192 unit_scale, address contract_address) {
99     
100     uint256[5] memory return_value_mem;
101     assembly {
102       let asset_count := sload(asset_count_slot)
103       if iszero(lt(asset_id, asset_count)) {
104         mstore(32, 1)
105         revert(63, 1)
106       }
107       let asset_ptr := add(assets_slot, mul(2, asset_id))
108       let asset_0 := sload(asset_ptr)
109       let asset_1 := sload(add(asset_ptr, 1))
110       mstore(return_value_mem, 96)
111       mstore(add(return_value_mem, 96), 8)
112       mstore(add(return_value_mem, 128), asset_0)
113       mstore(add(return_value_mem, 32), and(asset_0, 0xffffffffffffffffffffffffffffffffffffffffffffffff))
114       mstore(add(return_value_mem, 64), asset_1)
115       return(return_value_mem, 136)
116     }
117   }
118   
119   function get_exchange(uint32 exchange_id) public view 
120   returns (
121     string memory name, bool locked, address owner,
122     address withdraw_address, address recovery_address, address recovery_address_proposed
123   ) {
124     
125     uint256[8] memory return_value_mem;
126     assembly {
127       let exchange_count := sload(exchange_count_slot)
128       if iszero(lt(exchange_id, exchange_count)) {
129         mstore(32, 1)
130         revert(63, 1)
131       }
132       let exchange_ptr := add(exchanges_slot, mul(4294967300, exchange_id))
133       let exchange_0 := sload(exchange_ptr)
134       let exchange_1 := sload(add(exchange_ptr, 1))
135       let exchange_2 := sload(add(exchange_ptr, 2))
136       let exchange_3 := sload(add(exchange_ptr, 3))
137       mstore(return_value_mem, 192)
138       mstore(add(return_value_mem, 192), 11)
139       mstore(add(return_value_mem, 224), exchange_0)
140       mstore(add(return_value_mem, 32), and(div(exchange_0, 0x10000000000000000000000000000000000000000), 0xff))
141       mstore(add(return_value_mem, 64), and(exchange_0, 0xffffffffffffffffffffffffffffffffffffffff))
142       mstore(add(return_value_mem, 96), exchange_1)
143       mstore(add(return_value_mem, 128), exchange_2)
144       mstore(add(return_value_mem, 160), exchange_3)
145       return(return_value_mem, 236)
146     }
147   }
148   
149   function get_exchange_balance(uint32 exchange_id, uint32 asset_id) public view 
150   returns (uint256 exchange_balance) {
151     
152     uint256[1] memory return_value_mem;
153     assembly {
154       let exchange_ptr := add(exchanges_slot, mul(4294967300, exchange_id))
155       let exchange_balance_ptr := add(add(exchange_ptr, 4), asset_id)
156       mstore(return_value_mem, sload(exchange_balance_ptr))
157       return(return_value_mem, 32)
158     }
159   }
160   
161   function get_exchange_count() public view 
162   returns (uint32 count) {
163     
164     uint256[1] memory return_value_mem;
165     assembly {
166       mstore(return_value_mem, sload(exchange_count_slot))
167       return(return_value_mem, 32)
168     }
169   }
170   
171   function get_asset_count() public view 
172   returns (uint32 count) {
173     
174     uint256[1] memory return_value_mem;
175     assembly {
176       mstore(return_value_mem, sload(asset_count_slot))
177       return(return_value_mem, 32)
178     }
179   }
180   
181   function get_user_count() public view 
182   returns (uint32 count) {
183     
184     uint256[1] memory return_value_mem;
185     assembly {
186       mstore(return_value_mem, sload(user_count_slot))
187       return(return_value_mem, 32)
188     }
189   }
190   
191   function get_user(uint64 user_id) public view 
192   returns (
193     address trade_address,
194     address withdraw_address, address recovery_address, address recovery_address_proposed
195   ) {
196     
197     uint256[4] memory return_value_mem;
198     assembly {
199       let user_count := sload(user_count_slot)
200       if iszero(lt(user_id, user_count)) {
201         mstore(32, 1)
202         revert(63, 1)
203       }
204       let user_ptr := add(users_slot, mul(237684487561239756867226304516, user_id))
205       mstore(return_value_mem, sload(add(user_ptr, 0)))
206       mstore(add(return_value_mem, 32), sload(add(user_ptr, 1)))
207       mstore(add(return_value_mem, 64), sload(add(user_ptr, 2)))
208       mstore(add(return_value_mem, 96), sload(add(user_ptr, 3)))
209       return(return_value_mem, 128)
210     }
211   }
212   
213   function get_balance(uint64 user_id, uint32 asset_id) public view 
214   returns (uint256 return_balance) {
215     
216     uint256[1] memory return_value_mem;
217     assembly {
218       let user_ptr := add(users_slot, mul(237684487561239756867226304516, user_id))
219       let user_balance_ptr := add(add(user_ptr, 4), asset_id)
220       mstore(return_value_mem, sload(user_balance_ptr))
221       return(return_value_mem, 32)
222     }
223   }
224   
225   function get_session(uint64 user_id, uint32 exchange_id) public view 
226   returns (uint256 unlock_at, address trade_address) {
227     
228     uint256[2] memory return_value_mem;
229     assembly {
230       let user_ptr := add(users_slot, mul(237684487561239756867226304516, user_id))
231       let session_ptr := add(add(user_ptr, 4294967300), mul(55340232225423622146, exchange_id))
232       mstore(return_value_mem, sload(add(session_ptr, 0)))
233       mstore(add(return_value_mem, 32), sload(add(session_ptr, 1)))
234       return(return_value_mem, 64)
235     }
236   }
237   
238   function get_session_balance(uint64 user_id, uint32 exchange_id, uint32 asset_id) public view 
239   returns (uint128 total_deposit, uint64 unsettled_withdraw_total, uint64 asset_balance) {
240     
241     uint256[3] memory return_value_mem;
242     assembly {
243       let user_ptr := add(users_slot, mul(237684487561239756867226304516, user_id))
244       let session_ptr := add(add(user_ptr, 4294967300), mul(55340232225423622146, exchange_id))
245       let session_balance_ptr := add(add(session_ptr, 2), asset_id)
246       let session_balance_0 := sload(session_balance_ptr)
247       mstore(return_value_mem, and(div(session_balance_0, 0x100000000000000000000000000000000), 0xffffffffffffffffffffffffffffffff))
248       mstore(add(return_value_mem, 32), and(div(session_balance_0, 0x10000000000000000), 0xffffffffffffffff))
249       mstore(add(return_value_mem, 64), and(session_balance_0, 0xffffffffffffffff))
250       return(return_value_mem, 96)
251     }
252   }
253   
254   function get_market_state(
255     uint64 user_id, uint32 exchange_id,
256     uint32 quote_asset_id, uint32 base_asset_id
257   ) public view 
258   returns (
259     int64 quote_qty, int64 base_qty, uint64 fee_used, uint64 fee_limit,
260     int64 min_quote_qty, int64 min_base_qty, uint64 long_max_price, uint64 short_min_price,
261     uint64 limit_version, int96 quote_shift, int96 base_shift
262   ) {
263     
264     uint256[11] memory return_value_mem;
265     assembly {
266       base_shift := base_asset_id
267       quote_shift := quote_asset_id
268       let user_ptr := add(users_slot, mul(237684487561239756867226304516, user_id))
269       let exchange_session_ptr := add(add(user_ptr, 4294967300), mul(55340232225423622146, exchange_id))
270       let exchange_state_ptr := add(add(exchange_session_ptr, 4294967298), mul(3, or(mul(quote_shift, 4294967296), base_shift)))
271       let state_data_0 := sload(exchange_state_ptr)
272       let state_data_1 := sload(add(exchange_state_ptr, 1))
273       let state_data_2 := sload(add(exchange_state_ptr, 2))
274       {
275         let tmp := and(div(state_data_0, 0x1000000000000000000000000000000000000000000000000), 0xffffffffffffffff)
276         tmp := signextend(7, tmp)
277         mstore(add(return_value_mem, 0), tmp)
278       }
279       {
280         let tmp := and(div(state_data_0, 0x100000000000000000000000000000000), 0xffffffffffffffff)
281         tmp := signextend(7, tmp)
282         mstore(add(return_value_mem, 32), tmp)
283       }
284       mstore(add(return_value_mem, 64), and(div(state_data_0, 0x10000000000000000), 0xffffffffffffffff))
285       mstore(add(return_value_mem, 96), and(state_data_0, 0xffffffffffffffff))
286       {
287         let tmp := and(div(state_data_1, 0x1000000000000000000000000000000000000000000000000), 0xffffffffffffffff)
288         tmp := signextend(7, tmp)
289         mstore(add(return_value_mem, 128), tmp)
290       }
291       {
292         let tmp := and(div(state_data_1, 0x100000000000000000000000000000000), 0xffffffffffffffff)
293         tmp := signextend(7, tmp)
294         mstore(add(return_value_mem, 160), tmp)
295       }
296       mstore(add(return_value_mem, 192), and(div(state_data_1, 0x10000000000000000), 0xffffffffffffffff))
297       mstore(add(return_value_mem, 224), and(state_data_1, 0xffffffffffffffff))
298       mstore(add(return_value_mem, 256), and(div(state_data_2, 0x1000000000000000000000000000000000000000000000000), 0xffffffffffffffff))
299       {
300         let tmp := and(div(state_data_2, 0x1000000000000000000000000), 0xffffffffffffffffffffffff)
301         tmp := signextend(11, tmp)
302         mstore(add(return_value_mem, 288), tmp)
303       }
304       {
305         let tmp := and(state_data_2, 0xffffffffffffffffffffffff)
306         tmp := signextend(11, tmp)
307         mstore(add(return_value_mem, 320), tmp)
308       }
309       return(return_value_mem, 352)
310     }
311   }
312   
313   function security_lock(uint256 lock_features) public  {
314     assembly {
315       {
316         let creator := sload(creator_slot)
317         if iszero(eq(caller, creator)) {
318           mstore(32, 1)
319           revert(63, 1)
320         }
321       }
322       let locked_features := sload(security_locked_features_slot)
323       sstore(security_locked_features_slot, or(locked_features, lock_features))
324       sstore(security_locked_features_proposed_slot, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
325     }
326   }
327   
328   function security_propose(uint256 proposed_locked_features) public  {
329     assembly {
330       {
331         let creator := sload(creator_slot)
332         if iszero(eq(caller, creator)) {
333           mstore(32, 1)
334           revert(63, 1)
335         }
336       }
337       let current_proposal := sload(security_locked_features_proposed_slot)
338       let proposed_differences := xor(current_proposal, proposed_locked_features)
339       let does_unlocks_features := and(proposed_differences, not(proposed_locked_features))
340       if does_unlocks_features {
341         sstore(security_proposed_unlock_timestamp_slot, add(timestamp, 172800))
342       }
343       sstore(security_locked_features_proposed_slot, proposed_locked_features)
344     }
345   }
346   
347   function security_set_proposed() public  {
348     assembly {
349       {
350         let creator := sload(creator_slot)
351         if iszero(eq(caller, creator)) {
352           mstore(32, 1)
353           revert(63, 1)
354         }
355       }
356       let unlock_timestamp := sload(security_proposed_unlock_timestamp_slot)
357       if gt(unlock_timestamp, timestamp) {
358         mstore(32, 2)
359         revert(63, 1)
360       }
361       sstore(security_locked_features_slot, sload(security_locked_features_proposed_slot))
362     }
363   }
364   
365   function creator_update(address new_creator) public  {
366     assembly {
367       let creator_recovery := sload(creator_recovery_slot)
368       if iszero(eq(caller, creator_recovery)) {
369         mstore(32, 1)
370         revert(63, 1)
371       }
372       sstore(creator_slot, new_creator)
373     }
374   }
375   
376   function creator_propose_recovery(address recovery) public  {
377     assembly {
378       let creator_recovery := sload(creator_recovery_slot)
379       if iszero(eq(caller, creator_recovery)) {
380         mstore(32, 1)
381         revert(63, 1)
382       }
383       sstore(creator_recovery_proposed_slot, recovery)
384     }
385   }
386   
387   function creator_set_recovery() public  {
388     assembly {
389       let creator_recovery_proposed := sload(creator_recovery_proposed_slot)
390       if or(iszero(eq(caller, creator_recovery_proposed)), iszero(caller)) {
391         mstore(32, 1)
392         revert(63, 1)
393       }
394       sstore(creator_recovery_slot, caller)
395       sstore(creator_recovery_proposed_slot, 0)
396     }
397   }
398   
399   function set_exchange_locked(uint32 exchange_id, bool locked) public  {
400     assembly {
401       {
402         let creator := sload(creator_slot)
403         if iszero(eq(caller, creator)) {
404           mstore(32, 1)
405           revert(63, 1)
406         }
407       }
408       {
409         let exchange_count := sload(exchange_count_slot)
410         if iszero(lt(exchange_id, exchange_count)) {
411           mstore(32, 2)
412           revert(63, 1)
413         }
414       }
415       let exchange_ptr := add(exchanges_slot, mul(4294967300, exchange_id))
416       let exchange_0 := sload(exchange_ptr)
417       sstore(exchange_ptr, or(and(0xffffffffffffffffffffff00ffffffffffffffffffffffffffffffffffffffff, exchange_0), 
418         /* locked */ mul(locked, 0x10000000000000000000000000000000000000000)))
419     }
420   }
421   
422   function user_create() public 
423   returns (uint64 user_id) {
424     
425     uint256[2] memory log_data_mem;
426     assembly {
427       {
428         let locked_features := sload(security_locked_features_slot)
429         if and(locked_features, 0x4) {
430           mstore(32, 0)
431           revert(63, 1)
432         }
433       }
434       user_id := sload(user_count_slot)
435       if iszero(lt(user_id, 18446744073709551616)) {
436         mstore(32, 1)
437         revert(63, 1)
438       }
439       sstore(user_count_slot, add(user_id, 1))
440       let user_ptr := add(users_slot, mul(237684487561239756867226304516, user_id))
441       sstore(add(user_ptr, 0), caller)
442       sstore(add(user_ptr, 1), caller)
443       sstore(add(user_ptr, 2), caller)
444       
445       /* Log event: UserCreated */
446       mstore(log_data_mem, user_id)
447       log2(log_data_mem, 32, /* UserCreated */ 0x49d7af0c8ce0d26f4490c17a316a59a7a5d28599a2208862554b648ebdf193f4, caller)
448     }
449   }
450   
451   function user_set_trade_address(uint64 user_id, address trade_address) public  {
452     
453     uint256[1] memory log_data_mem;
454     assembly {
455       let user_ptr := add(users_slot, mul(237684487561239756867226304516, user_id))
456       let recovery_address := sload(add(user_ptr, 2))
457       if iszero(eq(caller, recovery_address)) {
458         mstore(32, 1)
459         revert(63, 1)
460       }
461       sstore(add(user_ptr, 0), trade_address)
462       
463       /* Log event: UserTradeAddressUpdated */
464       mstore(log_data_mem, user_id)
465       log1(log_data_mem, 32, /* UserTradeAddressUpdated */ 0x0dcac7e45506b3812319ae528c780b9035570ee3b3557272431dce5b397d880a)
466     }
467   }
468   
469   function user_set_withdraw_address(uint64 user_id, address withdraw_address) public  {
470     assembly {
471       let user_ptr := add(users_slot, mul(237684487561239756867226304516, user_id))
472       let recovery_address := sload(add(user_ptr, 2))
473       if iszero(eq(caller, recovery_address)) {
474         mstore(32, 1)
475         revert(63, 1)
476       }
477       sstore(add(user_ptr, 1), withdraw_address)
478     }
479   }
480   
481   function user_propose_recovery_address(uint64 user_id, address proposed) public  {
482     assembly {
483       let user_ptr := add(users_slot, mul(237684487561239756867226304516, user_id))
484       let recovery_address := sload(add(user_ptr, 2))
485       if iszero(eq(caller, recovery_address)) {
486         mstore(32, 1)
487         revert(63, 1)
488       }
489       sstore(add(user_ptr, 3), proposed)
490     }
491   }
492   
493   function user_set_recovery_address(uint64 user_id) public  {
494     assembly {
495       let user_ptr := add(users_slot, mul(237684487561239756867226304516, user_id))
496       let proposed_ptr := add(user_ptr, 3)
497       let recovery_address_proposed := sload(proposed_ptr)
498       if iszero(eq(caller, recovery_address_proposed)) {
499         mstore(32, 1)
500         revert(63, 1)
501       }
502       sstore(proposed_ptr, 0)
503       sstore(add(user_ptr, 2), recovery_address_proposed)
504     }
505   }
506   
507   function exchange_set_owner(uint32 exchange_id, address new_owner) public  {
508     assembly {
509       let exchange_ptr := add(exchanges_slot, mul(4294967300, exchange_id))
510       let exchange_recovery := sload(add(exchange_ptr, 2))
511       if iszero(eq(caller, exchange_recovery)) {
512         mstore(32, 1)
513         revert(63, 1)
514       }
515       let exchange_0 := sload(exchange_ptr)
516       sstore(exchange_ptr, or(and(exchange_0, 0xffffffffffffffffffffffff0000000000000000000000000000000000000000), 
517         /* owner */ new_owner))
518     }
519   }
520   
521   function exchange_set_withdraw(uint32 exchange_id, address new_withdraw) public  {
522     assembly {
523       let exchange_ptr := add(exchanges_slot, mul(4294967300, exchange_id))
524       let exchange_recovery := sload(add(exchange_ptr, 2))
525       if iszero(eq(caller, exchange_recovery)) {
526         mstore(32, 1)
527         revert(63, 1)
528       }
529       sstore(add(exchange_ptr, 1), new_withdraw)
530     }
531   }
532   
533   function exchange_propose_recovery(uint32 exchange_id, address proposed) public  {
534     assembly {
535       let exchange_ptr := add(exchanges_slot, mul(4294967300, exchange_id))
536       let exchange_recovery := sload(add(exchange_ptr, 2))
537       if iszero(eq(caller, exchange_recovery)) {
538         mstore(32, 1)
539         revert(63, 1)
540       }
541       sstore(add(exchange_ptr, 3), proposed)
542     }
543   }
544   
545   function exchange_set_recovery(uint32 exchange_id) public  {
546     assembly {
547       let exchange_ptr := add(exchanges_slot, mul(4294967300, exchange_id))
548       let exchange_recovery_proposed := sload(add(exchange_ptr, 3))
549       if or(iszero(eq(caller, exchange_recovery_proposed)), iszero(caller)) {
550         mstore(32, 1)
551         revert(63, 1)
552       }
553       sstore(add(exchange_ptr, 2), caller)
554     }
555   }
556   
557   function add_asset(string memory symbol, uint192 unit_scale, address contract_address) public 
558   returns (uint64 asset_id) {
559     assembly {
560       {
561         let locked_features := sload(security_locked_features_slot)
562         if and(locked_features, 0x1) {
563           mstore(32, 0)
564           revert(63, 1)
565         }
566       }
567       {
568         let creator := sload(creator_slot)
569         if iszero(eq(caller, creator)) {
570           mstore(32, 1)
571           revert(63, 1)
572         }
573       }
574       asset_id := sload(asset_count_slot)
575       if iszero(lt(asset_id, 4294967296)) {
576         mstore(32, 2)
577         revert(63, 1)
578       }
579       let symbol_len := mload(symbol)
580       if iszero(eq(symbol_len, 8)) {
581         mstore(32, 3)
582         revert(63, 1)
583       }
584       if iszero(unit_scale) {
585         mstore(32, 4)
586         revert(63, 1)
587       }
588       if iszero(contract_address) {
589         mstore(32, 5)
590         revert(63, 1)
591       }
592       let asset_symbol := mload(add(symbol, 32))
593       let asset_data_0 := or(asset_symbol, 
594         /* unit_scale */ unit_scale)
595       let asset_ptr := add(assets_slot, mul(2, asset_id))
596       sstore(asset_ptr, asset_data_0)
597       sstore(add(asset_ptr, 1), contract_address)
598       sstore(asset_count_slot, add(asset_id, 1))
599     }
600   }
601   
602   function add_exchange(string memory name, address addr) public 
603   returns (uint64 exchange_id) {
604     assembly {
605       {
606         let locked_features := sload(security_locked_features_slot)
607         if and(locked_features, 0x2) {
608           mstore(32, 0)
609           revert(63, 1)
610         }
611       }
612       {
613         let creator := sload(creator_slot)
614         if iszero(eq(caller, creator)) {
615           mstore(32, 1)
616           revert(63, 1)
617         }
618       }
619       let name_len := mload(name)
620       if iszero(eq(name_len, 11)) {
621         mstore(32, 2)
622         revert(63, 1)
623       }
624       exchange_id := sload(exchange_count_slot)
625       if iszero(lt(exchange_id, 4294967296)) {
626         mstore(32, 3)
627         revert(63, 1)
628       }
629       let exchange_ptr := add(exchanges_slot, mul(4294967300, exchange_id))
630       let name_data := mload(add(name, 32))
631       let exchange_0 := or(name_data, 
632         /* owner */ addr)
633       sstore(exchange_ptr, exchange_0)
634       sstore(add(exchange_ptr, 1), addr)
635       sstore(add(exchange_ptr, 2), addr)
636       sstore(exchange_count_slot, add(exchange_id, 1))
637     }
638   }
639   
640   function exchange_withdraw(uint32 exchange_id, uint32 asset_id,
641                              address destination, uint64 quantity) public  {
642     
643     uint256[3] memory transfer_in_mem;
644     
645     uint256[1] memory transfer_out_mem;
646     assembly {
647       let exchange_ptr := add(exchanges_slot, mul(4294967300, exchange_id))
648       let withdraw_address := sload(add(exchange_ptr, 1))
649       if iszero(eq(caller, withdraw_address)) {
650         mstore(32, 1)
651         revert(63, 1)
652       }
653       let exchange_balance_ptr := add(add(exchange_ptr, 4), asset_id)
654       let exchange_balance := sload(exchange_balance_ptr)
655       if gt(quantity, exchange_balance) {
656         mstore(32, 2)
657         revert(63, 1)
658       }
659       sstore(exchange_balance_ptr, sub(exchange_balance, quantity))
660       let asset_ptr := add(assets_slot, mul(2, asset_id))
661       let unit_scale := and(sload(asset_ptr), 0xffffffffffffffffffffffffffffffffffffffffffffffff)
662       let asset_address := sload(add(asset_ptr, 1))
663       let withdraw := mul(quantity, unit_scale)
664       mstore(transfer_in_mem, /* fn_hash("transfer(address,uint256)") */ 0xa9059cbb00000000000000000000000000000000000000000000000000000000)
665       mstore(add(transfer_in_mem, 4), destination)
666       mstore(add(transfer_in_mem, 36), withdraw)
667       {
668         let success := call(gas, asset_address, 0, transfer_in_mem, 68, transfer_out_mem, 32)
669         if iszero(success) {
670           mstore(32, 3)
671           revert(63, 1)
672         }
673         switch returndatasize
674           case 0 {}
675           case 32 {
676             let result := mload(transfer_out_mem)
677             if iszero(result) {
678               mstore(32, 4)
679               revert(63, 1)
680             }
681           }
682           default {
683             mstore(32, 4)
684             revert(63, 1)
685           }
686       }
687     }
688   }
689   
690   function exchange_deposit(uint32 exchange_id, uint32 asset_id, uint64 quantity) public  {
691     
692     uint256[3] memory transfer_in_mem;
693     
694     uint256[1] memory transfer_out_mem;
695     assembly {
696       {
697         let locked_features := sload(security_locked_features_slot)
698         if and(locked_features, 0x8) {
699           mstore(32, 0)
700           revert(63, 1)
701         }
702       }
703       {
704         let exchange_count := sload(exchange_count_slot)
705         if iszero(lt(exchange_id, exchange_count)) {
706           mstore(32, 1)
707           revert(63, 1)
708         }
709       }
710       {
711         let asset_count := sload(asset_count_slot)
712         if iszero(lt(asset_id, asset_count)) {
713           mstore(32, 2)
714           revert(63, 1)
715         }
716       }
717       let exchange_balance_ptr := add(add(add(exchanges_slot, mul(4294967300, exchange_id)), 4), asset_id)
718       let exchange_balance := sload(exchange_balance_ptr)
719       let updated_balance := add(exchange_balance, quantity)
720       if gt(updated_balance, 0xFFFFFFFFFFFFFFFF) {
721         mstore(32, 3)
722         revert(63, 1)
723       }
724       let asset_ptr := add(assets_slot, mul(2, asset_id))
725       let unit_scale := and(sload(asset_ptr), 0xffffffffffffffffffffffffffffffffffffffffffffffff)
726       let asset_address := sload(add(asset_ptr, 1))
727       let deposit := mul(quantity, unit_scale)
728       sstore(exchange_balance_ptr, updated_balance)
729       mstore(transfer_in_mem, /* fn_hash("transferFrom(address,address,uint256)") */ 0x23b872dd00000000000000000000000000000000000000000000000000000000)
730       mstore(add(transfer_in_mem, 4), caller)
731       mstore(add(transfer_in_mem, 36), address)
732       mstore(add(transfer_in_mem, 68), deposit)
733       {
734         let success := call(gas, asset_address, 0, transfer_in_mem, 100, transfer_out_mem, 32)
735         if iszero(success) {
736           mstore(32, 4)
737           revert(63, 1)
738         }
739         switch returndatasize
740           case 0 {}
741           case 32 {
742             let result := mload(transfer_out_mem)
743             if iszero(result) {
744               mstore(32, 5)
745               revert(63, 1)
746             }
747           }
748           default {
749             mstore(32, 5)
750             revert(63, 1)
751           }
752       }
753     }
754   }
755   
756   function user_deposit(uint64 user_id, uint32 asset_id, uint256 amount) public  {
757     
758     uint256[4] memory transfer_in_mem;
759     
760     uint256[1] memory transfer_out_mem;
761     assembly {
762       {
763         let locked_features := sload(security_locked_features_slot)
764         if and(locked_features, 0x10) {
765           mstore(32, 0)
766           revert(63, 1)
767         }
768       }
769       {
770         let user_count := sload(user_count_slot)
771         if iszero(lt(user_id, user_count)) {
772           mstore(32, 1)
773           revert(63, 1)
774         }
775       }
776       {
777         let asset_count := sload(asset_count_slot)
778         if iszero(lt(asset_id, asset_count)) {
779           mstore(32, 2)
780           revert(63, 1)
781         }
782       }
783       if iszero(amount) {
784         stop()
785       }
786       let balance_ptr := add(add(add(users_slot, mul(237684487561239756867226304516, user_id)), 4), asset_id)
787       let current_balance := sload(balance_ptr)
788       let proposed_balance := add(current_balance, amount)
789       if lt(proposed_balance, current_balance) {
790         mstore(32, 3)
791         revert(63, 1)
792       }
793       let asset_address := sload(add(add(assets_slot, mul(2, asset_id)), 1))
794       sstore(balance_ptr, proposed_balance)
795       mstore(transfer_in_mem, /* fn_hash("transferFrom(address,address,uint256)") */ 0x23b872dd00000000000000000000000000000000000000000000000000000000)
796       mstore(add(transfer_in_mem, 4), caller)
797       mstore(add(transfer_in_mem, 36), address)
798       mstore(add(transfer_in_mem, 68), amount)
799       {
800         let success := call(gas, asset_address, 0, transfer_in_mem, 100, transfer_out_mem, 32)
801         if iszero(success) {
802           mstore(32, 4)
803           revert(63, 1)
804         }
805         switch returndatasize
806           case 0 {}
807           case 32 {
808             let result := mload(transfer_out_mem)
809             if iszero(result) {
810               mstore(32, 5)
811               revert(63, 1)
812             }
813           }
814           default {
815             mstore(32, 5)
816             revert(63, 1)
817           }
818       }
819     }
820   }
821   
822   function user_withdraw(uint64 user_id, uint32 asset_id, address destination, uint256 amount) public  {
823     
824     uint256[3] memory transfer_in_mem;
825     
826     uint256[1] memory transfer_out_mem;
827     assembly {
828       if iszero(amount) {
829         stop()
830       }
831       {
832         let user_count := sload(user_count_slot)
833         if iszero(lt(user_id, user_count)) {
834           mstore(32, 6)
835           revert(63, 1)
836         }
837       }
838       {
839         let asset_count := sload(asset_count_slot)
840         if iszero(lt(asset_id, asset_count)) {
841           mstore(32, 1)
842           revert(63, 1)
843         }
844       }
845       let user_ptr := add(users_slot, mul(237684487561239756867226304516, user_id))
846       let withdraw_address := sload(add(user_ptr, 1))
847       if iszero(eq(caller, withdraw_address)) {
848         mstore(32, 2)
849         revert(63, 1)
850       }
851       let balance_ptr := add(add(user_ptr, 4), asset_id)
852       let current_balance := sload(balance_ptr)
853       if lt(current_balance, amount) {
854         mstore(32, 3)
855         revert(63, 1)
856       }
857       sstore(balance_ptr, sub(current_balance, amount))
858       let asset_address := sload(add(add(assets_slot, mul(2, asset_id)), 1))
859       mstore(transfer_in_mem, /* fn_hash("transfer(address,uint256)") */ 0xa9059cbb00000000000000000000000000000000000000000000000000000000)
860       mstore(add(transfer_in_mem, 4), destination)
861       mstore(add(transfer_in_mem, 36), amount)
862       {
863         let success := call(gas, asset_address, 0, transfer_in_mem, 68, transfer_out_mem, 32)
864         if iszero(success) {
865           mstore(32, 4)
866           revert(63, 1)
867         }
868         switch returndatasize
869           case 0 {}
870           case 32 {
871             let result := mload(transfer_out_mem)
872             if iszero(result) {
873               mstore(32, 5)
874               revert(63, 1)
875             }
876           }
877           default {
878             mstore(32, 5)
879             revert(63, 1)
880           }
881       }
882     }
883   }
884   
885   function user_session_set_unlock_at(uint64 user_id, uint32 exchange_id, uint256 unlock_at) public  {
886     
887     uint256[3] memory log_data_mem;
888     assembly {
889       {
890         let exchange_count := sload(exchange_count_slot)
891         if iszero(lt(exchange_id, exchange_count)) {
892           mstore(32, 1)
893           revert(63, 1)
894         }
895       }
896       let user_ptr := add(users_slot, mul(237684487561239756867226304516, user_id))
897       let trade_address := sload(add(user_ptr, 0))
898       if iszero(eq(caller, trade_address)) {
899         mstore(32, 2)
900         revert(63, 1)
901       }
902       {
903         let fails_min_time := lt(unlock_at, add(timestamp, 28800))
904         let fails_max_time := gt(unlock_at, add(timestamp, 1209600))
905         if or(fails_min_time, fails_max_time) {
906           mstore(32, 3)
907           revert(63, 1)
908         }
909       }
910       let session_ptr := add(add(user_ptr, 4294967300), mul(55340232225423622146, exchange_id))
911       let unlock_at_ptr := add(session_ptr, 0)
912       if lt(sload(unlock_at_ptr), timestamp) {
913         sstore(add(session_ptr, 1), caller)
914       }
915       sstore(unlock_at_ptr, unlock_at)
916       
917       /* Log event: SessionUpdated */
918       mstore(log_data_mem, user_id)
919       mstore(add(log_data_mem, 32), exchange_id)
920       log1(log_data_mem, 64, /* SessionUpdated */ 0x1b0c381a98d9352dd527280acefa9a69d2c111b6a9d3aa3063aac6c2ec7f3163)
921     }
922   }
923   
924   function user_market_reset(uint64 user_id, uint32 exchange_id,
925                              uint32 quote_asset_id, uint32 base_asset_id) public  {
926     assembly {
927       {
928         let locked_features := sload(security_locked_features_slot)
929         if and(locked_features, 0x400) {
930           mstore(32, 0)
931           revert(63, 1)
932         }
933       }
934       {
935         let exchange_count := sload(exchange_count_slot)
936         if iszero(lt(exchange_id, exchange_count)) {
937           mstore(32, 1)
938           revert(63, 1)
939         }
940       }
941       let user_ptr := add(users_slot, mul(237684487561239756867226304516, user_id))
942       let trade_address := sload(add(user_ptr, 0))
943       if iszero(eq(caller, trade_address)) {
944         mstore(32, 2)
945         revert(63, 1)
946       }
947       let session_ptr := add(add(user_ptr, 4294967300), mul(55340232225423622146, exchange_id))
948       let unlock_at := sload(add(session_ptr, 0))
949       if gt(unlock_at, timestamp) {
950         mstore(32, 3)
951         revert(63, 1)
952       }
953       let market_state_ptr := add(add(session_ptr, 4294967298), mul(3, or(mul(quote_asset_id, 4294967296), base_asset_id)))
954       sstore(market_state_ptr, 0)
955       sstore(add(market_state_ptr, 1), 0)
956       let market_state_2_ptr := add(market_state_ptr, 2)
957       let market_state_2 := sload(market_state_2_ptr)
958       let limit_version := add(and(div(market_state_2, 0x1000000000000000000000000000000000000000000000000), 0xffffffffffffffff), 1)
959       sstore(market_state_2_ptr, 
960         /* limit_version */ mul(limit_version, 0x1000000000000000000000000000000000000000000000000))
961     }
962   }
963   
964   function transfer_to_session(uint64 user_id, uint32 exchange_id, uint32 asset_id, uint64 quantity) public  {
965     
966     uint256[4] memory log_data_mem;
967     assembly {
968       {
969         let locked_features := sload(security_locked_features_slot)
970         if and(locked_features, 0x20) {
971           mstore(32, 0)
972           revert(63, 1)
973         }
974       }
975       {
976         let exchange_count := sload(exchange_count_slot)
977         if iszero(lt(exchange_id, exchange_count)) {
978           mstore(32, 1)
979           revert(63, 1)
980         }
981       }
982       {
983         let asset_count := sload(asset_count_slot)
984         if iszero(lt(asset_id, asset_count)) {
985           mstore(32, 2)
986           revert(63, 1)
987         }
988       }
989       if iszero(quantity) {
990         stop()
991       }
992       let asset_ptr := add(assets_slot, mul(2, asset_id))
993       let unit_scale := and(sload(asset_ptr), 0xffffffffffffffffffffffffffffffffffffffffffffffff)
994       let scaled_quantity := mul(quantity, unit_scale)
995       let user_ptr := add(users_slot, mul(237684487561239756867226304516, user_id))
996       {
997         let withdraw_address := sload(add(user_ptr, 1))
998         if iszero(eq(caller, withdraw_address)) {
999           mstore(32, 3)
1000           revert(63, 1)
1001         }
1002       }
1003       let user_balance_ptr := add(add(user_ptr, 4), asset_id)
1004       let user_balance := sload(user_balance_ptr)
1005       if lt(user_balance, scaled_quantity) {
1006         mstore(32, 4)
1007         revert(63, 1)
1008       }
1009       let session_balance_ptr := add(add(add(add(user_ptr, 4294967300), mul(55340232225423622146, exchange_id)), 2), asset_id)
1010       let session_balance_0 := sload(session_balance_ptr)
1011       let updated_exchange_balance := add(and(session_balance_0, 0xffffffffffffffff), quantity)
1012       if gt(updated_exchange_balance, 0xFFFFFFFFFFFFFFFF) {
1013         mstore(32, 5)
1014         revert(63, 1)
1015       }
1016       let updated_total_deposit := add(and(div(session_balance_0, 0x100000000000000000000000000000000), 0xffffffffffffffffffffffffffffffff), quantity)
1017       sstore(user_balance_ptr, sub(user_balance, scaled_quantity))
1018       sstore(session_balance_ptr, or(and(0xffffffffffffffff0000000000000000, session_balance_0), or(
1019         /* total_deposit */ mul(updated_total_deposit, 0x100000000000000000000000000000000), 
1020         /* asset_balance */ updated_exchange_balance)))
1021       
1022       /* Log event: ExchangeDeposit */
1023       mstore(log_data_mem, user_id)
1024       mstore(add(log_data_mem, 32), exchange_id)
1025       mstore(add(log_data_mem, 64), asset_id)
1026       log1(log_data_mem, 96, /* ExchangeDeposit */ 0x7a2923ebfa019dc20de0ae2be0c8639b07e068b143e98ed7f7a74dc4d4f5ab45)
1027     }
1028   }
1029   
1030   function transfer_from_session(uint64 user_id, uint32 exchange_id, uint32 asset_id, uint64 quantity) public  {
1031     
1032     uint256[4] memory log_data_mem;
1033     assembly {
1034       if iszero(quantity) {
1035         stop()
1036       }
1037       {
1038         let exchange_count := sload(exchange_count_slot)
1039         if iszero(lt(exchange_id, exchange_count)) {
1040           mstore(32, 1)
1041           revert(63, 1)
1042         }
1043       }
1044       {
1045         let asset_count := sload(asset_count_slot)
1046         if iszero(lt(asset_id, asset_count)) {
1047           mstore(32, 2)
1048           revert(63, 1)
1049         }
1050       }
1051       let user_ptr := add(users_slot, mul(237684487561239756867226304516, user_id))
1052       {
1053         let trade_address := sload(add(user_ptr, 0))
1054         if iszero(eq(caller, trade_address)) {
1055           mstore(32, 3)
1056           revert(63, 1)
1057         }
1058       }
1059       let session_ptr := add(add(user_ptr, 4294967300), mul(55340232225423622146, exchange_id))
1060       {
1061         let session_0 := sload(session_ptr)
1062         let unlock_at := session_0
1063         if gt(unlock_at, timestamp) {
1064           mstore(32, 4)
1065           revert(63, 1)
1066         }
1067       }
1068       let session_balance_ptr := add(add(session_ptr, 2), asset_id)
1069       let session_balance_0 := sload(session_balance_ptr)
1070       let session_balance := and(session_balance_0, 0xffffffffffffffff)
1071       if gt(quantity, session_balance) {
1072         mstore(32, 5)
1073         revert(63, 1)
1074       }
1075       let updated_exchange_balance := sub(session_balance, quantity)
1076       let unsettled_withdraw_total := and(div(session_balance_0, 0x10000000000000000), 0xffffffffffffffff)
1077       if lt(updated_exchange_balance, unsettled_withdraw_total) {
1078         mstore(32, 6)
1079         revert(63, 1)
1080       }
1081       sstore(session_balance_ptr, or(and(0xffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000, session_balance_0), 
1082         /* asset_balance */ updated_exchange_balance))
1083       let asset_ptr := add(assets_slot, mul(2, asset_id))
1084       let unit_scale := and(sload(asset_ptr), 0xffffffffffffffffffffffffffffffffffffffffffffffff)
1085       let scaled_quantity := mul(quantity, unit_scale)
1086       let user_balance_ptr := add(add(user_ptr, 4), asset_id)
1087       let user_balance := sload(user_balance_ptr)
1088       let updated_user_balance := add(user_balance, scaled_quantity)
1089       if lt(updated_user_balance, user_balance) {
1090         mstore(32, 7)
1091         revert(63, 1)
1092       }
1093       sstore(user_balance_ptr, updated_user_balance)
1094     }
1095   }
1096   
1097   function user_deposit_to_session(uint64 user_id, uint32 exchange_id, uint32 asset_id, uint64 quantity) public  {
1098     
1099     uint256[4] memory transfer_in_mem;
1100     
1101     uint256[1] memory transfer_out_mem;
1102     
1103     uint256[3] memory log_data_mem;
1104     assembly {
1105       {
1106         let locked_features := sload(security_locked_features_slot)
1107         if and(locked_features, 0x40) {
1108           mstore(32, 0)
1109           revert(63, 1)
1110         }
1111       }
1112       {
1113         let exchange_count := sload(exchange_count_slot)
1114         if iszero(lt(exchange_id, exchange_count)) {
1115           mstore(32, 1)
1116           revert(63, 1)
1117         }
1118       }
1119       {
1120         let asset_count := sload(asset_count_slot)
1121         if iszero(lt(asset_id, asset_count)) {
1122           mstore(32, 2)
1123           revert(63, 1)
1124         }
1125       }
1126       if iszero(quantity) {
1127         stop()
1128       }
1129       let session_balance_ptr := add(add(add(add(add(users_slot, mul(237684487561239756867226304516, user_id)), 4294967300), mul(55340232225423622146, exchange_id)), 2), asset_id)
1130       let session_balance_0 := sload(session_balance_ptr)
1131       let updated_exchange_balance := add(and(session_balance_0, 0xffffffffffffffff), quantity)
1132       if gt(updated_exchange_balance, 0xFFFFFFFFFFFFFFFF) {
1133         mstore(32, 3)
1134         revert(63, 1)
1135       }
1136       let asset_ptr := add(assets_slot, mul(2, asset_id))
1137       let unit_scale := and(sload(asset_ptr), 0xffffffffffffffffffffffffffffffffffffffffffffffff)
1138       let asset_address := sload(add(asset_ptr, 1))
1139       let scaled_quantity := mul(quantity, unit_scale)
1140       let updated_total_deposit := add(and(div(session_balance_0, 0x100000000000000000000000000000000), 0xffffffffffffffffffffffffffffffff), quantity)
1141       sstore(session_balance_ptr, or(and(0xffffffffffffffff0000000000000000, session_balance_0), or(
1142         /* total_deposit */ mul(updated_total_deposit, 0x100000000000000000000000000000000), 
1143         /* asset_balance */ updated_exchange_balance)))
1144       mstore(transfer_in_mem, /* fn_hash("transferFrom(address,address,uint256)") */ 0x23b872dd00000000000000000000000000000000000000000000000000000000)
1145       mstore(add(transfer_in_mem, 4), caller)
1146       mstore(add(transfer_in_mem, 36), address)
1147       mstore(add(transfer_in_mem, 68), scaled_quantity)
1148       {
1149         let success := call(gas, asset_address, 0, transfer_in_mem, 100, transfer_out_mem, 32)
1150         if iszero(success) {
1151           mstore(32, 4)
1152           revert(63, 1)
1153         }
1154         switch returndatasize
1155           case 0 {}
1156           case 32 {
1157             let result := mload(transfer_out_mem)
1158             if iszero(result) {
1159               mstore(32, 5)
1160               revert(63, 1)
1161             }
1162           }
1163           default {
1164             mstore(32, 5)
1165             revert(63, 1)
1166           }
1167       }
1168       
1169       /* Log event: ExchangeDeposit */
1170       mstore(log_data_mem, user_id)
1171       mstore(add(log_data_mem, 32), exchange_id)
1172       mstore(add(log_data_mem, 64), asset_id)
1173       log1(log_data_mem, 96, /* ExchangeDeposit */ 0x7a2923ebfa019dc20de0ae2be0c8639b07e068b143e98ed7f7a74dc4d4f5ab45)
1174     }
1175   }
1176   struct UnsettledWithdrawHeader {
1177     uint32 exchange_id;
1178     uint32 asset_id;
1179     uint32 user_count;
1180   }
1181   struct UnsettledWithdrawUser {
1182     uint64 user_id;
1183   }
1184   
1185   function recover_unsettled_withdraws(bytes memory data) public  {
1186     assembly {
1187       {
1188         let locked_features := sload(security_locked_features_slot)
1189         if and(locked_features, 0x800) {
1190           mstore(32, 0)
1191           revert(63, 1)
1192         }
1193       }
1194       let data_len := mload(data)
1195       let cursor := add(data, 32)
1196       let cursor_end := add(cursor, data_len)
1197       for {} lt(cursor, cursor_end) {} {
1198         let unsettled_withdraw_header_0 := mload(cursor)
1199         let exchange_id := and(div(unsettled_withdraw_header_0, 0x100000000000000000000000000000000000000000000000000000000), 0xffffffff)
1200         let asset_id := and(div(unsettled_withdraw_header_0, 0x1000000000000000000000000000000000000000000000000), 0xffffffff)
1201         let user_count := and(div(unsettled_withdraw_header_0, 0x10000000000000000000000000000000000000000), 0xffffffff)
1202         let group_end := add(cursor, add(12, mul(user_count, 8)))
1203         if gt(group_end, cursor_end) {
1204           mstore(32, 1)
1205           revert(63, 1)
1206         }
1207         let exchange_balance_ptr := add(add(add(exchanges_slot, mul(4294967300, exchange_id)), 4), asset_id)
1208         let exchange_balance := sload(exchange_balance_ptr)
1209         let start_exchange_balance := exchange_balance
1210         for {} lt(cursor, group_end) {
1211           cursor := add(cursor, 8)
1212         } {
1213           let user_id := and(div(mload(cursor), 0x1000000000000000000000000000000000000000000000000), 0xffffffffffffffff)
1214           let session_balance_ptr := add(add(add(add(add(users_slot, mul(237684487561239756867226304516, user_id)), 4294967300), mul(55340232225423622146, exchange_id)), 2), asset_id)
1215           let session_balance_0 := sload(session_balance_ptr)
1216           let asset_balance := and(session_balance_0, 0xffffffffffffffff)
1217           let unsettled_balance := and(div(session_balance_0, 0x10000000000000000), 0xffffffffffffffff)
1218           let to_recover := unsettled_balance
1219           if gt(to_recover, asset_balance) {
1220             to_recover := asset_balance
1221           }
1222           if to_recover {
1223             exchange_balance := add(exchange_balance, to_recover)
1224             asset_balance := sub(asset_balance, to_recover)
1225             unsettled_balance := sub(unsettled_balance, to_recover)
1226             if gt(start_exchange_balance, exchange_balance) {
1227               mstore(32, 2)
1228               revert(63, 1)
1229             }
1230             sstore(session_balance_ptr, or(and(0xffffffffffffffffffffffffffffffff00000000000000000000000000000000, session_balance_0), or(
1231               /* unsettled_withdraw_total */ mul(unsettled_balance, 0x10000000000000000), 
1232               /* asset_balance */ asset_balance)))
1233           }
1234         }
1235         sstore(exchange_balance_ptr, exchange_balance)
1236       }
1237     }
1238   }
1239   struct ExchangeTransfersHeader {
1240     uint32 exchange_id;
1241   }
1242   struct ExchangeTransferGroup {
1243     uint32 asset_id;
1244     uint8 allow_overdraft;
1245     uint8 transfer_count;
1246   }
1247   struct ExchangeTransfer {
1248     uint64 user_id;
1249     uint64 quantity;
1250   }
1251   
1252   function exchange_transfer_from(bytes memory data) public  {
1253     assembly {
1254       {
1255         let locked_features := sload(security_locked_features_slot)
1256         if and(locked_features, 0x80) {
1257           mstore(32, 0)
1258           revert(63, 1)
1259         }
1260       }
1261       let data_len := mload(data)
1262       let cursor := add(data, 32)
1263       let cursor_end := add(cursor, data_len)
1264       let header_0 := mload(cursor)
1265       cursor := add(cursor, 4)
1266       if gt(cursor, cursor_end) {
1267         mstore(32, 1)
1268         revert(63, 1)
1269       }
1270       let exchange_id := and(div(header_0, 0x100000000000000000000000000000000000000000000000000000000), 0xffffffff)
1271       {
1272         let exchange_count := sload(exchange_count_slot)
1273         if iszero(lt(exchange_id, exchange_count)) {
1274           mstore(32, 2)
1275           revert(63, 1)
1276         }
1277       }
1278       {
1279         let exchange_data := sload(add(exchanges_slot, mul(4294967300, exchange_id)))
1280         if iszero(eq(caller, and(exchange_data, 0xffffffffffffffffffffffffffffffffffffffff))) {
1281           mstore(32, 3)
1282           revert(63, 1)
1283         }
1284         if and(div(exchange_data, 0x10000000000000000000000000000000000000000), 0xff) {
1285           mstore(32, 4)
1286           revert(63, 1)
1287         }
1288       }
1289       let asset_count := sload(asset_count_slot)
1290       for {} lt(cursor, cursor_end) {} {
1291         let group_0 := mload(cursor)
1292         cursor := add(cursor, 6)
1293         if gt(cursor, cursor_end) {
1294           mstore(32, 5)
1295           revert(63, 1)
1296         }
1297         let asset_id := and(div(group_0, 0x100000000000000000000000000000000000000000000000000000000), 0xffffffff)
1298         if iszero(lt(asset_id, asset_count)) {
1299           mstore(32, 6)
1300           revert(63, 1)
1301         }
1302         let disallow_overdraft := iszero(and(div(group_0, 0x1000000000000000000000000000000000000000000000000000000), 0xff))
1303         let cursor_group_end := add(cursor, mul(and(div(group_0, 0x10000000000000000000000000000000000000000000000000000), 0xff), 16))
1304         if gt(cursor_group_end, cursor_end) {
1305           mstore(32, 7)
1306           revert(63, 1)
1307         }
1308         let exchange_balance_ptr := add(add(add(exchanges_slot, mul(4294967300, exchange_id)), 4), asset_id)
1309         let exchange_balance_remaining := sload(exchange_balance_ptr)
1310         let unit_scale := and(sload(add(assets_slot, mul(2, asset_id))), 0xffffffffffffffffffffffffffffffffffffffffffffffff)
1311         for {} lt(cursor, cursor_group_end) {
1312           cursor := add(cursor, 16)
1313         } {
1314           let transfer_0 := mload(cursor)
1315           let user_ptr := add(users_slot, mul(237684487561239756867226304516, and(div(transfer_0, 0x1000000000000000000000000000000000000000000000000), 0xffffffffffffffff)))
1316           let quantity := and(div(transfer_0, 0x100000000000000000000000000000000), 0xffffffffffffffff)
1317           let exchange_balance_used := 0
1318           let session_balance_ptr := add(add(add(add(user_ptr, 4294967300), mul(55340232225423622146, exchange_id)), 2), asset_id)
1319           let session_balance_0 := sload(session_balance_ptr)
1320           let session_balance := and(session_balance_0, 0xffffffffffffffff)
1321           let session_balance_updated := sub(session_balance, quantity)
1322           if gt(session_balance_updated, session_balance) {
1323             if disallow_overdraft {
1324               mstore(32, 8)
1325               revert(63, 1)
1326             }
1327             exchange_balance_used := sub(quantity, session_balance)
1328             session_balance_updated := 0
1329             if gt(exchange_balance_used, exchange_balance_remaining) {
1330               mstore(32, 9)
1331               revert(63, 1)
1332             }
1333             exchange_balance_remaining := sub(exchange_balance_remaining, exchange_balance_used)
1334           }
1335           let quantity_scaled := mul(quantity, unit_scale)
1336           let user_balance_ptr := add(add(user_ptr, 4), asset_id)
1337           let user_balance := sload(user_balance_ptr)
1338           let updated_user_balance := add(user_balance, quantity_scaled)
1339           if gt(user_balance, updated_user_balance) {
1340             mstore(32, 10)
1341             revert(63, 1)
1342           }
1343           let unsettled_withdraw_total_updated := add(and(div(session_balance_0, 0x10000000000000000), 0xffffffffffffffff), exchange_balance_used)
1344           if gt(unsettled_withdraw_total_updated, 0xFFFFFFFFFFFFFFFF) {
1345             mstore(32, 11)
1346             revert(63, 1)
1347           }
1348           sstore(session_balance_ptr, or(and(0xffffffffffffffffffffffffffffffff00000000000000000000000000000000, session_balance_0), or(
1349             /* unsettled_withdraw_total */ mul(unsettled_withdraw_total_updated, 0x10000000000000000), 
1350             /* asset_balance */ session_balance_updated)))
1351           sstore(user_balance_ptr, updated_user_balance)
1352         }
1353         sstore(exchange_balance_ptr, exchange_balance_remaining)
1354       }
1355     }
1356   }
1357   struct SetLimitsHeader {
1358     uint32 exchange_id;
1359   }
1360   struct Signature {
1361     uint256 sig_r;
1362     uint256 sig_s;
1363     uint8 sig_v;
1364   }
1365   struct UpdateLimit {
1366     uint32 dcn_id;
1367     uint64 user_id;
1368     uint32 exchange_id;
1369     uint32 quote_asset_id;
1370     uint32 base_asset_id;
1371     uint64 fee_limit;
1372     int64 min_quote_qty;
1373     int64 min_base_qty;
1374     uint64 long_max_price;
1375     uint64 short_min_price;
1376     uint64 limit_version;
1377     uint96 quote_shift;
1378     uint96 base_shift;
1379   }
1380   struct SetLimitMemory {
1381     uint256 user_id;
1382     uint256 exchange_id;
1383     uint256 quote_asset_id;
1384     uint256 base_asset_id;
1385     uint256 limit_version;
1386     uint256 quote_shift;
1387     uint256 base_shift;
1388   }
1389   
1390   function exchange_set_limits(bytes memory data) public  {
1391     
1392     uint256[14] memory to_hash_mem;
1393     uint256 cursor;
1394     uint256 cursor_end;
1395     uint256 exchange_id;
1396     
1397     uint256[224] memory set_limit_memory_space;
1398     assembly {
1399       {
1400         let locked_features := sload(security_locked_features_slot)
1401         if and(locked_features, 0x100) {
1402           mstore(32, 0)
1403           revert(63, 1)
1404         }
1405       }
1406       let data_size := mload(data)
1407       cursor := add(data, 32)
1408       cursor_end := add(cursor, data_size)
1409       let set_limits_header_0 := mload(cursor)
1410       cursor := add(cursor, 4)
1411       if gt(cursor, cursor_end) {
1412         mstore(32, 1)
1413         revert(63, 1)
1414       }
1415       exchange_id := and(div(set_limits_header_0, 0x100000000000000000000000000000000000000000000000000000000), 0xffffffff)
1416       let exchange_0 := sload(add(exchanges_slot, mul(4294967300, exchange_id)))
1417       let exchange_owner := and(exchange_0, 0xffffffffffffffffffffffffffffffffffffffff)
1418       if iszero(eq(caller, exchange_owner)) {
1419         mstore(32, 2)
1420         revert(63, 1)
1421       }
1422       if and(div(exchange_0, 0x10000000000000000000000000000000000000000), 0xff) {
1423         mstore(32, 3)
1424         revert(63, 1)
1425       }
1426     }
1427     while (true)
1428     {
1429         uint256 update_limit_0;
1430         uint256 update_limit_1;
1431         uint256 update_limit_2;
1432         bytes32 limit_hash;
1433         assembly {
1434           if eq(cursor, cursor_end) {
1435             return(0, 0)
1436           }
1437           update_limit_0 := mload(cursor)
1438           update_limit_1 := mload(add(cursor, 32))
1439           update_limit_2 := mload(add(cursor, 64))
1440           cursor := add(cursor, 96)
1441           if gt(cursor, cursor_end) {
1442             mstore(32, 4)
1443             revert(63, 1)
1444           }
1445           {
1446             mstore(to_hash_mem, 0xbe6b685e53075dd48bdabc4949b848400d5a7e53705df48e04ace664c3946ad2)
1447             let temp_var := 0
1448             temp_var := and(div(update_limit_0, 0x100000000000000000000000000000000000000000000000000000000), 0xffffffff)
1449             mstore(add(to_hash_mem, 32), temp_var)
1450             temp_var := and(div(update_limit_0, 0x10000000000000000000000000000000000000000), 0xffffffffffffffff)
1451             mstore(add(to_hash_mem, 64), temp_var)
1452             mstore(add(set_limit_memory_space, 0), temp_var)
1453             temp_var := and(div(update_limit_0, 0x100000000000000000000000000000000), 0xffffffff)
1454             mstore(add(to_hash_mem, 96), temp_var)
1455             temp_var := and(div(update_limit_0, 0x1000000000000000000000000), 0xffffffff)
1456             mstore(add(to_hash_mem, 128), temp_var)
1457             mstore(add(set_limit_memory_space, 64), temp_var)
1458             temp_var := and(div(update_limit_0, 0x10000000000000000), 0xffffffff)
1459             mstore(add(to_hash_mem, 160), temp_var)
1460             mstore(add(set_limit_memory_space, 96), temp_var)
1461             temp_var := and(update_limit_0, 0xffffffffffffffff)
1462             mstore(add(to_hash_mem, 192), temp_var)
1463             temp_var := and(div(update_limit_1, 0x1000000000000000000000000000000000000000000000000), 0xffffffffffffffff)
1464             temp_var := signextend(7, temp_var)
1465             mstore(add(to_hash_mem, 224), temp_var)
1466             temp_var := and(div(update_limit_1, 0x100000000000000000000000000000000), 0xffffffffffffffff)
1467             temp_var := signextend(7, temp_var)
1468             mstore(add(to_hash_mem, 256), temp_var)
1469             temp_var := and(div(update_limit_1, 0x10000000000000000), 0xffffffffffffffff)
1470             mstore(add(to_hash_mem, 288), temp_var)
1471             temp_var := and(update_limit_1, 0xffffffffffffffff)
1472             mstore(add(to_hash_mem, 320), temp_var)
1473             temp_var := and(div(update_limit_2, 0x1000000000000000000000000000000000000000000000000), 0xffffffffffffffff)
1474             mstore(add(to_hash_mem, 352), temp_var)
1475             mstore(add(set_limit_memory_space, 128), temp_var)
1476             temp_var := and(div(update_limit_2, 0x1000000000000000000000000), 0xffffffffffffffffffffffff)
1477             temp_var := signextend(11, temp_var)
1478             mstore(add(to_hash_mem, 384), temp_var)
1479             mstore(add(set_limit_memory_space, 160), temp_var)
1480             temp_var := and(update_limit_2, 0xffffffffffffffffffffffff)
1481             temp_var := signextend(11, temp_var)
1482             mstore(add(to_hash_mem, 416), temp_var)
1483             mstore(add(set_limit_memory_space, 192), temp_var)
1484           }
1485           limit_hash := keccak256(to_hash_mem, 448)
1486           mstore(to_hash_mem, 0x1901000000000000000000000000000000000000000000000000000000000000)
1487           mstore(add(to_hash_mem, 2), 0xe3d3073cc59e3a3126c17585a7e516a048e61a9a1c82144af982d1c194b18710)
1488           mstore(add(to_hash_mem, 34), limit_hash)
1489           limit_hash := keccak256(to_hash_mem, 66)
1490         }
1491         {
1492           bytes32 sig_r;
1493           bytes32 sig_s;
1494           uint8 sig_v;
1495           assembly {
1496             sig_r := mload(cursor)
1497             sig_s := mload(add(cursor, 32))
1498             sig_v := and(div(mload(add(cursor, 64)), 0x100000000000000000000000000000000000000000000000000000000000000), 0xff)
1499             cursor := add(cursor, 65)
1500             if gt(cursor, cursor_end) {
1501               mstore(32, 5)
1502               revert(63, 1)
1503             }
1504           }
1505           uint256 recovered_address = uint256(ecrecover(
1506                      limit_hash,
1507                   sig_v,
1508                   sig_r,
1509                   sig_s
1510         ));
1511           assembly {
1512             let user_ptr := add(users_slot, mul(237684487561239756867226304516, mload(add(set_limit_memory_space, 0))))
1513             let session_ptr := add(add(user_ptr, 4294967300), mul(55340232225423622146, exchange_id))
1514             let trade_address := sload(add(session_ptr, 1))
1515             if iszero(eq(recovered_address, trade_address)) {
1516               mstore(32, 6)
1517               revert(63, 1)
1518             }
1519           }
1520         }
1521         assembly {
1522           {
1523             if iszero(eq(mload(add(set_limit_memory_space, 32)), exchange_id)) {
1524               mstore(32, 7)
1525               revert(63, 1)
1526             }
1527           }
1528           let user_ptr := add(users_slot, mul(237684487561239756867226304516, mload(add(set_limit_memory_space, 0))))
1529           let session_ptr := add(add(user_ptr, 4294967300), mul(55340232225423622146, exchange_id))
1530           let market_state_ptr := add(add(session_ptr, 4294967298), mul(3, or(mul(mload(add(set_limit_memory_space, 64)), 4294967296), mload(add(set_limit_memory_space, 96)))))
1531           let market_state_0 := sload(market_state_ptr)
1532           let market_state_1 := sload(add(market_state_ptr, 1))
1533           let market_state_2 := sload(add(market_state_ptr, 2))
1534           {
1535             let current_limit_version := and(div(market_state_2, 0x1000000000000000000000000000000000000000000000000), 0xffffffffffffffff)
1536             if iszero(gt(mload(add(set_limit_memory_space, 128)), current_limit_version)) {
1537               mstore(32, 8)
1538               revert(63, 1)
1539             }
1540           }
1541           let quote_qty := and(div(market_state_0, 0x1000000000000000000000000000000000000000000000000), 0xffffffffffffffff)
1542           quote_qty := signextend(7, quote_qty)
1543           let base_qty := and(div(market_state_0, 0x100000000000000000000000000000000), 0xffffffffffffffff)
1544           base_qty := signextend(7, base_qty)
1545           {
1546             let current_shift := and(div(market_state_2, 0x1000000000000000000000000), 0xffffffffffffffffffffffff)
1547             current_shift := signextend(11, current_shift)
1548             let new_shift := mload(add(set_limit_memory_space, 160))
1549             quote_qty := add(quote_qty, sub(new_shift, current_shift))
1550             if or(slt(quote_qty, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8000000000000000), sgt(quote_qty, 0x7FFFFFFFFFFFFFFF)) {
1551               mstore(32, 9)
1552               revert(63, 1)
1553             }
1554           }
1555           {
1556             let current_shift := and(market_state_2, 0xffffffffffffffffffffffff)
1557             current_shift := signextend(11, current_shift)
1558             let new_shift := mload(add(set_limit_memory_space, 192))
1559             base_qty := add(base_qty, sub(new_shift, current_shift))
1560             if or(slt(base_qty, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8000000000000000), sgt(base_qty, 0x7FFFFFFFFFFFFFFF)) {
1561               mstore(32, 10)
1562               revert(63, 1)
1563             }
1564           }
1565           let new_market_state_0 := or(or(or(
1566             /* quote_qty */ mul(and(quote_qty, 0xffffffffffffffff), 0x1000000000000000000000000000000000000000000000000), 
1567             /* base_qty */ mul(and(base_qty, 0xffffffffffffffff), 0x100000000000000000000000000000000)), 
1568             /* fee_limit */ and(update_limit_0, 0xffffffffffffffff)), and(0xffffffffffffffff0000000000000000, market_state_0))
1569           sstore(market_state_ptr, new_market_state_0)
1570           sstore(add(market_state_ptr, 1), update_limit_1)
1571           sstore(add(market_state_ptr, 2), update_limit_2)
1572         }
1573       }
1574   }
1575   struct ExchangeId {
1576     uint32 exchange_id;
1577   }
1578   struct GroupHeader {
1579     uint32 quote_asset_id;
1580     uint32 base_asset_id;
1581     uint8 user_count;
1582   }
1583   struct Settlement {
1584     uint64 user_id;
1585     int64 quote_delta;
1586     int64 base_delta;
1587     uint64 fees;
1588   }
1589   
1590   function exchange_apply_settlement_groups(bytes memory data) public  {
1591     
1592     uint256[6] memory variables;
1593     assembly {
1594       {
1595         let locked_features := sload(security_locked_features_slot)
1596         if and(locked_features, 0x200) {
1597           mstore(32, 0)
1598           revert(63, 1)
1599         }
1600       }
1601       let data_len := mload(data)
1602       let cursor := add(data, 32)
1603       let cursor_end := add(cursor, data_len)
1604       let exchange_id_0 := mload(cursor)
1605       cursor := add(cursor, 4)
1606       if gt(cursor, cursor_end) {
1607         mstore(32, 1)
1608         revert(63, 1)
1609       }
1610       let exchange_id := and(div(exchange_id_0, 0x100000000000000000000000000000000000000000000000000000000), 0xffffffff)
1611       {
1612         let exchange_count := sload(exchange_count_slot)
1613         if iszero(lt(exchange_id, exchange_count)) {
1614           mstore(32, 2)
1615           revert(63, 1)
1616         }
1617       }
1618       {
1619         let exchange_ptr := add(exchanges_slot, mul(4294967300, exchange_id))
1620         let exchange_0 := sload(exchange_ptr)
1621         if iszero(eq(caller, and(exchange_0, 0xffffffffffffffffffffffffffffffffffffffff))) {
1622           mstore(32, 2)
1623           revert(63, 1)
1624         }
1625         if and(div(exchange_0, 0x10000000000000000000000000000000000000000), 0xff) {
1626           mstore(32, 3)
1627           revert(63, 1)
1628         }
1629       }
1630       for {} lt(cursor, cursor_end) {} {
1631         let header_0 := mload(cursor)
1632         cursor := add(cursor, 9)
1633         if gt(cursor, cursor_end) {
1634           mstore(32, 4)
1635           revert(63, 1)
1636         }
1637         let quote_asset_id := and(div(header_0, 0x100000000000000000000000000000000000000000000000000000000), 0xffffffff)
1638         let base_asset_id := and(div(header_0, 0x1000000000000000000000000000000000000000000000000), 0xffffffff)
1639         if eq(quote_asset_id, base_asset_id) {
1640           mstore(32, 16)
1641           revert(63, 1)
1642         }
1643         let group_end := add(cursor, mul(and(div(header_0, 0x10000000000000000000000000000000000000000000000), 0xff), 32))
1644         {
1645           let asset_count := sload(asset_count_slot)
1646           if iszero(and(lt(quote_asset_id, asset_count), lt(base_asset_id, asset_count))) {
1647             mstore(32, 5)
1648             revert(63, 1)
1649           }
1650         }
1651         if gt(group_end, cursor_end) {
1652           mstore(32, 6)
1653           revert(63, 1)
1654         }
1655         let quote_net := 0
1656         let base_net := 0
1657         let exchange_ptr := add(exchanges_slot, mul(4294967300, exchange_id))
1658         let exchange_balance_ptr := add(add(exchange_ptr, 4), quote_asset_id)
1659         let exchange_balance := sload(exchange_balance_ptr)
1660         for {} lt(cursor, group_end) {
1661           cursor := add(cursor, 32)
1662         } {
1663           let settlement_0 := mload(cursor)
1664           let user_ptr := add(users_slot, mul(237684487561239756867226304516, and(div(settlement_0, 0x1000000000000000000000000000000000000000000000000), 0xffffffffffffffff)))
1665           let session_ptr := add(add(user_ptr, 4294967300), mul(55340232225423622146, exchange_id))
1666           let market_state_ptr := add(add(session_ptr, 4294967298), mul(3, or(mul(quote_asset_id, 4294967296), base_asset_id)))
1667           let quote_delta := and(div(settlement_0, 0x100000000000000000000000000000000), 0xffffffffffffffff)
1668           quote_delta := signextend(7, quote_delta)
1669           let base_delta := and(div(settlement_0, 0x10000000000000000), 0xffffffffffffffff)
1670           base_delta := signextend(7, base_delta)
1671           quote_net := add(quote_net, quote_delta)
1672           base_net := add(base_net, base_delta)
1673           let fees := and(settlement_0, 0xffffffffffffffff)
1674           exchange_balance := add(exchange_balance, fees)
1675           let market_state_0 := sload(market_state_ptr)
1676           {
1677             let quote_qty := and(div(market_state_0, 0x1000000000000000000000000000000000000000000000000), 0xffffffffffffffff)
1678             quote_qty := signextend(7, quote_qty)
1679             let base_qty := and(div(market_state_0, 0x100000000000000000000000000000000), 0xffffffffffffffff)
1680             base_qty := signextend(7, base_qty)
1681             quote_qty := add(quote_qty, quote_delta)
1682             base_qty := add(base_qty, base_delta)
1683             if or(or(slt(quote_qty, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8000000000000000), sgt(quote_qty, 0x7FFFFFFFFFFFFFFF)), or(slt(base_qty, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8000000000000000), sgt(base_qty, 0x7FFFFFFFFFFFFFFF))) {
1684               mstore(32, 7)
1685               revert(63, 1)
1686             }
1687             let fee_used := add(and(div(market_state_0, 0x10000000000000000), 0xffffffffffffffff), fees)
1688             let fee_limit := and(market_state_0, 0xffffffffffffffff)
1689             if gt(fee_used, fee_limit) {
1690               mstore(32, 8)
1691               revert(63, 1)
1692             }
1693             market_state_0 := or(or(or(
1694               /* quote_qty */ mul(quote_qty, 0x1000000000000000000000000000000000000000000000000), 
1695               /* base_qty */ mul(and(base_qty, 0xFFFFFFFFFFFFFFFF), 0x100000000000000000000000000000000)), 
1696               /* fee_used */ mul(fee_used, 0x10000000000000000)), 
1697               /* fee_limit */ fee_limit)
1698             let market_state_1 := sload(add(market_state_ptr, 1))
1699             {
1700               let min_quote_qty := and(div(market_state_1, 0x1000000000000000000000000000000000000000000000000), 0xffffffffffffffff)
1701               min_quote_qty := signextend(7, min_quote_qty)
1702               let min_base_qty := and(div(market_state_1, 0x100000000000000000000000000000000), 0xffffffffffffffff)
1703               min_base_qty := signextend(7, min_base_qty)
1704               if or(slt(quote_qty, min_quote_qty), slt(base_qty, min_base_qty)) {
1705                 mstore(32, 9)
1706                 revert(63, 1)
1707               }
1708             }
1709             {
1710               let negatives := add(slt(quote_qty, 1), mul(slt(base_qty, 1), 2))
1711               switch negatives
1712                 case 3 {
1713                   if or(quote_qty, base_qty) {
1714                     mstore(32, 10)
1715                     revert(63, 1)
1716                   }
1717                 }
1718                 case 1 {
1719                   let current_price := div(mul(sub(0, quote_qty), 100000000), base_qty)
1720                   let long_max_price := and(div(market_state_1, 0x10000000000000000), 0xffffffffffffffff)
1721                   if gt(current_price, long_max_price) {
1722                     mstore(32, 11)
1723                     revert(63, 1)
1724                   }
1725                 }
1726                 case 2 {
1727                   if base_qty {
1728                     let current_price := div(mul(quote_qty, 100000000), sub(0, base_qty))
1729                     let short_min_price := and(market_state_1, 0xffffffffffffffff)
1730                     if lt(current_price, short_min_price) {
1731                       mstore(32, 12)
1732                       revert(63, 1)
1733                     }
1734                   }
1735                 }
1736             }
1737           }
1738           let quote_session_balance_ptr := add(add(session_ptr, 2), quote_asset_id)
1739           let base_session_balance_ptr := add(add(session_ptr, 2), base_asset_id)
1740           let quote_session_balance_0 := sload(quote_session_balance_ptr)
1741           let base_session_balance_0 := sload(base_session_balance_ptr)
1742           let quote_balance := and(quote_session_balance_0, 0xffffffffffffffff)
1743           quote_balance := add(quote_balance, quote_delta)
1744           quote_balance := sub(quote_balance, fees)
1745           if gt(quote_balance, 0xFFFFFFFFFFFFFFFF) {
1746             mstore(32, 13)
1747             revert(63, 1)
1748           }
1749           let base_balance := and(base_session_balance_0, 0xffffffffffffffff)
1750           base_balance := add(base_balance, base_delta)
1751           if gt(base_balance, 0xFFFFFFFFFFFFFFFF) {
1752             mstore(32, 14)
1753             revert(63, 1)
1754           }
1755           sstore(market_state_ptr, market_state_0)
1756           sstore(quote_session_balance_ptr, or(and(0xffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000, quote_session_balance_0), 
1757             /* asset_balance */ quote_balance))
1758           sstore(base_session_balance_ptr, or(and(0xffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000, base_session_balance_0), 
1759             /* asset_balance */ base_balance))
1760         }
1761         if or(quote_net, base_net) {
1762           mstore(32, 15)
1763           revert(63, 1)
1764         }
1765         sstore(exchange_balance_ptr, exchange_balance)
1766       }
1767     }
1768   }
1769 }