1 # @version 0.3.7
2 
3 # @notice The Llamas auction house
4 # @author The Llamas
5 # @license MIT
6 #
7 # ___________.__                 .____     .__
8 # \__    ___/|  |__    ____      |    |    |  |  _____     _____  _____     ______
9 #   |    |   |  |  \ _/ __ \     |    |    |  |  \__  \   /     \ \__  \   /  ___/
10 #   |    |   |   Y  \\  ___/     |    |___ |  |__ / __ \_|  Y Y  \ / __ \_ \___ \
11 #   |____|   |___|  / \___  >    |_______ \|____/(____  /|__|_|  /(____  //____  >
12 #                 \/      \/             \/           \/       \/      \/      \/
13 
14 
15 interface Llama:
16     def mint() -> uint256: nonpayable
17     def burn(token_id: uint256): nonpayable
18     def transferFrom(
19         from_addr: address, to_addr: address, token_id: uint256
20     ): nonpayable
21 
22 
23 struct Auction:
24         llama_id: uint256
25         amount: uint256
26         start_time: uint256
27         end_time: uint256
28         bidder: address
29         settled: bool
30 
31 
32 event AuctionBid:
33     _llama_id: indexed(uint256)
34     _sender: address
35     _value: uint256
36     _extended: bool
37 
38 
39 event AuctionExtended:
40     _llama_id: indexed(uint256)
41     _end_time: uint256
42 
43 
44 event AuctionTimeBufferUpdated:
45     _time_buffer: uint256
46 
47 
48 event AuctionReservePriceUpdated:
49     _reserve_price: uint256
50 
51 
52 event AuctionMinBidIncrementPercentageUpdated:
53     _min_bid_increment_percentage: uint256
54 
55 
56 event AuctionDurationUpdated:
57     _duration: uint256
58 
59 
60 event AuctionCreated:
61     _llama_id: indexed(uint256)
62     _start_time: uint256
63     _end_time: uint256
64 
65 
66 event AuctionSettled:
67     _llama_id: indexed(uint256)
68     _winner: address
69     _amount: uint256
70 
71 
72 event Withdraw:
73     _withdrawer: indexed(address)
74     _amount: uint256
75 
76 
77 # Technically vyper doesn't need this as it is automatic
78 # in all recent vyper versions, but Etherscan verification
79 # will bork without it.
80 IDENTITY_PRECOMPILE: constant(
81     address
82 ) = 0x0000000000000000000000000000000000000004
83 
84 ADMIN_MAX_WITHDRAWALS: constant(uint256) = 100
85 
86 # Auction
87 llamas: public(Llama)
88 time_buffer: public(uint256)
89 reserve_price: public(uint256)
90 min_bid_increment_percentage: public(uint256)
91 duration: public(uint256)
92 auction: public(Auction)
93 pending_returns: public(HashMap[address, uint256])
94 
95 # WL Auction
96 wl_enabled: public(bool)
97 wl_signer: public(address)
98 wl_auctions_won: public(HashMap[address, uint256])
99 
100 # Permissions
101 owner: public(address)
102 
103 # Pause
104 paused: public(bool)
105 
106 
107 @external
108 def __init__(
109     _llamas: Llama,
110     _time_buffer: uint256,
111     _reserve_price: uint256,
112     _min_bid_increment_percentage: uint256,
113     _duration: uint256,
114 ):
115     self.llamas = _llamas
116     self.time_buffer = _time_buffer
117     self.reserve_price = _reserve_price
118     self.min_bid_increment_percentage = _min_bid_increment_percentage
119     self.duration = _duration
120     self.owner = msg.sender
121     self.paused = True
122     self.wl_enabled = True
123     self.wl_signer = msg.sender
124 
125 
126 ### AUCTION CREATION/SETTLEMENT ###
127 
128 
129 @external
130 @nonreentrant("lock")
131 def settle_current_and_create_new_auction():
132     """
133     @dev Settle the current auction and start a new one.
134       Throws if the auction house is paused.
135     """
136 
137     assert self.paused == False, "Auction house is paused"
138 
139     self._settle_auction()
140     self._create_auction()
141 
142 
143 @external
144 @nonreentrant("lock")
145 def settle_auction():
146     """
147     @dev Settle the current auction.
148       Throws if the auction house is not paused.
149     """
150 
151     assert self.paused == True, "Auction house is not paused"
152 
153     self._settle_auction()
154 
155 
156 ### BIDDING ###
157 
158 
159 @external
160 @payable
161 @nonreentrant("lock")
162 def create_friend_bid(llama_id: uint256, bid_amount: uint256, sig: Bytes[65]):
163     """
164     @dev Create a bid.
165       Throws if the whitelist is not enabled.
166       Throws if the `sig` is invalid.
167       Throws if the `msg.sender` has already won one whitelist auctions.
168     """
169 
170     assert self.wl_enabled == True, "WL auction is not enabled"
171     assert self._check_friend_signature(sig, msg.sender), "Signature is invalid"
172     assert self.wl_auctions_won[msg.sender] < 1, "Already won 1 WL auction"
173 
174     self._create_bid(llama_id, bid_amount)
175 
176 
177 @external
178 @payable
179 @nonreentrant("lock")
180 def create_wl_bid(llama_id: uint256, bid_amount: uint256, sig: Bytes[65]):
181     """
182     @dev Create a bid.
183       Throws if the whitelist is not enabled.
184       Throws if the `sig` is invalid.
185       Throws if the `msg.sender` has already won two whitelist auctions.
186     """
187 
188     assert self.wl_enabled == True, "WL auction is not enabled"
189     assert self._check_wl_signature(sig, msg.sender), "Signature is invalid"
190     assert self.wl_auctions_won[msg.sender] < 2, "Already won 2 WL auctions"
191 
192     self._create_bid(llama_id, bid_amount)
193 
194 
195 @external
196 @payable
197 @nonreentrant("lock")
198 def create_bid(llama_id: uint256, bid_amount: uint256):
199     """
200     @dev Create a bid.
201       Throws if the whitelist is enabled.
202     """
203 
204     assert self.wl_enabled == False, "Public auction is not enabled"
205 
206     self._create_bid(llama_id, bid_amount)
207 
208 
209 ### WITHDRAW ###
210 
211 
212 @external
213 @nonreentrant("lock")
214 def withdraw():
215     """
216     @dev Withdraw ETH after losing auction.
217     """
218 
219     pending_amount: uint256 = self.pending_returns[msg.sender]
220     self.pending_returns[msg.sender] = 0
221     send(msg.sender, pending_amount)
222 
223     log Withdraw(msg.sender, pending_amount)
224 
225 
226 ### ADMIN FUNCTIONS
227 
228 
229 @external
230 def withdraw_stale(addresses: DynArray[address, ADMIN_MAX_WITHDRAWALS]):
231     """
232     @dev Admin function to withdraw pending returns that have not been claimed.
233     """
234 
235     assert msg.sender == self.owner, "Caller is not the owner"
236 
237     total_fee: uint256 = 0
238     for _address in addresses:
239         pending_amount: uint256 = self.pending_returns[_address]
240         if pending_amount == 0:
241             continue
242         # Take a 5% fee
243         fee: uint256 = (pending_amount * 5) / 100
244         withdrawer_return: uint256 = pending_amount - fee
245         self.pending_returns[_address] = 0
246         send(_address, withdrawer_return)
247         total_fee += fee
248 
249     send(self.owner, total_fee)
250 
251 
252 @external
253 def pause():
254     """
255     @notice Admin function to pause to auction house.
256     """
257 
258     assert msg.sender == self.owner, "Caller is not the owner"
259     self._pause()
260 
261 
262 @external
263 def unpause():
264     """
265     @notice Admin function to unpause to auction house.
266     """
267 
268     assert msg.sender == self.owner, "Caller is not the owner"
269     self._unpause()
270 
271     if self.auction.start_time == 0 or self.auction.settled:
272         self._create_auction()
273 
274 
275 @external
276 def set_time_buffer(_time_buffer: uint256):
277     """
278     @notice Admin function to set the time buffer.
279     """
280 
281     assert msg.sender == self.owner, "Caller is not the owner"
282 
283     self.time_buffer = _time_buffer
284 
285     log AuctionTimeBufferUpdated(_time_buffer)
286 
287 
288 @external
289 def set_reserve_price(_reserve_price: uint256):
290     """
291     @notice Admin function to set the reserve price.
292     """
293 
294     assert msg.sender == self.owner, "Caller is not the owner"
295 
296     self.reserve_price = _reserve_price
297 
298     log AuctionReservePriceUpdated(_reserve_price)
299 
300 
301 @external
302 def set_min_bid_increment_percentage(_min_bid_increment_percentage: uint256):
303     """
304     @notice Admin function to set the min bid increment percentage.
305     """
306 
307     assert msg.sender == self.owner, "Caller is not the owner"
308     assert (
309         _min_bid_increment_percentage >= 2
310         and _min_bid_increment_percentage <= 15
311     ), "_min_bid_increment_percentage out of range"
312 
313     self.min_bid_increment_percentage = _min_bid_increment_percentage
314 
315     log AuctionMinBidIncrementPercentageUpdated(_min_bid_increment_percentage)
316 
317 
318 @external
319 def set_duration(_duration: uint256):
320     """
321     @notice Admin function to set the duration.
322     """
323 
324     assert msg.sender == self.owner, "Caller is not the owner"
325     assert _duration >= 3600 and _duration <= 259200, "_duration out of range"
326 
327     self.duration = _duration
328 
329     log AuctionDurationUpdated(_duration)
330 
331 
332 @external
333 def set_owner(_owner: address):
334     """
335     @notice Admin function to set the owner
336     """
337 
338     assert msg.sender == self.owner, "Caller is not the owner"
339     assert _owner != empty(address), "Cannot set owner to zero address"
340 
341     self.owner = _owner
342 
343 
344 @external
345 def enable_wl():
346     """
347     @notice Admin function to enable the whitelist.
348     """
349 
350     assert msg.sender == self.owner, "Caller is not the owner"
351 
352     self.wl_enabled = True
353 
354 
355 @external
356 def disable_wl():
357     """
358     @notice Admin function to disable the whitelist.
359     """
360 
361     assert msg.sender == self.owner, "Caller is not the owner"
362 
363     self.wl_enabled = False
364 
365 
366 @external
367 def set_wl_signer(_wl_signer: address):
368     """
369     @notice Admin function to set the whitelist signer.
370     """
371 
372     assert msg.sender == self.owner, "Caller is not the owner"
373 
374     self.wl_signer = _wl_signer
375 
376 
377 @internal
378 def _create_auction():
379     _llama_id: uint256 = self.llamas.mint()
380     _start_time: uint256 = block.timestamp
381     _end_time: uint256 = _start_time + self.duration
382 
383     self.auction = Auction(
384         {
385             llama_id: _llama_id,
386             amount: 0,
387             start_time: _start_time,
388             end_time: _end_time,
389             bidder: empty(address),
390             settled: False,
391         }
392     )
393 
394     log AuctionCreated(_llama_id, _start_time, _end_time)
395 
396 
397 @internal
398 def _settle_auction():
399     assert self.auction.start_time != 0, "Auction hasn't begun"
400     assert self.auction.settled == False, "Auction has already been settled"
401     assert block.timestamp > self.auction.end_time, "Auction hasn't completed"
402 
403     self.auction.settled = True
404 
405     if self.auction.bidder == empty(address):
406         self.llamas.transferFrom(self, self.owner, self.auction.llama_id)
407     else:
408         self.llamas.transferFrom(
409             self, self.auction.bidder, self.auction.llama_id
410         )
411         if self.wl_enabled:
412             self.wl_auctions_won[self.auction.bidder] += 1
413     if self.auction.amount > 0:
414         send(self.owner, self.auction.amount)
415 
416     log AuctionSettled(
417         self.auction.llama_id, self.auction.bidder, self.auction.amount
418     )
419 
420 
421 @internal
422 @payable
423 def _create_bid(llama_id: uint256, amount: uint256):
424     if msg.value < amount:
425         missing_amount: uint256 = amount - msg.value
426         # Try to use the users pending returns
427         assert (
428             self.pending_returns[msg.sender] >= missing_amount
429         ), "Does not have enough pending returns to cover remainder"
430         self.pending_returns[msg.sender] -= missing_amount
431     assert self.auction.llama_id == llama_id, "Llama not up for auction"
432     assert block.timestamp < self.auction.end_time, "Auction expired"
433     assert amount >= self.reserve_price, "Must send at least reservePrice"
434     assert amount >= self.auction.amount + (
435         (self.auction.amount * self.min_bid_increment_percentage) / 100
436     ), "Must send more than last bid by min_bid_increment_percentage amount"
437 
438     last_bidder: address = self.auction.bidder
439 
440     if last_bidder != empty(address):
441         self.pending_returns[last_bidder] += self.auction.amount
442 
443     self.auction.amount = amount
444     self.auction.bidder = msg.sender
445 
446     extended: bool = self.auction.end_time - block.timestamp < self.time_buffer
447 
448     if extended:
449         self.auction.end_time = block.timestamp + self.time_buffer
450 
451     log AuctionBid(self.auction.llama_id, msg.sender, amount, extended)
452 
453     if extended:
454         log AuctionExtended(self.auction.llama_id, self.auction.end_time)
455 
456 
457 @internal
458 def _pause():
459     self.paused = True
460 
461 
462 @internal
463 def _unpause():
464     self.paused = False
465 
466 
467 @internal
468 @view
469 def _check_wl_signature(sig: Bytes[65], sender: address) -> bool:
470     r: uint256 = convert(slice(sig, 0, 32), uint256)
471     s: uint256 = convert(slice(sig, 32, 32), uint256)
472     v: uint256 = convert(slice(sig, 64, 1), uint256)
473     ethSignedHash: bytes32 = keccak256(
474         concat(
475             b"\x19Ethereum Signed Message:\n32",
476             keccak256(_abi_encode("whitelist:", sender)),
477         )
478     )
479 
480     return self.wl_signer == ecrecover(ethSignedHash, v, r, s)
481 
482 
483 @internal
484 @view
485 def _check_friend_signature(sig: Bytes[65], sender: address) -> bool:
486     r: uint256 = convert(slice(sig, 0, 32), uint256)
487     s: uint256 = convert(slice(sig, 32, 32), uint256)
488     v: uint256 = convert(slice(sig, 64, 1), uint256)
489     ethSignedHash: bytes32 = keccak256(
490         concat(
491             b"\x19Ethereum Signed Message:\n32",
492             keccak256(_abi_encode("friend:", sender)),
493         )
494     )
495 
496     return self.wl_signer == ecrecover(ethSignedHash, v, r, s)