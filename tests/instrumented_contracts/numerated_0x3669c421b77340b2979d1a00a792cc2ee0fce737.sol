1 # @version 0.3.1
2 
3 """
4 @title Gauge Controller
5 @author Curve Finance
6 @license MIT
7 @notice Controls liquidity gauges and the issuance of coins through the gauges
8 """
9 
10 # ====================================================================
11 # |     ______                   _______                             |
12 # |    / _____________ __  __   / ____(_____  ____ _____  ________   |
13 # |   / /_  / ___/ __ `| |/_/  / /_  / / __ \/ __ `/ __ \/ ___/ _ \  |
14 # |  / __/ / /  / /_/ _>  <   / __/ / / / / / /_/ / / / / /__/  __/  |
15 # | /_/   /_/   \__,_/_/|_|  /_/   /_/_/ /_/\__,_/_/ /_/\___/\___/   |
16 # |                                                                  |
17 # ====================================================================
18 # ======================= FraxGaugeControllerV2 ======================
19 # ====================================================================
20 # Frax Finance: https://github.com/FraxFinance
21 
22 # Original idea and credit:
23 # Curve Finance's Gauge Controller
24 # https://resources.curve.fi/base-features/understanding-gauges
25 # https://github.com/curvefi/curve-dao-contracts/blob/master/contracts/GaugeController.vy
26 # This contract is an almost-identical fork of Curve's contract
27 # veFXS is used instead of veCRV. 
28 
29 # Frax Reviewer(s) / Contributor(s)
30 # Travis Moore: https://github.com/FortisFortuna
31 # Jason Huan: https://github.com/jasonhuan
32 # Sam Kazemian: https://github.com/samkazemian
33 
34 
35 # 7 * 86400 seconds - all future times are rounded by week
36 WEEK: constant(uint256) = 604800
37 
38 # Cannot change weight votes more often than once in 10 days
39 WEIGHT_VOTE_DELAY: constant(uint256) = 10 * 86400
40 
41 
42 struct Point:
43     bias: uint256
44     slope: uint256
45 
46 struct CorrectedPoint:
47     bias: uint256
48     slope: uint256
49     lock_end: uint256
50     fxs_amount: uint256
51 
52 struct VotedSlope:
53     slope: uint256
54     power: uint256
55     end: uint256
56 
57 struct LockedBalance:
58     amount: int128
59     end: uint256
60 
61 interface VotingEscrow:
62     def balanceOf(addr: address,) -> uint256: view
63     def get_last_user_slope(addr: address) -> int128: view
64     def locked__end(addr: address) -> uint256: view
65     def locked(addr: address,) -> LockedBalance: view
66 
67 
68 event CommitOwnership:
69     admin: address
70 
71 event ApplyOwnership:
72     admin: address
73 
74 event AddType:
75     name: String[64]
76     type_id: int128
77 
78 event NewTypeWeight:
79     type_id: int128
80     time: uint256
81     weight: uint256
82     total_weight: uint256
83 
84 event NewGaugeWeight:
85     gauge_address: address
86     time: uint256
87     weight: uint256
88     total_weight: uint256
89 
90 event VoteForGauge:
91     time: uint256
92     user: address
93     gauge_addr: address
94     weight: uint256
95 
96 event NewGauge:
97     addr: address
98     gauge_type: int128
99     weight: uint256
100 
101 
102 MULTIPLIER: constant(uint256) = 10 ** 18
103 
104 admin: public(address)  # Can and will be a smart contract
105 future_admin: public(address)  # Can and will be a smart contract
106 
107 token: public(address)  # CRV token
108 voting_escrow: public(address)  # Voting escrow
109 
110 # Gauge parameters
111 # All numbers are "fixed point" on the basis of 1e18
112 n_gauge_types: public(int128)
113 n_gauges: public(int128)
114 gauge_type_names: public(HashMap[int128, String[64]])
115 
116 # Needed for enumeration
117 gauges: public(address[1000000000])
118 
119 # we increment values by 1 prior to storing them here so we can rely on a value
120 # of zero as meaning the gauge has not been set
121 gauge_types_: HashMap[address, int128]
122 
123 vote_user_slopes: public(HashMap[address, HashMap[address, VotedSlope]])  # user -> gauge_addr -> VotedSlope
124 vote_user_power: public(HashMap[address, uint256])  # Total vote power used by user
125 last_user_vote: public(HashMap[address, HashMap[address, uint256]])  # Last user vote's timestamp for each gauge address
126 
127 # Past and scheduled points for gauge weight, sum of weights per type, total weight
128 # Point is for bias+slope
129 # changes_* are for changes in slope
130 # time_* are for the last change timestamp
131 # timestamps are rounded to whole weeks
132 
133 points_weight: public(HashMap[address, HashMap[uint256, Point]])  # gauge_addr -> time -> Point
134 changes_weight: HashMap[address, HashMap[uint256, uint256]]  # gauge_addr -> time -> slope
135 time_weight: public(HashMap[address, uint256])  # gauge_addr -> last scheduled time (next week)
136 
137 points_sum: public(HashMap[int128, HashMap[uint256, Point]])  # type_id -> time -> Point
138 changes_sum: HashMap[int128, HashMap[uint256, uint256]]  # type_id -> time -> slope
139 time_sum: public(uint256[1000000000])  # type_id -> last scheduled time (next week)
140 
141 points_total: public(HashMap[uint256, uint256])  # time -> total weight
142 time_total: public(uint256)  # last scheduled time
143 
144 points_type_weight: public(HashMap[int128, HashMap[uint256, uint256]])  # type_id -> time -> type weight
145 time_type_weight: public(uint256[1000000000])  # type_id -> last scheduled time (next week)
146 
147 global_emission_rate: public(uint256)  # inflation rate
148 
149 @external
150 def __init__(_token: address, _voting_escrow: address):
151     """
152     @notice Contract constructor
153     @param _token `ERC-20 FXS` contract address
154     @param _voting_escrow `VotingEscrow` contract address
155     """
156     assert _token != ZERO_ADDRESS
157     assert _voting_escrow != ZERO_ADDRESS
158 
159     self.admin = msg.sender
160     self.token = _token
161     self.voting_escrow = _voting_escrow
162     self.time_total = block.timestamp / WEEK * WEEK
163 
164 
165 @external
166 def commit_transfer_ownership(addr: address):
167     """
168     @notice Transfer ownership of GaugeController to `addr`
169     @param addr Address to have ownership transferred to
170     """
171     assert msg.sender == self.admin  # dev: admin only
172     self.future_admin = addr
173     log CommitOwnership(addr)
174 
175 
176 @external
177 def apply_transfer_ownership():
178     """
179     @notice Apply pending ownership transfer
180     """
181     assert msg.sender == self.admin  # dev: admin only
182     _admin: address = self.future_admin
183     assert _admin != ZERO_ADDRESS  # dev: admin not set
184     self.admin = _admin
185     log ApplyOwnership(_admin)
186 
187 @internal
188 @view
189 def _get_corrected_info(addr: address) -> CorrectedPoint:
190     """
191     @notice Get the most recently recorded rate of voting power decrease for `addr`.
192             Corrected by VOTE_WEIGHT_MULTIPLIER (veFXS).
193     @param addr Address of the user wallet
194     @return CorrectedPoint
195     """
196     escrow: address = self.voting_escrow
197     vefxs_balance: uint256 = VotingEscrow(escrow).balanceOf(addr)
198     locked_balance: LockedBalance = VotingEscrow(escrow).locked(addr)
199     locked_end: uint256 = locked_balance.end
200     locked_fxs: uint256 = convert(locked_balance.amount, uint256)
201 
202     corrected_slope: uint256 = 0
203 
204     # Decay to 0. Decaying to 1 veFXS <> 1 FXS gives wrong expected results
205     if (locked_end > block.timestamp):
206         corrected_slope = vefxs_balance / (locked_end - block.timestamp)
207 
208     return CorrectedPoint({bias: vefxs_balance, slope: corrected_slope, lock_end: locked_end, fxs_amount: locked_fxs})
209 
210 @view
211 @external
212 def get_corrected_info(addr: address) -> CorrectedPoint:
213     return self._get_corrected_info(addr)
214 
215 @external
216 @view
217 def gauge_types(_addr: address) -> int128:
218     """
219     @notice Get gauge type for address
220     @param _addr Gauge address
221     @return Gauge type id
222     """
223     gauge_type: int128 = self.gauge_types_[_addr]
224     assert gauge_type != 0
225 
226     return gauge_type - 1
227 
228 
229 @internal
230 def _get_type_weight(gauge_type: int128) -> uint256:
231     """
232     @notice Fill historic type weights week-over-week for missed checkins
233             and return the type weight for the future week
234     @param gauge_type Gauge type id
235     @return Type weight
236     """
237     t: uint256 = self.time_type_weight[gauge_type]
238     if t > 0:
239         w: uint256 = self.points_type_weight[gauge_type][t]
240         for i in range(500):
241             if t > block.timestamp:
242                 break
243             t += WEEK
244             self.points_type_weight[gauge_type][t] = w
245             if t > block.timestamp:
246                 self.time_type_weight[gauge_type] = t
247         return w
248     else:
249         return 0
250 
251 
252 @internal
253 def _get_sum(gauge_type: int128) -> uint256:
254     """
255     @notice Fill sum of gauge weights for the same type week-over-week for
256             missed checkins and return the sum for the future week
257     @param gauge_type Gauge type id
258     @return Sum of weights
259     """
260     t: uint256 = self.time_sum[gauge_type]
261     if t > 0:
262         pt: Point = self.points_sum[gauge_type][t]
263         for i in range(500):
264             if t > block.timestamp:
265                 break
266             t += WEEK
267             d_bias: uint256 = pt.slope * WEEK
268             if pt.bias > d_bias:
269                 pt.bias -= d_bias
270                 d_slope: uint256 = self.changes_sum[gauge_type][t]
271                 pt.slope -= d_slope
272             else:
273                 pt.bias = 0
274                 pt.slope = 0
275             self.points_sum[gauge_type][t] = pt
276             if t > block.timestamp:
277                 self.time_sum[gauge_type] = t
278         return pt.bias
279     else:
280         return 0
281 
282 
283 @internal
284 def _get_total() -> uint256:
285     """
286     @notice Fill historic total weights week-over-week for missed checkins
287             and return the total for the future week
288     @return Total weight
289     """
290     t: uint256 = self.time_total
291     _n_gauge_types: int128 = self.n_gauge_types
292     if t > block.timestamp:
293         # If we have already checkpointed - still need to change the value
294         t -= WEEK
295     pt: uint256 = self.points_total[t]
296 
297     for gauge_type in range(100):
298         if gauge_type == _n_gauge_types:
299             break
300         self._get_sum(gauge_type)
301         self._get_type_weight(gauge_type)
302 
303     for i in range(500):
304         if t > block.timestamp:
305             break
306         t += WEEK
307         pt = 0
308         # Scales as n_types * n_unchecked_weeks (hopefully 1 at most)
309         for gauge_type in range(100):
310             if gauge_type == _n_gauge_types:
311                 break
312             type_sum: uint256 = self.points_sum[gauge_type][t].bias
313             type_weight: uint256 = self.points_type_weight[gauge_type][t]
314             pt += type_sum * type_weight
315         self.points_total[t] = pt
316 
317         if t > block.timestamp:
318             self.time_total = t
319     return pt
320 
321 
322 @internal
323 def _get_weight(gauge_addr: address) -> uint256:
324     """
325     @notice Fill historic gauge weights week-over-week for missed checkins
326             and return the total for the future week
327     @param gauge_addr Address of the gauge
328     @return Gauge weight
329     """
330     t: uint256 = self.time_weight[gauge_addr]
331     if t > 0:
332         pt: Point = self.points_weight[gauge_addr][t]
333         for i in range(500):
334             if t > block.timestamp:
335                 break
336             t += WEEK
337             d_bias: uint256 = pt.slope * WEEK
338             if pt.bias > d_bias:
339                 pt.bias -= d_bias
340                 d_slope: uint256 = self.changes_weight[gauge_addr][t]
341                 pt.slope -= d_slope
342             else:
343                 pt.bias = 0
344                 pt.slope = 0
345             self.points_weight[gauge_addr][t] = pt
346             if t > block.timestamp:
347                 self.time_weight[gauge_addr] = t
348         return pt.bias
349     else:
350         return 0
351 
352 @external
353 def add_gauge(addr: address, gauge_type: int128, weight: uint256):
354     """
355     @notice Add gauge `addr` of type `gauge_type` with weight `weight`
356     @param addr Gauge address
357     @param gauge_type Gauge type
358     @param weight Gauge weight
359     """
360     assert msg.sender == self.admin
361     assert weight >= 0
362     assert (gauge_type >= 0) and (gauge_type < self.n_gauge_types)
363     assert self.gauge_types_[addr] == 0  # dev: cannot add the same gauge twice
364 
365     n: int128 = self.n_gauges
366     self.n_gauges = n + 1
367     self.gauges[n] = addr
368 
369     self.gauge_types_[addr] = gauge_type + 1
370     next_time: uint256 = (block.timestamp + WEEK) / WEEK * WEEK
371 
372     if weight > 0:
373         _type_weight: uint256 = self._get_type_weight(gauge_type)
374         _old_sum: uint256 = self._get_sum(gauge_type)
375         _old_total: uint256 = self._get_total()
376 
377         self.points_sum[gauge_type][next_time].bias = weight + _old_sum
378         self.time_sum[gauge_type] = next_time
379         self.points_total[next_time] = _old_total + _type_weight * weight
380         self.time_total = next_time
381 
382         self.points_weight[addr][next_time].bias = weight
383 
384     if self.time_sum[gauge_type] == 0:
385         self.time_sum[gauge_type] = next_time
386     self.time_weight[addr] = next_time
387 
388     log NewGauge(addr, gauge_type, weight)
389 
390 
391 @external
392 def checkpoint():
393     """
394     @notice Checkpoint to fill data common for all gauges
395     """
396     self._get_total()
397 
398 
399 @external
400 def checkpoint_gauge(addr: address):
401     """
402     @notice Checkpoint to fill data for both a specific gauge and common for all gauges
403     @param addr Gauge address
404     """
405     self._get_weight(addr)
406     self._get_total()
407 
408 
409 @internal
410 @view
411 def _gauge_relative_weight(addr: address, time: uint256) -> uint256:
412     """
413     @notice Get Gauge relative weight (not more than 1.0) normalized to 1e18
414             (e.g. 1.0 == 1e18). Inflation which will be received by it is
415             global_emission_rate * relative_weight / 1e18
416     @param addr Gauge address
417     @param time Relative weight at the specified timestamp in the past or present
418     @return Value of relative weight normalized to 1e18
419     """
420     t: uint256 = time / WEEK * WEEK
421     _total_weight: uint256 = self.points_total[t]
422 
423     if _total_weight > 0:
424         gauge_type: int128 = self.gauge_types_[addr] - 1
425         _type_weight: uint256 = self.points_type_weight[gauge_type][t]
426         _gauge_weight: uint256 = self.points_weight[addr][t].bias
427         return MULTIPLIER * _type_weight * _gauge_weight / _total_weight
428 
429     else:
430         return 0
431 
432 
433 @external
434 @view
435 def gauge_relative_weight(addr: address, time: uint256 = block.timestamp) -> uint256:
436     """
437     @notice Get Gauge relative weight (not more than 1.0) normalized to 1e18
438             (e.g. 1.0 == 1e18). Inflation which will be received by it is
439             global_emission_rate * relative_weight / 1e18
440     @param addr Gauge address
441     @param time Relative weight at the specified timestamp in the past or present
442     @return Value of relative weight normalized to 1e18
443     """
444     return self._gauge_relative_weight(addr, time)
445 
446 
447 @external
448 def gauge_relative_weight_write(addr: address, time: uint256 = block.timestamp) -> uint256:
449     """
450     @notice Get gauge weight normalized to 1e18 and also fill all the unfilled
451             values for type and gauge records
452     @dev Any address can call, however nothing is recorded if the values are filled already
453     @param addr Gauge address
454     @param time Relative weight at the specified timestamp in the past or present
455     @return Value of relative weight normalized to 1e18
456     """
457     self._get_weight(addr)
458     self._get_total()  # Also calculates get_sum
459     return self._gauge_relative_weight(addr, time)
460 
461 
462 @internal
463 def _change_type_weight(type_id: int128, weight: uint256):
464     """
465     @notice Change type weight
466     @param type_id Type id
467     @param weight New type weight
468     """
469     old_weight: uint256 = self._get_type_weight(type_id)
470     old_sum: uint256 = self._get_sum(type_id)
471     _total_weight: uint256 = self._get_total()
472     next_time: uint256 = (block.timestamp + WEEK) / WEEK * WEEK
473 
474     _total_weight = _total_weight + old_sum * weight - old_sum * old_weight
475     self.points_total[next_time] = _total_weight
476     self.points_type_weight[type_id][next_time] = weight
477     self.time_total = next_time
478     self.time_type_weight[type_id] = next_time
479 
480     log NewTypeWeight(type_id, next_time, weight, _total_weight)
481 
482 
483 @external
484 def add_type(_name: String[64], weight: uint256):
485     """
486     @notice Add gauge type with name `_name` and weight `weight`
487     @param _name Name of gauge type
488     @param weight Weight of gauge type
489     """
490     assert msg.sender == self.admin
491     assert weight >= 0
492     type_id: int128 = self.n_gauge_types
493     self.gauge_type_names[type_id] = _name
494     self.n_gauge_types = type_id + 1
495     if weight != 0:
496         self._change_type_weight(type_id, weight)
497         log AddType(_name, type_id)
498 
499 
500 @external
501 def change_type_weight(type_id: int128, weight: uint256):
502     """
503     @notice Change gauge type `type_id` weight to `weight`
504     @param type_id Gauge type id
505     @param weight New Gauge weight
506     """
507     assert msg.sender == self.admin
508     self._change_type_weight(type_id, weight)
509 
510 
511 @internal
512 def _change_gauge_weight(addr: address, weight: uint256):
513     # Change gauge weight
514     # Only needed when testing in reality
515     gauge_type: int128 = self.gauge_types_[addr] - 1
516     old_gauge_weight: uint256 = self._get_weight(addr)
517     type_weight: uint256 = self._get_type_weight(gauge_type)
518     old_sum: uint256 = self._get_sum(gauge_type)
519     _total_weight: uint256 = self._get_total()
520     next_time: uint256 = (block.timestamp + WEEK) / WEEK * WEEK
521 
522     self.points_weight[addr][next_time].bias = weight
523     self.time_weight[addr] = next_time
524 
525     new_sum: uint256 = old_sum + weight - old_gauge_weight
526     self.points_sum[gauge_type][next_time].bias = new_sum
527     self.time_sum[gauge_type] = next_time
528 
529     _total_weight = _total_weight + new_sum * type_weight - old_sum * type_weight
530     self.points_total[next_time] = _total_weight
531     self.time_total = next_time
532 
533     log NewGaugeWeight(addr, block.timestamp, weight, _total_weight)
534 
535 
536 @external
537 def change_gauge_weight(addr: address, weight: uint256):
538     """
539     @notice Change weight of gauge `addr` to `weight`
540     @param addr `GaugeController` contract address
541     @param weight New Gauge weight
542     """
543     assert msg.sender == self.admin
544     self._change_gauge_weight(addr, weight)
545 
546 
547 @external
548 def vote_for_gauge_weights(_gauge_addr: address, _user_weight: uint256):
549     """
550     @notice Allocate voting power for changing pool weights
551     @param _gauge_addr Gauge which `msg.sender` votes for
552     @param _user_weight Weight for a gauge in bps (units of 0.01%). Minimal is 0.01%. Ignored if 0
553     """
554     # escrow: address = self.voting_escrow
555     # slope: uint256 = convert(VotingEscrow(escrow).get_last_user_slope(msg.sender), uint256)
556     # lock_end: uint256 = VotingEscrow(escrow).locked__end(msg.sender)
557 
558     corrected_point: CorrectedPoint = self._get_corrected_info(msg.sender)
559     slope: uint256 = corrected_point.slope
560     lock_end: uint256 = corrected_point.lock_end
561 
562     _n_gauges: int128 = self.n_gauges
563     next_time: uint256 = (block.timestamp + WEEK) / WEEK * WEEK
564     assert lock_end > next_time, "Your token lock expires too soon"
565     assert (_user_weight >= 0) and (_user_weight <= 10000), "You used all your voting power"
566     assert block.timestamp >= self.last_user_vote[msg.sender][_gauge_addr] + WEIGHT_VOTE_DELAY, "Cannot vote so often"
567 
568     gauge_type: int128 = self.gauge_types_[_gauge_addr] - 1
569     assert gauge_type >= 0, "Gauge not added"
570     # Prepare slopes and biases in memory
571     old_slope: VotedSlope = self.vote_user_slopes[msg.sender][_gauge_addr]
572     old_dt: uint256 = 0
573     if old_slope.end > next_time:
574         old_dt = old_slope.end - next_time
575     old_bias: uint256 = old_slope.slope * old_dt
576     new_slope: VotedSlope = VotedSlope({
577         slope: slope * _user_weight / 10000,
578         end: lock_end,
579         power: _user_weight
580     })
581     new_dt: uint256 = lock_end - next_time  # dev: raises when expired
582     new_bias: uint256 = new_slope.slope * new_dt
583 
584     # Check and update powers (weights) used
585     power_used: uint256 = self.vote_user_power[msg.sender]
586     power_used = power_used + new_slope.power - old_slope.power
587     self.vote_user_power[msg.sender] = power_used
588     assert (power_used >= 0) and (power_used <= 10000), 'Used too much power'
589 
590     ## Remove old and schedule new slope changes
591     # Remove slope changes for old slopes
592     # Schedule recording of initial slope for next_time
593     old_weight_bias: uint256 = self._get_weight(_gauge_addr)
594     old_weight_slope: uint256 = self.points_weight[_gauge_addr][next_time].slope
595     old_sum_bias: uint256 = self._get_sum(gauge_type)
596     old_sum_slope: uint256 = self.points_sum[gauge_type][next_time].slope
597 
598     self.points_weight[_gauge_addr][next_time].bias = max(old_weight_bias + new_bias, old_bias) - old_bias
599     self.points_sum[gauge_type][next_time].bias = max(old_sum_bias + new_bias, old_bias) - old_bias
600     if old_slope.end > next_time:
601         self.points_weight[_gauge_addr][next_time].slope = max(old_weight_slope + new_slope.slope, old_slope.slope) - old_slope.slope
602         self.points_sum[gauge_type][next_time].slope = max(old_sum_slope + new_slope.slope, old_slope.slope) - old_slope.slope
603     else:
604         self.points_weight[_gauge_addr][next_time].slope += new_slope.slope
605         self.points_sum[gauge_type][next_time].slope += new_slope.slope
606     if old_slope.end > block.timestamp:
607         # Cancel old slope changes if they still didn't happen
608         self.changes_weight[_gauge_addr][old_slope.end] -= old_slope.slope
609         self.changes_sum[gauge_type][old_slope.end] -= old_slope.slope
610     # Add slope changes for new slopes
611     self.changes_weight[_gauge_addr][new_slope.end] += new_slope.slope
612     self.changes_sum[gauge_type][new_slope.end] += new_slope.slope
613 
614     self._get_total()
615 
616     self.vote_user_slopes[msg.sender][_gauge_addr] = new_slope
617 
618     # Record last action time
619     self.last_user_vote[msg.sender][_gauge_addr] = block.timestamp
620 
621     log VoteForGauge(block.timestamp, msg.sender, _gauge_addr, _user_weight)
622 
623 
624 @external
625 @view
626 def get_gauge_weight(addr: address) -> uint256:
627     """
628     @notice Get current gauge weight
629     @param addr Gauge address
630     @return Gauge weight
631     """
632     return self.points_weight[addr][self.time_weight[addr]].bias
633 
634 
635 @external
636 @view
637 def get_type_weight(type_id: int128) -> uint256:
638     """
639     @notice Get current type weight
640     @param type_id Type id
641     @return Type weight
642     """
643     return self.points_type_weight[type_id][self.time_type_weight[type_id]]
644 
645 
646 @external
647 @view
648 def get_total_weight() -> uint256:
649     """
650     @notice Get current total (type-weighted) weight
651     @return Total weight
652     """
653     return self.points_total[self.time_total]
654 
655 
656 @external
657 @view
658 def get_weights_sum_per_type(type_id: int128) -> uint256:
659     """
660     @notice Get sum of gauge weights per type
661     @param type_id Type id
662     @return Sum of gauge weights
663     """
664     return self.points_sum[type_id][self.time_sum[type_id]].bias
665 
666 @external
667 def change_global_emission_rate(new_rate: uint256):
668     """
669     @notice Change FXS emission rate
670     @param new_rate new emission rate (FXS per second)
671     """
672     assert msg.sender == self.admin
673     self.global_emission_rate = new_rate