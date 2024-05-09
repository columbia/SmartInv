1 /*
2    Copyright 2016, 2017 Nexus Development, LLC
3 
4    Licensed under the Apache License, Version 2.0 (the "License");
5    you may not use this file except in compliance with the License.
6    You may obtain a copy of the License at
7 
8        http://www.apache.org/licenses/LICENSE-2.0
9 
10    Unless required by applicable law or agreed to in writing, software
11    distributed under the License is distributed on an "AS IS" BASIS,
12    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
13    See the License for the specific language governing permissions and
14    limitations under the License.
15 */
16 
17 pragma solidity ^0.4.8;
18 
19 // Token standard API
20 // https://github.com/ethereum/EIPs/issues/20
21 
22 contract ERC20 {
23     function totalSupply() constant returns (uint supply);
24     function balanceOf( address who ) constant returns (uint value);
25     function allowance( address owner, address spender ) constant returns (uint _allowance);
26 
27     function transfer( address to, uint value) returns (bool ok);
28     function transferFrom( address from, address to, uint value) returns (bool ok);
29     function approve( address spender, uint value ) returns (bool ok);
30 
31     event Transfer( address indexed from, address indexed to, uint value);
32     event Approval( address indexed owner, address indexed spender, uint value);
33 }
34 
35 contract EventfulMarket {
36     event ItemUpdate( uint id );
37     event Trade( uint sell_how_much, address indexed sell_which_token,
38                  uint buy_how_much, address indexed buy_which_token );
39 
40     event LogMake(
41         bytes32  indexed  id,
42         bytes32  indexed  pair,
43         address  indexed  maker,
44         ERC20             haveToken,
45         ERC20             wantToken,
46         uint128           haveAmount,
47         uint128           wantAmount,
48         uint64            timestamp
49     );
50 
51     event LogTake(
52         bytes32           id,
53         bytes32  indexed  pair,
54         address  indexed  maker,
55         ERC20             haveToken,
56         ERC20             wantToken,
57         address  indexed  taker,
58         uint128           takeAmount,
59         uint128           giveAmount,
60         uint64            timestamp
61     );
62 
63     event LogKill(
64         bytes32  indexed  id,
65         bytes32  indexed  pair,
66         address  indexed  maker,
67         ERC20             haveToken,
68         ERC20             wantToken,
69         uint128           haveAmount,
70         uint128           wantAmount,
71         uint64            timestamp
72     );
73 }
74 
75 contract SimpleMarket is EventfulMarket {
76     bool locked;
77 
78     modifier synchronized {
79         assert(!locked);
80         locked = true;
81         _;
82         locked = false;
83     }
84 
85     function assert(bool x) internal {
86         if (!x) throw;
87     }
88 
89     struct OfferInfo {
90         uint     sell_how_much;
91         ERC20    sell_which_token;
92         uint     buy_how_much;
93         ERC20    buy_which_token;
94         address  owner;
95         bool     active;
96     }
97 
98     mapping (uint => OfferInfo) public offers;
99 
100     uint public last_offer_id;
101 
102     function next_id() internal returns (uint) {
103         last_offer_id++; return last_offer_id;
104     }
105 
106     modifier can_offer {
107         _;
108     }
109     modifier can_buy(uint id) {
110         assert(isActive(id));
111         _;
112     }
113     modifier can_cancel(uint id) {
114         assert(isActive(id));
115         assert(getOwner(id) == msg.sender);
116         _;
117     }
118     function isActive(uint id) constant returns (bool active) {
119         return offers[id].active;
120     }
121     function getOwner(uint id) constant returns (address owner) {
122         return offers[id].owner;
123     }
124     function getOffer( uint id ) constant returns (uint, ERC20, uint, ERC20) {
125       var offer = offers[id];
126       return (offer.sell_how_much, offer.sell_which_token,
127               offer.buy_how_much, offer.buy_which_token);
128     }
129 
130     // non underflowing subtraction
131     function safeSub(uint a, uint b) internal returns (uint) {
132         assert(b <= a);
133         return a - b;
134     }
135     // non overflowing multiplication
136     function safeMul(uint a, uint b) internal returns (uint c) {
137         c = a * b;
138         assert(a == 0 || c / a == b);
139     }
140 
141     function trade( address seller, uint sell_how_much, ERC20 sell_which_token,
142                     address buyer,  uint buy_how_much,  ERC20 buy_which_token )
143         internal
144     {
145         var seller_paid_out = buy_which_token.transferFrom( buyer, seller, buy_how_much );
146         assert(seller_paid_out);
147         var buyer_paid_out = sell_which_token.transfer( buyer, sell_how_much );
148         assert(buyer_paid_out);
149         Trade( sell_how_much, sell_which_token, buy_how_much, buy_which_token );
150     }
151 
152     // ---- Public entrypoints ---- //
153 
154     function make(
155         ERC20    haveToken,
156         ERC20    wantToken,
157         uint128  haveAmount,
158         uint128  wantAmount
159     ) returns (bytes32 id) {
160         return bytes32(offer(haveAmount, haveToken, wantAmount, wantToken));
161     }
162 
163     function take(bytes32 id, uint128 maxTakeAmount) {
164         assert(buy(uint256(id), maxTakeAmount));
165     }
166 
167     function kill(bytes32 id) {
168         assert(cancel(uint256(id)));
169     }
170 
171     // Make a new offer. Takes funds from the caller into market escrow.
172     function offer( uint sell_how_much, ERC20 sell_which_token
173                   , uint buy_how_much,  ERC20 buy_which_token )
174         can_offer
175         synchronized
176         returns (uint id)
177     {
178         assert(uint128(sell_how_much) == sell_how_much);
179         assert(uint128(buy_how_much) == buy_how_much);
180         assert(sell_how_much > 0);
181         assert(sell_which_token != ERC20(0x0));
182         assert(buy_how_much > 0);
183         assert(buy_which_token != ERC20(0x0));
184         assert(sell_which_token != buy_which_token);
185 
186         OfferInfo memory info;
187         info.sell_how_much = sell_how_much;
188         info.sell_which_token = sell_which_token;
189         info.buy_how_much = buy_how_much;
190         info.buy_which_token = buy_which_token;
191         info.owner = msg.sender;
192         info.active = true;
193         id = next_id();
194         offers[id] = info;
195 
196         var seller_paid = sell_which_token.transferFrom( msg.sender, this, sell_how_much );
197         assert(seller_paid);
198 
199         ItemUpdate(id);
200         LogMake(
201             bytes32(id),
202             sha3(sell_which_token, buy_which_token),
203             msg.sender,
204             sell_which_token,
205             buy_which_token,
206             uint128(sell_how_much),
207             uint128(buy_how_much),
208             uint64(now)
209         );
210     }
211 
212     // Accept given `quantity` of an offer. Transfers funds from caller to
213     // offer maker, and from market to caller.
214     function buy( uint id, uint quantity )
215         can_buy(id)
216         synchronized
217         returns ( bool success )
218     {
219         assert(uint128(quantity) == quantity);
220 
221         // read-only offer. Modify an offer by directly accessing offers[id]
222         OfferInfo memory offer = offers[id];
223 
224         // inferred quantity that the buyer wishes to spend
225         uint spend = safeMul(quantity, offer.buy_how_much) / offer.sell_how_much;
226         assert(uint128(spend) == spend);
227 
228         if ( spend > offer.buy_how_much || quantity > offer.sell_how_much ) {
229             // buyer wants more than is available
230             success = false;
231         } else if ( spend == offer.buy_how_much && quantity == offer.sell_how_much ) {
232             // buyer wants exactly what is available
233             delete offers[id];
234 
235             trade( offer.owner, quantity, offer.sell_which_token,
236                    msg.sender, spend, offer.buy_which_token );
237 
238             ItemUpdate(id);
239             LogTake(
240                 bytes32(id),
241                 sha3(offer.sell_which_token, offer.buy_which_token),
242                 offer.owner,
243                 offer.sell_which_token,
244                 offer.buy_which_token,
245                 msg.sender,
246                 uint128(offer.sell_how_much),
247                 uint128(offer.buy_how_much),
248                 uint64(now)
249             );
250 
251             success = true;
252         } else if ( spend > 0 && quantity > 0 ) {
253             // buyer wants a fraction of what is available
254             offers[id].sell_how_much = safeSub(offer.sell_how_much, quantity);
255             offers[id].buy_how_much = safeSub(offer.buy_how_much, spend);
256 
257             trade( offer.owner, quantity, offer.sell_which_token,
258                     msg.sender, spend, offer.buy_which_token );
259 
260             ItemUpdate(id);
261             LogTake(
262                 bytes32(id),
263                 sha3(offer.sell_which_token, offer.buy_which_token),
264                 offer.owner,
265                 offer.sell_which_token,
266                 offer.buy_which_token,
267                 msg.sender,
268                 uint128(quantity),
269                 uint128(spend),
270                 uint64(now)
271             );
272 
273             success = true;
274         } else {
275             // buyer wants an unsatisfiable amount (less than 1 integer)
276             success = false;
277         }
278     }
279 
280     // Cancel an offer. Refunds offer maker.
281     function cancel( uint id )
282         can_cancel(id)
283         synchronized
284         returns ( bool success )
285     {
286         // read-only offer. Modify an offer by directly accessing offers[id]
287         OfferInfo memory offer = offers[id];
288         delete offers[id];
289 
290         var seller_refunded = offer.sell_which_token.transfer( offer.owner , offer.sell_how_much );
291         assert(seller_refunded);
292 
293         ItemUpdate(id);
294         LogKill(
295             bytes32(id),
296             sha3(offer.sell_which_token, offer.buy_which_token),
297             offer.owner,
298             offer.sell_which_token,
299             offer.buy_which_token,
300             uint128(offer.sell_how_much),
301             uint128(offer.buy_how_much),
302             uint64(now)
303         );
304 
305         success = true;
306     }
307 }
308 
309 // Simple Market with a market lifetime. When the lifetime has elapsed,
310 // offers can only be cancelled (offer and buy will throw).
311 
312 contract ExpiringMarket is SimpleMarket {
313     uint public lifetime;
314     uint public close_time;
315 
316     function ExpiringMarket(uint lifetime_) {
317         lifetime = lifetime_;
318         close_time = getTime() + lifetime_;
319     }
320 
321     function getTime() constant returns (uint) {
322         return block.timestamp;
323     }
324     function isClosed() constant returns (bool closed) {
325         return (getTime() > close_time);
326     }
327 
328     // after market lifetime has elapsed, no new offers are allowed
329     modifier can_offer {
330         assert(!isClosed());
331         _;
332     }
333     // after close, no new buys are allowed
334     modifier can_buy(uint id) {
335         assert(isActive(id));
336         assert(!isClosed());
337         _;
338     }
339     // after close, anyone can cancel an offer
340     modifier can_cancel(uint id) {
341         assert(isActive(id));
342         assert(isClosed() || (msg.sender == getOwner(id)));
343         _;
344     }
345 }