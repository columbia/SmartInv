1 # @version 0.2.16
2 
3 """
4 @title Gauge Controller
5 @author Angle Protocol
6 @license MIT
7 @notice Controls liquidity gauges and the issuance of coins through the gauges
8 """
9 
10 # Full fork from:
11 # Curve Finance's gauge controller
12 # https://github.com/curvefi/curve-dao-contracts/blob/master/contracts/GaugeController.vy
13 
14 # 7 * 86400 seconds - all future times are rounded by week
15 WEEK: constant(uint256) = 604800
16 
17 # Cannot change weight votes more often than once in 10 days
18 WEIGHT_VOTE_DELAY: constant(uint256) = 10 * 86400
19 
20 
21 struct Point:
22     bias: uint256
23     slope: uint256
24 
25 struct VotedSlope:
26     slope: uint256
27     power: uint256
28     end: uint256
29 
30 
31 interface VotingEscrow:
32     def get_last_user_slope(addr: address) -> int128: view
33     def locked__end(addr: address) -> uint256: view
34 
35 
36 event CommitOwnership:
37     admin: address
38 
39 event ApplyOwnership:
40     admin: address
41 
42 event AddType:
43     name: String[64]
44     type_id: int128
45 
46 event NewTypeWeight:
47     type_id: int128
48     time: uint256
49     weight: uint256
50     total_weight: uint256
51 
52 event NewGaugeWeight:
53     gauge_address: address
54     time: uint256
55     weight: uint256
56     total_weight: uint256
57 
58 event VoteForGauge:
59     time: uint256
60     user: address
61     gauge_addr: address
62     weight: uint256
63 
64 event NewGauge:
65     addr: address
66     gauge_type: int128
67     weight: uint256
68 
69 event KilledGauge:
70     addr: address
71 
72 MULTIPLIER: constant(uint256) = 10 ** 18
73 
74 admin: public(address)  # Can and will be a smart contract
75 future_admin: public(address)  # Can and will be a smart contract
76 
77 token: public(address)  # ANGLE token
78 voting_escrow: public(address)  # Voting escrow
79 
80 # Gauge parameters
81 # All numbers are "fixed point" on the basis of 1e18
82 n_gauge_types: public(int128)
83 n_gauges: public(int128)
84 gauge_type_names: public(HashMap[int128, String[64]])
85 
86 # Needed for enumeration
87 gauges: public(address[1000000000])
88 
89 # we increment values by 1 prior to storing them here so we can rely on a value
90 # of zero as meaning the gauge has not been set
91 gauge_types_: HashMap[address, int128]
92 
93 vote_user_slopes: public(HashMap[address, HashMap[address, VotedSlope]])  # user -> gauge_addr -> VotedSlope
94 vote_user_power: public(HashMap[address, uint256])  # Total vote power used by user
95 last_user_vote: public(HashMap[address, HashMap[address, uint256]])  # Last user vote's timestamp for each gauge address
96 
97 # Past and scheduled points for gauge weight, sum of weights per type, total weight
98 # Point is for bias+slope
99 # changes_* are for changes in slope
100 # time_* are for the last change timestamp
101 # timestamps are rounded to whole weeks
102 
103 points_weight: public(HashMap[address, HashMap[uint256, Point]])  # gauge_addr -> time -> Point
104 changes_weight: HashMap[address, HashMap[uint256, uint256]]  # gauge_addr -> time -> slope
105 time_weight: public(HashMap[address, uint256])  # gauge_addr -> last scheduled time (next week)
106 
107 points_sum: public(HashMap[int128, HashMap[uint256, Point]])  # type_id -> time -> Point
108 changes_sum: HashMap[int128, HashMap[uint256, uint256]]  # type_id -> time -> slope
109 time_sum: public(uint256[1000000000])  # type_id -> last scheduled time (next week)
110 
111 points_total: public(HashMap[uint256, uint256])  # time -> total weight
112 time_total: public(uint256)  # last scheduled time
113 
114 points_type_weight: public(HashMap[int128, HashMap[uint256, uint256]])  # type_id -> time -> type weight
115 time_type_weight: public(uint256[1000000000])  # type_id -> last scheduled time (next week)
116 
117 
118 @external
119 def __init__(_token: address, _voting_escrow: address, _admin: address):
120     """
121     @notice Contract constructor
122     @param _token `ERC20ANGLE` contract address
123     @param _voting_escrow `VotingEscrow` contract address
124     """
125     assert _token != ZERO_ADDRESS
126     assert _voting_escrow != ZERO_ADDRESS
127     assert _admin != ZERO_ADDRESS
128 
129     self.admin = _admin
130     self.token = _token
131     self.voting_escrow = _voting_escrow
132     self.time_total = block.timestamp / WEEK * WEEK
133     
134 
135 @external
136 def commit_transfer_ownership(addr: address):
137     """
138     @notice Transfer ownership of GaugeController to `addr`
139     @param addr Address to have ownership transferred to
140     """
141     assert msg.sender == self.admin  # dev: admin only
142     assert addr != ZERO_ADDRESS  # dev: future admin cannot be the 0 address
143     self.future_admin = addr
144     log CommitOwnership(addr)
145 
146 
147 @external
148 def accept_transfer_ownership():
149     """
150     @notice Accept a pending ownership transfer
151     """
152     _admin: address = self.future_admin
153     assert msg.sender == _admin  # dev: future admin only
154 
155     self.admin = _admin
156     log ApplyOwnership(_admin)
157 
158 
159 @external
160 @view
161 def gauge_types(_addr: address) -> int128:
162     """
163     @notice Get gauge type for address
164     @param _addr Gauge address
165     @return Gauge type id
166     """
167     gauge_type: int128 = self.gauge_types_[_addr]
168     assert gauge_type != 0
169 
170     return gauge_type - 1
171 
172 
173 @internal
174 def _get_type_weight(gauge_type: int128) -> uint256:
175     """
176     @notice Fill historic type weights week-over-week for missed checkins
177             and return the type weight for the future week
178     @param gauge_type Gauge type id
179     @return Type weight
180     """
181     t: uint256 = self.time_type_weight[gauge_type]
182     if t > 0:
183         w: uint256 = self.points_type_weight[gauge_type][t]
184         for i in range(500):
185             if t > block.timestamp:
186                 break
187             t += WEEK
188             self.points_type_weight[gauge_type][t] = w
189             if t > block.timestamp:
190                 self.time_type_weight[gauge_type] = t
191         return w
192     else:
193         return 0
194 
195 
196 @internal
197 def _get_sum(gauge_type: int128) -> uint256:
198     """
199     @notice Fill sum of gauge weights for the same type week-over-week for
200             missed checkins and return the sum for the future week
201     @param gauge_type Gauge type id
202     @return Sum of weights
203     """
204     t: uint256 = self.time_sum[gauge_type]
205     if t > 0:
206         pt: Point = self.points_sum[gauge_type][t]
207         for i in range(500):
208             if t > block.timestamp:
209                 break
210             t += WEEK
211             d_bias: uint256 = pt.slope * WEEK
212             if pt.bias > d_bias:
213                 pt.bias -= d_bias
214                 d_slope: uint256 = self.changes_sum[gauge_type][t]
215                 pt.slope -= d_slope
216             else:
217                 pt.bias = 0
218                 pt.slope = 0
219             self.points_sum[gauge_type][t] = pt
220             if t > block.timestamp:
221                 self.time_sum[gauge_type] = t
222         return pt.bias
223     else:
224         return 0
225 
226 
227 @internal
228 def _get_total() -> uint256:
229     """
230     @notice Fill historic total weights week-over-week for missed checkins
231             and return the total for the future week
232     @return Total weight
233     """
234     t: uint256 = self.time_total
235     _n_gauge_types: int128 = self.n_gauge_types
236     if t > block.timestamp:
237         # If we have already checkpointed - still need to change the value
238         t -= WEEK
239     pt: uint256 = self.points_total[t]
240 
241     for gauge_type in range(100):
242         if gauge_type == _n_gauge_types:
243             break
244         self._get_sum(gauge_type)
245         self._get_type_weight(gauge_type)
246 
247     for i in range(500):
248         if t > block.timestamp:
249             break
250         t += WEEK
251         pt = 0
252         # Scales as n_types * n_unchecked_weeks (hopefully 1 at most)
253         for gauge_type in range(100):
254             if gauge_type == _n_gauge_types:
255                 break
256             type_sum: uint256 = self.points_sum[gauge_type][t].bias
257             type_weight: uint256 = self.points_type_weight[gauge_type][t]
258             pt += type_sum * type_weight
259         self.points_total[t] = pt
260 
261         if t > block.timestamp:
262             self.time_total = t
263     return pt
264 
265 
266 @internal
267 def _get_weight(gauge_addr: address) -> uint256:
268     """
269     @notice Fill historic gauge weights week-over-week for missed checkins
270             and return the total for the future week
271     @param gauge_addr Address of the gauge
272     @return Gauge weight
273     """
274     t: uint256 = self.time_weight[gauge_addr]
275     if t > 0:
276         pt: Point = self.points_weight[gauge_addr][t]
277         for i in range(500):
278             if t > block.timestamp:
279                 break
280             t += WEEK
281             d_bias: uint256 = pt.slope * WEEK
282             if pt.bias > d_bias:
283                 pt.bias -= d_bias
284                 d_slope: uint256 = self.changes_weight[gauge_addr][t]
285                 pt.slope -= d_slope
286             else:
287                 pt.bias = 0
288                 pt.slope = 0
289             self.points_weight[gauge_addr][t] = pt
290             if t > block.timestamp:
291                 self.time_weight[gauge_addr] = t
292         return pt.bias
293     else:
294         return 0
295 
296 
297 @external
298 def add_gauge(addr: address, gauge_type: int128, weight: uint256 = 0):
299     """
300     @notice Add gauge `addr` of type `gauge_type` with weight `weight`
301     @param addr Gauge address
302     @param gauge_type Gauge type
303     @param weight Gauge weight
304     """
305     assert msg.sender == self.admin
306     assert (gauge_type >= 0) and (gauge_type < self.n_gauge_types)
307     assert self.gauge_types_[addr] == 0  # dev: cannot add the same gauge twice
308 
309     n: int128 = self.n_gauges
310     self.n_gauges = n + 1
311     self.gauges[n] = addr
312 
313     self.gauge_types_[addr] = gauge_type + 1
314     next_time: uint256 = (block.timestamp + WEEK) / WEEK * WEEK
315 
316     if weight > 0:
317         _type_weight: uint256 = self._get_type_weight(gauge_type)
318         _old_sum: uint256 = self._get_sum(gauge_type)
319         _old_total: uint256 = self._get_total()
320 
321         self.points_sum[gauge_type][next_time].bias = weight + _old_sum
322         self.time_sum[gauge_type] = next_time
323         self.points_total[next_time] = _old_total + _type_weight * weight
324         self.time_total = next_time
325 
326         self.points_weight[addr][next_time].bias = weight
327 
328     if self.time_sum[gauge_type] == 0:
329         self.time_sum[gauge_type] = next_time
330     self.time_weight[addr] = next_time
331 
332     log NewGauge(addr, gauge_type, weight)
333 
334 
335 @external
336 def checkpoint():
337     """
338     @notice Checkpoint to fill data common for all gauges
339     """
340     self._get_total()
341 
342 
343 @external
344 def checkpoint_gauge(addr: address):
345     """
346     @notice Checkpoint to fill data for both a specific gauge and common for all gauges
347     @param addr Gauge address
348     """
349     self._get_weight(addr)
350     self._get_total()
351 
352 
353 @internal
354 @view
355 def _gauge_relative_weight(addr: address, time: uint256) -> uint256:
356     """
357     @notice Get Gauge relative weight (not more than 1.0) normalized to 1e18
358             (e.g. 1.0 == 1e18). Inflation which will be received by it is
359             inflation_rate * relative_weight / 1e18
360     @param addr Gauge address
361     @param time Relative weight at the specified timestamp in the past or present
362     @return Value of relative weight normalized to 1e18
363     """
364     t: uint256 = time / WEEK * WEEK
365     _total_weight: uint256 = self.points_total[t]
366 
367     if _total_weight > 0:
368         gauge_type: int128 = self.gauge_types_[addr] - 1
369         _type_weight: uint256 = self.points_type_weight[gauge_type][t]
370         _gauge_weight: uint256 = self.points_weight[addr][t].bias
371         return MULTIPLIER * _type_weight * _gauge_weight / _total_weight
372 
373     else:
374         return 0
375 
376 
377 @external
378 @view
379 def gauge_relative_weight(addr: address, time: uint256 = block.timestamp) -> uint256:
380     """
381     @notice Get Gauge relative weight (not more than 1.0) normalized to 1e18
382             (e.g. 1.0 == 1e18). Inflation which will be received by it is
383             inflation_rate * relative_weight / 1e18
384     @param addr Gauge address
385     @param time Relative weight at the specified timestamp in the past or present
386     @return Value of relative weight normalized to 1e18
387     """
388     return self._gauge_relative_weight(addr, time)
389 
390 
391 @external
392 def gauge_relative_weight_write(addr: address, time: uint256 = block.timestamp) -> uint256:
393     """
394     @notice Get gauge weight normalized to 1e18 and also fill all the unfilled
395             values for type and gauge records
396     @dev Any address can call, however nothing is recorded if the values are filled already
397     @param addr Gauge address
398     @param time Relative weight at the specified timestamp in the past or present
399     @return Value of relative weight normalized to 1e18
400     """
401     self._get_weight(addr)
402     self._get_total()  # Also calculates get_sum
403     return self._gauge_relative_weight(addr, time)
404 
405 
406 
407 
408 @internal
409 def _change_type_weight(type_id: int128, weight: uint256):
410     """
411     @notice Change type weight
412     @param type_id Type id
413     @param weight New type weight
414     """
415     old_weight: uint256 = self._get_type_weight(type_id)
416     old_sum: uint256 = self._get_sum(type_id)
417     _total_weight: uint256 = self._get_total()
418     next_time: uint256 = (block.timestamp + WEEK) / WEEK * WEEK
419 
420     _total_weight = _total_weight + old_sum * weight - old_sum * old_weight
421     self.points_total[next_time] = _total_weight
422     self.points_type_weight[type_id][next_time] = weight
423     self.time_total = next_time
424     self.time_type_weight[type_id] = next_time
425 
426     log NewTypeWeight(type_id, next_time, weight, _total_weight)
427 
428 
429 @external
430 def add_type(_name: String[64], weight: uint256 = 0):
431     """
432     @notice Add gauge type with name `_name` and weight `weight`
433     @param _name Name of gauge type
434     @param weight Weight of gauge type
435     """
436     assert msg.sender == self.admin
437     type_id: int128 = self.n_gauge_types
438     self.gauge_type_names[type_id] = _name
439     self.n_gauge_types = type_id + 1
440     if weight != 0:
441         self._change_type_weight(type_id, weight)
442         log AddType(_name, type_id)
443 
444 
445 @external
446 def change_type_weight(type_id: int128, weight: uint256):
447     """
448     @notice Change gauge type `type_id` weight to `weight`
449     @param type_id Gauge type id
450     @param weight New Gauge weight
451     """
452     assert msg.sender == self.admin
453     self._change_type_weight(type_id, weight)
454 
455 
456 @internal
457 def _change_gauge_weight(addr: address, weight: uint256):
458     # Change gauge weight
459     # Only needed when testing in reality
460     gauge_type: int128 = self.gauge_types_[addr] - 1
461     old_gauge_weight: uint256 = self._get_weight(addr)
462     type_weight: uint256 = self._get_type_weight(gauge_type)
463     old_sum: uint256 = self._get_sum(gauge_type)
464     _total_weight: uint256 = self._get_total()
465     next_time: uint256 = (block.timestamp + WEEK) / WEEK * WEEK
466 
467     self.points_weight[addr][next_time].bias = weight
468     self.time_weight[addr] = next_time
469 
470     new_sum: uint256 = old_sum + weight - old_gauge_weight
471     self.points_sum[gauge_type][next_time].bias = new_sum
472     self.time_sum[gauge_type] = next_time
473 
474     _total_weight = _total_weight + new_sum * type_weight - old_sum * type_weight
475     self.points_total[next_time] = _total_weight
476     self.time_total = next_time
477 
478     log NewGaugeWeight(addr, block.timestamp, weight, _total_weight)
479 
480 
481 @external
482 def change_gauge_weight(addr: address, weight: uint256):
483     """
484     @notice Change weight of gauge `addr` to `weight`
485     @param addr `GaugeController` contract address
486     @param weight New Gauge weight
487     """
488     assert msg.sender == self.admin
489     self._change_gauge_weight(addr, weight)
490 
491 
492 @external
493 def vote_for_gauge_weights(_gauge_addr: address, _user_weight: uint256):
494     """
495     @notice Allocate voting power for changing pool weights
496     @param _gauge_addr Gauge which `msg.sender` votes for
497     @param _user_weight Weight for a gauge in bps (units of 0.01%). Minimal is 0.01%. Ignored if 0
498     """
499     escrow: address = self.voting_escrow
500     slope: uint256 = convert(VotingEscrow(escrow).get_last_user_slope(msg.sender), uint256)
501     lock_end: uint256 = VotingEscrow(escrow).locked__end(msg.sender)
502     _n_gauges: int128 = self.n_gauges
503     next_time: uint256 = (block.timestamp + WEEK) / WEEK * WEEK
504     assert lock_end > next_time, "Your token lock expires too soon"
505     assert (_user_weight >= 0) and (_user_weight <= 10000), "You used all your voting power"
506     assert block.timestamp >= self.last_user_vote[msg.sender][_gauge_addr] + WEIGHT_VOTE_DELAY, "Cannot vote so often"
507 
508     gauge_type: int128 = self.gauge_types_[_gauge_addr] - 1
509     assert gauge_type >= 0, "Gauge not added"
510     # Prepare slopes and biases in memory
511     old_slope: VotedSlope = self.vote_user_slopes[msg.sender][_gauge_addr]
512     old_dt: uint256 = 0
513     if old_slope.end > next_time:
514         old_dt = old_slope.end - next_time
515     old_bias: uint256 = old_slope.slope * old_dt
516     new_slope: VotedSlope = VotedSlope({
517         slope: slope * _user_weight / 10000,
518         end: lock_end,
519         power: _user_weight
520     })
521     new_dt: uint256 = lock_end - next_time  # dev: raises when expired
522     new_bias: uint256 = new_slope.slope * new_dt
523 
524     # Check and update powers (weights) used
525     power_used: uint256 = self.vote_user_power[msg.sender]
526     power_used = power_used + new_slope.power - old_slope.power
527     self.vote_user_power[msg.sender] = power_used
528     assert (power_used >= 0) and (power_used <= 10000), 'Used too much power'
529 
530     ## Remove old and schedule new slope changes
531     # Remove slope changes for old slopes
532     # Schedule recording of initial slope for next_time
533     old_weight_bias: uint256 = self._get_weight(_gauge_addr)
534     old_weight_slope: uint256 = self.points_weight[_gauge_addr][next_time].slope
535     old_sum_bias: uint256 = self._get_sum(gauge_type)
536     old_sum_slope: uint256 = self.points_sum[gauge_type][next_time].slope
537 
538     self.points_weight[_gauge_addr][next_time].bias = max(old_weight_bias + new_bias, old_bias) - old_bias
539     self.points_sum[gauge_type][next_time].bias = max(old_sum_bias + new_bias, old_bias) - old_bias
540     if old_slope.end > next_time:
541         self.points_weight[_gauge_addr][next_time].slope = max(old_weight_slope + new_slope.slope, old_slope.slope) - old_slope.slope
542         self.points_sum[gauge_type][next_time].slope = max(old_sum_slope + new_slope.slope, old_slope.slope) - old_slope.slope
543     else:
544         self.points_weight[_gauge_addr][next_time].slope += new_slope.slope
545         self.points_sum[gauge_type][next_time].slope += new_slope.slope
546     if old_slope.end > block.timestamp:
547         # Cancel old slope changes if they still didn't happen
548         self.changes_weight[_gauge_addr][old_slope.end] -= old_slope.slope
549         self.changes_sum[gauge_type][old_slope.end] -= old_slope.slope
550     # Add slope changes for new slopes
551     self.changes_weight[_gauge_addr][new_slope.end] += new_slope.slope
552     self.changes_sum[gauge_type][new_slope.end] += new_slope.slope
553 
554     self._get_total()
555 
556     self.vote_user_slopes[msg.sender][_gauge_addr] = new_slope
557 
558     # Record last action time
559     self.last_user_vote[msg.sender][_gauge_addr] = block.timestamp
560 
561     log VoteForGauge(block.timestamp, msg.sender, _gauge_addr, _user_weight)
562 
563 
564 @external
565 @view
566 def get_gauge_weight(addr: address) -> uint256:
567     """
568     @notice Get current gauge weight
569     @param addr Gauge address
570     @return Gauge weight
571     """
572     return self.points_weight[addr][self.time_weight[addr]].bias
573 
574 
575 @external
576 @view
577 def get_type_weight(type_id: int128) -> uint256:
578     """
579     @notice Get current type weight
580     @param type_id Type id
581     @return Type weight
582     """
583     return self.points_type_weight[type_id][self.time_type_weight[type_id]]
584 
585 
586 @external
587 @view
588 def get_total_weight() -> uint256:
589     """
590     @notice Get current total (type-weighted) weight
591     @return Total weight
592     """
593     return self.points_total[self.time_total]
594 
595 
596 @external
597 @view
598 def get_weights_sum_per_type(type_id: int128) -> uint256:
599     """
600     @notice Get sum of gauge weights per type
601     @param type_id Type id
602     @return Sum of gauge weights
603     """
604     return self.points_sum[type_id][self.time_sum[type_id]].bias