1 # @version 0.2.4
2 
3 """
4 @title Gauge Controller
5 @author Curve Finance
6 @license MIT
7 @notice Controls liquidity gauges and the issuance of coins through the gauges
8 """
9 
10 # 7 * 86400 seconds - all future times are rounded by week
11 WEEK: constant(uint256) = 604800
12 
13 # Cannot change weight votes more often than once in 10 days
14 WEIGHT_VOTE_DELAY: constant(uint256) = 10 * 86400
15 
16 
17 struct Point:
18     bias: uint256
19     slope: uint256
20 
21 struct VotedSlope:
22     slope: uint256
23     power: uint256
24     end: uint256
25 
26 
27 interface VotingEscrow:
28     def get_last_user_slope(addr: address) -> int128: view
29     def locked__end(addr: address) -> uint256: view
30 
31 
32 event CommitOwnership:
33     admin: address
34 
35 event ApplyOwnership:
36     admin: address
37 
38 event AddType:
39     name: String[64]
40     type_id: int128
41 
42 event NewTypeWeight:
43     type_id: int128
44     time: uint256
45     weight: uint256
46     total_weight: uint256
47 
48 event NewGaugeWeight:
49     gauge_address: address
50     time: uint256
51     weight: uint256
52     total_weight: uint256
53 
54 event VoteForGauge:
55     time: uint256
56     user: address
57     gauge_addr: address
58     weight: uint256
59 
60 event NewGauge:
61     addr: address
62     gauge_type: int128
63     weight: uint256
64 
65 
66 MULTIPLIER: constant(uint256) = 10 ** 18
67 
68 admin: public(address)  # Can and will be a smart contract
69 future_admin: public(address)  # Can and will be a smart contract
70 
71 token: public(address)  # CRV token
72 voting_escrow: public(address)  # Voting escrow
73 
74 # Gauge parameters
75 # All numbers are "fixed point" on the basis of 1e18
76 n_gauge_types: public(int128)
77 n_gauges: public(int128)
78 gauge_type_names: public(HashMap[int128, String[64]])
79 
80 # Needed for enumeration
81 gauges: public(address[1000000000])
82 
83 # we increment values by 1 prior to storing them here so we can rely on a value
84 # of zero as meaning the gauge has not been set
85 gauge_types_: HashMap[address, int128]
86 
87 vote_user_slopes: public(HashMap[address, HashMap[address, VotedSlope]])  # user -> gauge_addr -> VotedSlope
88 vote_user_power: public(HashMap[address, uint256])  # Total vote power used by user
89 last_user_vote: public(HashMap[address, HashMap[address, uint256]])  # Last user vote's timestamp for each gauge address
90 
91 # Past and scheduled points for gauge weight, sum of weights per type, total weight
92 # Point is for bias+slope
93 # changes_* are for changes in slope
94 # time_* are for the last change timestamp
95 # timestamps are rounded to whole weeks
96 
97 points_weight: public(HashMap[address, HashMap[uint256, Point]])  # gauge_addr -> time -> Point
98 changes_weight: HashMap[address, HashMap[uint256, uint256]]  # gauge_addr -> time -> slope
99 time_weight: public(HashMap[address, uint256])  # gauge_addr -> last scheduled time (next week)
100 
101 points_sum: public(HashMap[int128, HashMap[uint256, Point]])  # type_id -> time -> Point
102 changes_sum: HashMap[int128, HashMap[uint256, uint256]]  # type_id -> time -> slope
103 time_sum: public(uint256[1000000000])  # type_id -> last scheduled time (next week)
104 
105 points_total: public(HashMap[uint256, uint256])  # time -> total weight
106 time_total: public(uint256)  # last scheduled time
107 
108 points_type_weight: public(HashMap[int128, HashMap[uint256, uint256]])  # type_id -> time -> type weight
109 time_type_weight: public(uint256[1000000000])  # type_id -> last scheduled time (next week)
110 
111 
112 @external
113 def __init__(_token: address, _voting_escrow: address):
114     """
115     @notice Contract constructor
116     @param _token `ERC20CRV` contract address
117     @param _voting_escrow `VotingEscrow` contract address
118     """
119     assert _token != ZERO_ADDRESS
120     assert _voting_escrow != ZERO_ADDRESS
121 
122     self.admin = msg.sender
123     self.token = _token
124     self.voting_escrow = _voting_escrow
125     self.time_total = block.timestamp / WEEK * WEEK
126 
127 
128 @external
129 def commit_transfer_ownership(addr: address):
130     """
131     @notice Transfer ownership of GaugeController to `addr`
132     @param addr Address to have ownership transferred to
133     """
134     assert msg.sender == self.admin  # dev: admin only
135     self.future_admin = addr
136     log CommitOwnership(addr)
137 
138 
139 @external
140 def apply_transfer_ownership():
141     """
142     @notice Apply pending ownership transfer
143     """
144     assert msg.sender == self.admin  # dev: admin only
145     _admin: address = self.future_admin
146     assert _admin != ZERO_ADDRESS  # dev: admin not set
147     self.admin = _admin
148     log ApplyOwnership(_admin)
149 
150 
151 @external
152 @view
153 def gauge_types(_addr: address) -> int128:
154     """
155     @notice Get gauge type for address
156     @param _addr Gauge address
157     @return Gauge type id
158     """
159     gauge_type: int128 = self.gauge_types_[_addr]
160     assert gauge_type != 0
161 
162     return gauge_type - 1
163 
164 
165 @internal
166 def _get_type_weight(gauge_type: int128) -> uint256:
167     """
168     @notice Fill historic type weights week-over-week for missed checkins
169             and return the type weight for the future week
170     @param gauge_type Gauge type id
171     @return Type weight
172     """
173     t: uint256 = self.time_type_weight[gauge_type]
174     if t > 0:
175         w: uint256 = self.points_type_weight[gauge_type][t]
176         for i in range(500):
177             if t > block.timestamp:
178                 break
179             t += WEEK
180             self.points_type_weight[gauge_type][t] = w
181             if t > block.timestamp:
182                 self.time_type_weight[gauge_type] = t
183         return w
184     else:
185         return 0
186 
187 
188 @internal
189 def _get_sum(gauge_type: int128) -> uint256:
190     """
191     @notice Fill sum of gauge weights for the same type week-over-week for
192             missed checkins and return the sum for the future week
193     @param gauge_type Gauge type id
194     @return Sum of weights
195     """
196     t: uint256 = self.time_sum[gauge_type]
197     if t > 0:
198         pt: Point = self.points_sum[gauge_type][t]
199         for i in range(500):
200             if t > block.timestamp:
201                 break
202             t += WEEK
203             d_bias: uint256 = pt.slope * WEEK
204             if pt.bias > d_bias:
205                 pt.bias -= d_bias
206                 d_slope: uint256 = self.changes_sum[gauge_type][t]
207                 pt.slope -= d_slope
208             else:
209                 pt.bias = 0
210                 pt.slope = 0
211             self.points_sum[gauge_type][t] = pt
212             if t > block.timestamp:
213                 self.time_sum[gauge_type] = t
214         return pt.bias
215     else:
216         return 0
217 
218 
219 @internal
220 def _get_total() -> uint256:
221     """
222     @notice Fill historic total weights week-over-week for missed checkins
223             and return the total for the future week
224     @return Total weight
225     """
226     t: uint256 = self.time_total
227     _n_gauge_types: int128 = self.n_gauge_types
228     if t > block.timestamp:
229         # If we have already checkpointed - still need to change the value
230         t -= WEEK
231     pt: uint256 = self.points_total[t]
232 
233     for gauge_type in range(100):
234         if gauge_type == _n_gauge_types:
235             break
236         self._get_sum(gauge_type)
237         self._get_type_weight(gauge_type)
238 
239     for i in range(500):
240         if t > block.timestamp:
241             break
242         t += WEEK
243         pt = 0
244         # Scales as n_types * n_unchecked_weeks (hopefully 1 at most)
245         for gauge_type in range(100):
246             if gauge_type == _n_gauge_types:
247                 break
248             type_sum: uint256 = self.points_sum[gauge_type][t].bias
249             type_weight: uint256 = self.points_type_weight[gauge_type][t]
250             pt += type_sum * type_weight
251         self.points_total[t] = pt
252 
253         if t > block.timestamp:
254             self.time_total = t
255     return pt
256 
257 
258 @internal
259 def _get_weight(gauge_addr: address) -> uint256:
260     """
261     @notice Fill historic gauge weights week-over-week for missed checkins
262             and return the total for the future week
263     @param gauge_addr Address of the gauge
264     @return Gauge weight
265     """
266     t: uint256 = self.time_weight[gauge_addr]
267     if t > 0:
268         pt: Point = self.points_weight[gauge_addr][t]
269         for i in range(500):
270             if t > block.timestamp:
271                 break
272             t += WEEK
273             d_bias: uint256 = pt.slope * WEEK
274             if pt.bias > d_bias:
275                 pt.bias -= d_bias
276                 d_slope: uint256 = self.changes_weight[gauge_addr][t]
277                 pt.slope -= d_slope
278             else:
279                 pt.bias = 0
280                 pt.slope = 0
281             self.points_weight[gauge_addr][t] = pt
282             if t > block.timestamp:
283                 self.time_weight[gauge_addr] = t
284         return pt.bias
285     else:
286         return 0
287 
288 
289 @external
290 def add_gauge(addr: address, gauge_type: int128, weight: uint256 = 0):
291     """
292     @notice Add gauge `addr` of type `gauge_type` with weight `weight`
293     @param addr Gauge address
294     @param gauge_type Gauge type
295     @param weight Gauge weight
296     """
297     assert msg.sender == self.admin
298     assert (gauge_type >= 0) and (gauge_type < self.n_gauge_types)
299     assert self.gauge_types_[addr] == 0  # dev: cannot add the same gauge twice
300 
301     n: int128 = self.n_gauges
302     self.n_gauges = n + 1
303     self.gauges[n] = addr
304 
305     self.gauge_types_[addr] = gauge_type + 1
306     next_time: uint256 = (block.timestamp + WEEK) / WEEK * WEEK
307 
308     if weight > 0:
309         _type_weight: uint256 = self._get_type_weight(gauge_type)
310         _old_sum: uint256 = self._get_sum(gauge_type)
311         _old_total: uint256 = self._get_total()
312 
313         self.points_sum[gauge_type][next_time].bias = weight + _old_sum
314         self.time_sum[gauge_type] = next_time
315         self.points_total[next_time] = _old_total + _type_weight * weight
316         self.time_total = next_time
317 
318         self.points_weight[addr][next_time].bias = weight
319 
320     if self.time_sum[gauge_type] == 0:
321         self.time_sum[gauge_type] = next_time
322     self.time_weight[addr] = next_time
323 
324     log NewGauge(addr, gauge_type, weight)
325 
326 
327 @external
328 def checkpoint():
329     """
330     @notice Checkpoint to fill data common for all gauges
331     """
332     self._get_total()
333 
334 
335 @external
336 def checkpoint_gauge(addr: address):
337     """
338     @notice Checkpoint to fill data for both a specific gauge and common for all gauges
339     @param addr Gauge address
340     """
341     self._get_weight(addr)
342     self._get_total()
343 
344 
345 @internal
346 @view
347 def _gauge_relative_weight(addr: address, time: uint256) -> uint256:
348     """
349     @notice Get Gauge relative weight (not more than 1.0) normalized to 1e18
350             (e.g. 1.0 == 1e18). Inflation which will be received by it is
351             inflation_rate * relative_weight / 1e18
352     @param addr Gauge address
353     @param time Relative weight at the specified timestamp in the past or present
354     @return Value of relative weight normalized to 1e18
355     """
356     t: uint256 = time / WEEK * WEEK
357     _total_weight: uint256 = self.points_total[t]
358 
359     if _total_weight > 0:
360         gauge_type: int128 = self.gauge_types_[addr] - 1
361         _type_weight: uint256 = self.points_type_weight[gauge_type][t]
362         _gauge_weight: uint256 = self.points_weight[addr][t].bias
363         return MULTIPLIER * _type_weight * _gauge_weight / _total_weight
364 
365     else:
366         return 0
367 
368 
369 @external
370 @view
371 def gauge_relative_weight(addr: address, time: uint256 = block.timestamp) -> uint256:
372     """
373     @notice Get Gauge relative weight (not more than 1.0) normalized to 1e18
374             (e.g. 1.0 == 1e18). Inflation which will be received by it is
375             inflation_rate * relative_weight / 1e18
376     @param addr Gauge address
377     @param time Relative weight at the specified timestamp in the past or present
378     @return Value of relative weight normalized to 1e18
379     """
380     return self._gauge_relative_weight(addr, time)
381 
382 
383 @external
384 def gauge_relative_weight_write(addr: address, time: uint256 = block.timestamp) -> uint256:
385     """
386     @notice Get gauge weight normalized to 1e18 and also fill all the unfilled
387             values for type and gauge records
388     @dev Any address can call, however nothing is recorded if the values are filled already
389     @param addr Gauge address
390     @param time Relative weight at the specified timestamp in the past or present
391     @return Value of relative weight normalized to 1e18
392     """
393     self._get_weight(addr)
394     self._get_total()  # Also calculates get_sum
395     return self._gauge_relative_weight(addr, time)
396 
397 
398 
399 
400 @internal
401 def _change_type_weight(type_id: int128, weight: uint256):
402     """
403     @notice Change type weight
404     @param type_id Type id
405     @param weight New type weight
406     """
407     old_weight: uint256 = self._get_type_weight(type_id)
408     old_sum: uint256 = self._get_sum(type_id)
409     _total_weight: uint256 = self._get_total()
410     next_time: uint256 = (block.timestamp + WEEK) / WEEK * WEEK
411 
412     _total_weight = _total_weight + old_sum * weight - old_sum * old_weight
413     self.points_total[next_time] = _total_weight
414     self.points_type_weight[type_id][next_time] = weight
415     self.time_total = next_time
416     self.time_type_weight[type_id] = next_time
417 
418     log NewTypeWeight(type_id, next_time, weight, _total_weight)
419 
420 
421 @external
422 def add_type(_name: String[64], weight: uint256 = 0):
423     """
424     @notice Add gauge type with name `_name` and weight `weight`
425     @param _name Name of gauge type
426     @param weight Weight of gauge type
427     """
428     assert msg.sender == self.admin
429     type_id: int128 = self.n_gauge_types
430     self.gauge_type_names[type_id] = _name
431     self.n_gauge_types = type_id + 1
432     if weight != 0:
433         self._change_type_weight(type_id, weight)
434         log AddType(_name, type_id)
435 
436 
437 @external
438 def change_type_weight(type_id: int128, weight: uint256):
439     """
440     @notice Change gauge type `type_id` weight to `weight`
441     @param type_id Gauge type id
442     @param weight New Gauge weight
443     """
444     assert msg.sender == self.admin
445     self._change_type_weight(type_id, weight)
446 
447 
448 @internal
449 def _change_gauge_weight(addr: address, weight: uint256):
450     # Change gauge weight
451     # Only needed when testing in reality
452     gauge_type: int128 = self.gauge_types_[addr] - 1
453     old_gauge_weight: uint256 = self._get_weight(addr)
454     type_weight: uint256 = self._get_type_weight(gauge_type)
455     old_sum: uint256 = self._get_sum(gauge_type)
456     _total_weight: uint256 = self._get_total()
457     next_time: uint256 = (block.timestamp + WEEK) / WEEK * WEEK
458 
459     self.points_weight[addr][next_time].bias = weight
460     self.time_weight[addr] = next_time
461 
462     new_sum: uint256 = old_sum + weight - old_gauge_weight
463     self.points_sum[gauge_type][next_time].bias = new_sum
464     self.time_sum[gauge_type] = next_time
465 
466     _total_weight = _total_weight + new_sum * type_weight - old_sum * type_weight
467     self.points_total[next_time] = _total_weight
468     self.time_total = next_time
469 
470     log NewGaugeWeight(addr, block.timestamp, weight, _total_weight)
471 
472 
473 @external
474 def change_gauge_weight(addr: address, weight: uint256):
475     """
476     @notice Change weight of gauge `addr` to `weight`
477     @param addr `GaugeController` contract address
478     @param weight New Gauge weight
479     """
480     assert msg.sender == self.admin
481     self._change_gauge_weight(addr, weight)
482 
483 
484 @external
485 def vote_for_gauge_weights(_gauge_addr: address, _user_weight: uint256):
486     """
487     @notice Allocate voting power for changing pool weights
488     @param _gauge_addr Gauge which `msg.sender` votes for
489     @param _user_weight Weight for a gauge in bps (units of 0.01%). Minimal is 0.01%. Ignored if 0
490     """
491     escrow: address = self.voting_escrow
492     slope: uint256 = convert(VotingEscrow(escrow).get_last_user_slope(msg.sender), uint256)
493     lock_end: uint256 = VotingEscrow(escrow).locked__end(msg.sender)
494     _n_gauges: int128 = self.n_gauges
495     next_time: uint256 = (block.timestamp + WEEK) / WEEK * WEEK
496     assert lock_end > next_time, "Your token lock expires too soon"
497     assert (_user_weight >= 0) and (_user_weight <= 10000), "You used all your voting power"
498     assert block.timestamp >= self.last_user_vote[msg.sender][_gauge_addr] + WEIGHT_VOTE_DELAY, "Cannot vote so often"
499 
500     gauge_type: int128 = self.gauge_types_[_gauge_addr] - 1
501     assert gauge_type >= 0, "Gauge not added"
502     # Prepare slopes and biases in memory
503     old_slope: VotedSlope = self.vote_user_slopes[msg.sender][_gauge_addr]
504     old_dt: uint256 = 0
505     if old_slope.end > next_time:
506         old_dt = old_slope.end - next_time
507     old_bias: uint256 = old_slope.slope * old_dt
508     new_slope: VotedSlope = VotedSlope({
509         slope: slope * _user_weight / 10000,
510         end: lock_end,
511         power: _user_weight
512     })
513     new_dt: uint256 = lock_end - next_time  # dev: raises when expired
514     new_bias: uint256 = new_slope.slope * new_dt
515 
516     # Check and update powers (weights) used
517     power_used: uint256 = self.vote_user_power[msg.sender]
518     power_used = power_used + new_slope.power - old_slope.power
519     self.vote_user_power[msg.sender] = power_used
520     assert (power_used >= 0) and (power_used <= 10000), 'Used too much power'
521 
522     ## Remove old and schedule new slope changes
523     # Remove slope changes for old slopes
524     # Schedule recording of initial slope for next_time
525     old_weight_bias: uint256 = self._get_weight(_gauge_addr)
526     old_weight_slope: uint256 = self.points_weight[_gauge_addr][next_time].slope
527     old_sum_bias: uint256 = self._get_sum(gauge_type)
528     old_sum_slope: uint256 = self.points_sum[gauge_type][next_time].slope
529 
530     self.points_weight[_gauge_addr][next_time].bias = max(old_weight_bias + new_bias, old_bias) - old_bias
531     self.points_sum[gauge_type][next_time].bias = max(old_sum_bias + new_bias, old_bias) - old_bias
532     if old_slope.end > next_time:
533         self.points_weight[_gauge_addr][next_time].slope = max(old_weight_slope + new_slope.slope, old_slope.slope) - old_slope.slope
534         self.points_sum[gauge_type][next_time].slope = max(old_sum_slope + new_slope.slope, old_slope.slope) - old_slope.slope
535     else:
536         self.points_weight[_gauge_addr][next_time].slope += new_slope.slope
537         self.points_sum[gauge_type][next_time].slope += new_slope.slope
538     if old_slope.end > block.timestamp:
539         # Cancel old slope changes if they still didn't happen
540         self.changes_weight[_gauge_addr][old_slope.end] -= old_slope.slope
541         self.changes_sum[gauge_type][old_slope.end] -= old_slope.slope
542     # Add slope changes for new slopes
543     self.changes_weight[_gauge_addr][new_slope.end] += new_slope.slope
544     self.changes_sum[gauge_type][new_slope.end] += new_slope.slope
545 
546     self._get_total()
547 
548     self.vote_user_slopes[msg.sender][_gauge_addr] = new_slope
549 
550     # Record last action time
551     self.last_user_vote[msg.sender][_gauge_addr] = block.timestamp
552 
553     log VoteForGauge(block.timestamp, msg.sender, _gauge_addr, _user_weight)
554 
555 
556 @external
557 @view
558 def get_gauge_weight(addr: address) -> uint256:
559     """
560     @notice Get current gauge weight
561     @param addr Gauge address
562     @return Gauge weight
563     """
564     return self.points_weight[addr][self.time_weight[addr]].bias
565 
566 
567 @external
568 @view
569 def get_type_weight(type_id: int128) -> uint256:
570     """
571     @notice Get current type weight
572     @param type_id Type id
573     @return Type weight
574     """
575     return self.points_type_weight[type_id][self.time_type_weight[type_id]]
576 
577 
578 @external
579 @view
580 def get_total_weight() -> uint256:
581     """
582     @notice Get current total (type-weighted) weight
583     @return Total weight
584     """
585     return self.points_total[self.time_total]
586 
587 
588 @external
589 @view
590 def get_weights_sum_per_type(type_id: int128) -> uint256:
591     """
592     @notice Get sum of gauge weights per type
593     @param type_id Type id
594     @return Sum of gauge weights
595     """
596     return self.points_sum[type_id][self.time_sum[type_id]].bias