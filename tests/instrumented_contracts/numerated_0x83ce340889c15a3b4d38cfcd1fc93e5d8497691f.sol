1 pragma solidity ^0.4.8;
2 
3 /// auth.sol -- widely-used access control pattern for Ethereum
4 
5 // Copyright (C) 2015, 2016, 2017  Nexus Development, LLC
6 
7 // Licensed under the Apache License, Version 2.0 (the "License").
8 // You may not use this file except in compliance with the License.
9 
10 // Unless required by applicable law or agreed to in writing, software
11 // distributed under the License is distributed on an "AS IS" BASIS,
12 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
13 
14 contract DSAuthority {
15     function canCall(
16         address src, address dst, bytes4 sig
17     ) constant returns (bool);
18 }
19 
20 contract DSAuthEvents {
21     event LogSetAuthority (address indexed authority);
22     event LogSetOwner     (address indexed owner);
23 }
24 
25 contract DSAuth is DSAuthEvents {
26     DSAuthority  public  authority;
27     address      public  owner;
28 
29     function DSAuth() {
30         owner = msg.sender;
31         LogSetOwner(msg.sender);
32     }
33 
34     function setOwner(address owner_)
35         auth
36     {
37         owner = owner_;
38         LogSetOwner(owner);
39     }
40 
41     function setAuthority(DSAuthority authority_)
42         auth
43     {
44         authority = authority_;
45         LogSetAuthority(authority);
46     }
47 
48     modifier auth {
49         assert(isAuthorized(msg.sender, msg.sig));
50         _;
51     }
52 
53     modifier authorized(bytes4 sig) {
54         assert(isAuthorized(msg.sender, sig));
55         _;
56     }
57 
58     function isAuthorized(address src, bytes4 sig) internal returns (bool) {
59         if (src == owner) {
60             return true;
61         } else if (authority == DSAuthority(0)) {
62             return false;
63         } else {
64             return authority.canCall(src, this, sig);
65         }
66     }
67 
68     function assert(bool x) internal {
69         if (!x) throw;
70     }
71 }
72 
73 contract ERC20 {
74     function totalSupply() constant returns (uint supply);
75     function balanceOf( address who ) constant returns (uint value);
76     function allowance( address owner, address spender ) constant returns (uint _allowance);
77 
78     function transfer( address to, uint value) returns (bool ok);
79     function transferFrom( address from, address to, uint value) returns (bool ok);
80     function approve( address spender, uint value ) returns (bool ok);
81 
82     event Transfer( address indexed from, address indexed to, uint value);
83     event Approval( address indexed owner, address indexed spender, uint value);
84 }
85 
86 contract EventfulMarket {
87     event ItemUpdate( uint id );
88     event Trade( uint sell_how_much, address indexed sell_which_token,
89                  uint buy_how_much, address indexed buy_which_token );
90 
91     event LogMake(
92         bytes32  indexed  id,
93         bytes32  indexed  pair,
94         address  indexed  maker,
95         ERC20             haveToken,
96         ERC20             wantToken,
97         uint128           haveAmount,
98         uint128           wantAmount,
99         uint64            timestamp
100     );
101 
102     event LogBump(
103         bytes32  indexed  id,
104         bytes32  indexed  pair,
105         address  indexed  maker,
106         ERC20             haveToken,
107         ERC20             wantToken,
108         uint128           haveAmount,
109         uint128           wantAmount,
110         uint64            timestamp
111     );
112 
113     event LogTake(
114         bytes32           id,
115         bytes32  indexed  pair,
116         address  indexed  maker,
117         ERC20             haveToken,
118         ERC20             wantToken,
119         address  indexed  taker,
120         uint128           takeAmount,
121         uint128           giveAmount,
122         uint64            timestamp
123     );
124 
125     event LogKill(
126         bytes32  indexed  id,
127         bytes32  indexed  pair,
128         address  indexed  maker,
129         ERC20             haveToken,
130         ERC20             wantToken,
131         uint128           haveAmount,
132         uint128           wantAmount,
133         uint64            timestamp
134     );
135 }
136 
137 contract SimpleMarket is EventfulMarket {
138     bool locked;
139 
140     modifier synchronized {
141         assert(!locked);
142         locked = true;
143         _;
144         locked = false;
145     }
146 
147     function assert(bool x) internal {
148         if (!x) throw;
149     }
150 
151     struct OfferInfo {
152         uint     sell_how_much;
153         ERC20    sell_which_token;
154         uint     buy_how_much;
155         ERC20    buy_which_token;
156         address  owner;
157         bool     active;
158         uint64   timestamp;
159     }
160 
161     mapping (uint => OfferInfo) public offers;
162 
163     uint public last_offer_id;
164 
165     function next_id() internal returns (uint) {
166         last_offer_id++; return last_offer_id;
167     }
168 
169     modifier can_offer {
170         _;
171     }
172     modifier can_buy(uint id) {
173         assert(isActive(id));
174         _;
175     }
176     modifier can_cancel(uint id) {
177         assert(isActive(id));
178         assert(getOwner(id) == msg.sender);
179         _;
180     }
181     function isActive(uint id) constant returns (bool active) {
182         return offers[id].active;
183     }
184     function getOwner(uint id) constant returns (address owner) {
185         return offers[id].owner;
186     }
187     function getOffer( uint id ) constant returns (uint, ERC20, uint, ERC20) {
188       var offer = offers[id];
189       return (offer.sell_how_much, offer.sell_which_token,
190               offer.buy_how_much, offer.buy_which_token);
191     }
192 
193     // non underflowing subtraction
194     function safeSub(uint a, uint b) internal returns (uint) {
195         assert(b <= a);
196         return a - b;
197     }
198     // non overflowing multiplication
199     function safeMul(uint a, uint b) internal returns (uint c) {
200         c = a * b;
201         assert(a == 0 || c / a == b);
202     }
203 
204     function trade( address seller, uint sell_how_much, ERC20 sell_which_token,
205                     address buyer,  uint buy_how_much,  ERC20 buy_which_token )
206         internal
207     {
208         var seller_paid_out = buy_which_token.transferFrom( buyer, seller, buy_how_much );
209         assert(seller_paid_out);
210         var buyer_paid_out = sell_which_token.transfer( buyer, sell_how_much );
211         assert(buyer_paid_out);
212         Trade( sell_how_much, sell_which_token, buy_how_much, buy_which_token );
213     }
214 
215     // ---- Public entrypoints ---- //
216 
217     function make(
218         ERC20    haveToken,
219         ERC20    wantToken,
220         uint128  haveAmount,
221         uint128  wantAmount
222     ) returns (bytes32 id) {
223         return bytes32(offer(haveAmount, haveToken, wantAmount, wantToken));
224     }
225 
226     function take(bytes32 id, uint128 maxTakeAmount) {
227         assert(buy(uint256(id), maxTakeAmount));
228     }
229 
230     function kill(bytes32 id) {
231         assert(cancel(uint256(id)));
232     }
233 
234     // Make a new offer. Takes funds from the caller into market escrow.
235     function offer( uint sell_how_much, ERC20 sell_which_token
236                   , uint buy_how_much,  ERC20 buy_which_token )
237         can_offer
238         synchronized
239         returns (uint id)
240     {
241         assert(uint128(sell_how_much) == sell_how_much);
242         assert(uint128(buy_how_much) == buy_how_much);
243         assert(sell_how_much > 0);
244         assert(sell_which_token != ERC20(0x0));
245         assert(buy_how_much > 0);
246         assert(buy_which_token != ERC20(0x0));
247         assert(sell_which_token != buy_which_token);
248 
249         OfferInfo memory info;
250         info.sell_how_much = sell_how_much;
251         info.sell_which_token = sell_which_token;
252         info.buy_how_much = buy_how_much;
253         info.buy_which_token = buy_which_token;
254         info.owner = msg.sender;
255         info.active = true;
256         info.timestamp = uint64(now);
257         id = next_id();
258         offers[id] = info;
259 
260         var seller_paid = sell_which_token.transferFrom( msg.sender, this, sell_how_much );
261         assert(seller_paid);
262 
263         ItemUpdate(id);
264         LogMake(
265             bytes32(id),
266             sha3(sell_which_token, buy_which_token),
267             msg.sender,
268             sell_which_token,
269             buy_which_token,
270             uint128(sell_how_much),
271             uint128(buy_how_much),
272             uint64(now)
273         );
274     }
275 
276     function bump(bytes32 id_)
277         can_buy(uint256(id_))
278     {
279         var id = uint256(id_);
280         LogBump(
281             id_,
282             sha3(offers[id].sell_which_token, offers[id].buy_which_token),
283             offers[id].owner,
284             offers[id].sell_which_token,
285             offers[id].buy_which_token,
286             uint128(offers[id].sell_how_much),
287             uint128(offers[id].buy_how_much),
288             offers[id].timestamp
289         );
290     }
291 
292     // Accept given `quantity` of an offer. Transfers funds from caller to
293     // offer maker, and from market to caller.
294     function buy( uint id, uint quantity )
295         can_buy(id)
296         synchronized
297         returns ( bool success )
298     {
299         assert(uint128(quantity) == quantity);
300 
301         // read-only offer. Modify an offer by directly accessing offers[id]
302         OfferInfo memory offer = offers[id];
303 
304         // inferred quantity that the buyer wishes to spend
305         uint spend = safeMul(quantity, offer.buy_how_much) / offer.sell_how_much;
306         assert(uint128(spend) == spend);
307 
308         if ( spend > offer.buy_how_much || quantity > offer.sell_how_much ) {
309             // buyer wants more than is available
310             success = false;
311         } else if ( spend == offer.buy_how_much && quantity == offer.sell_how_much ) {
312             // buyer wants exactly what is available
313             delete offers[id];
314 
315             trade( offer.owner, quantity, offer.sell_which_token,
316                    msg.sender, spend, offer.buy_which_token );
317 
318             ItemUpdate(id);
319             LogTake(
320                 bytes32(id),
321                 sha3(offer.sell_which_token, offer.buy_which_token),
322                 offer.owner,
323                 offer.sell_which_token,
324                 offer.buy_which_token,
325                 msg.sender,
326                 uint128(offer.sell_how_much),
327                 uint128(offer.buy_how_much),
328                 uint64(now)
329             );
330 
331             success = true;
332         } else if ( spend > 0 && quantity > 0 ) {
333             // buyer wants a fraction of what is available
334             offers[id].sell_how_much = safeSub(offer.sell_how_much, quantity);
335             offers[id].buy_how_much = safeSub(offer.buy_how_much, spend);
336 
337             trade( offer.owner, quantity, offer.sell_which_token,
338                     msg.sender, spend, offer.buy_which_token );
339 
340             ItemUpdate(id);
341             LogTake(
342                 bytes32(id),
343                 sha3(offer.sell_which_token, offer.buy_which_token),
344                 offer.owner,
345                 offer.sell_which_token,
346                 offer.buy_which_token,
347                 msg.sender,
348                 uint128(quantity),
349                 uint128(spend),
350                 uint64(now)
351             );
352 
353             success = true;
354         } else {
355             // buyer wants an unsatisfiable amount (less than 1 integer)
356             success = false;
357         }
358     }
359 
360     // Cancel an offer. Refunds offer maker.
361     function cancel( uint id )
362         can_cancel(id)
363         synchronized
364         returns ( bool success )
365     {
366         // read-only offer. Modify an offer by directly accessing offers[id]
367         OfferInfo memory offer = offers[id];
368         delete offers[id];
369 
370         var seller_refunded = offer.sell_which_token.transfer( offer.owner , offer.sell_how_much );
371         assert(seller_refunded);
372 
373         ItemUpdate(id);
374         LogKill(
375             bytes32(id),
376             sha3(offer.sell_which_token, offer.buy_which_token),
377             offer.owner,
378             offer.sell_which_token,
379             offer.buy_which_token,
380             uint128(offer.sell_how_much),
381             uint128(offer.buy_how_much),
382             uint64(now)
383         );
384 
385         success = true;
386     }
387 }
388 
389 // Simple Market with a market lifetime. When the lifetime has elapsed,
390 // offers can only be cancelled (offer and buy will throw).
391 
392 contract ExpiringMarket is DSAuth, SimpleMarket {
393     uint public lifetime;
394     uint public close_time;
395     bool public stopped;
396 
397     function stop() auth {
398         stopped = true;
399     }
400 
401     function ExpiringMarket(uint lifetime_) {
402         lifetime = lifetime_;
403         close_time = getTime() + lifetime_;
404     }
405 
406     function getTime() constant returns (uint) {
407         return block.timestamp;
408     }
409     function isClosed() constant returns (bool closed) {
410         return stopped || (getTime() > close_time);
411     }
412 
413     // after market lifetime has elapsed, no new offers are allowed
414     modifier can_offer {
415         assert(!isClosed());
416         _;
417     }
418     // after close, no new buys are allowed
419     modifier can_buy(uint id) {
420         assert(isActive(id));
421         assert(!isClosed());
422         _;
423     }
424     // after close, anyone can cancel an offer
425     modifier can_cancel(uint id) {
426         assert(isActive(id));
427         assert(isClosed() || (msg.sender == getOwner(id)));
428         _;
429     }
430 }