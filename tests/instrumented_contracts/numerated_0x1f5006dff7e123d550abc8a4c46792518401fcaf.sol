1 pragma solidity ^0.4.2;
2 
3 // Token standard API
4 // https://github.com/ethereum/EIPs/issues/20
5 contract ERC20Constant {
6     function totalSupply() constant returns (uint supply);
7     function balanceOf( address who ) constant returns (uint value);
8     function allowance(address owner, address spender) constant returns (uint _allowance);
9 }
10 contract ERC20Stateful {
11     function transfer( address to, uint value) returns (bool ok);
12     function transferFrom( address from, address to, uint value) returns (bool ok);
13     function approve(address spender, uint value) returns (bool ok);
14 }
15 contract ERC20Events {
16     event Transfer(address indexed from, address indexed to, uint value);
17     event Approval( address indexed owner, address indexed spender, uint value);
18 }
19 contract ERC20 is ERC20Constant, ERC20Stateful, ERC20Events {}
20 
21 contract Assertive {
22     function assert(bool assertion) internal {
23         if (!assertion) throw;
24     }
25 }
26 
27 contract FallbackFailer {
28   function () {
29     throw;
30   }
31 }
32 
33 contract MutexUser {
34     bool private lock;
35     modifier exclusive {
36         if (lock) throw;
37         lock = true;
38         _;
39         lock = false;
40     }
41 }
42 
43 // A simple direct exchange order manager.
44 
45 contract EventfulMarket {
46     event ItemUpdate( uint id );
47     event Trade( uint sell_how_much, address indexed sell_which_token,
48                  uint buy_how_much, address indexed buy_which_token );
49 }
50 
51 contract SimpleMarket is EventfulMarket
52                        , Assertive
53                        , FallbackFailer
54                        , MutexUser
55 {
56     struct OfferInfo {
57         uint sell_how_much;
58         ERC20 sell_which_token;
59         uint buy_how_much;
60         ERC20 buy_which_token;
61         address owner;
62         bool active;
63     }
64     mapping( uint => OfferInfo ) public offers;
65 
66     uint public last_offer_id;
67 
68     function next_id() internal returns (uint) {
69         last_offer_id++; return last_offer_id;
70     }
71 
72     modifier can_offer {
73         _;
74     }
75     modifier can_buy(uint id) {
76         assert(isActive(id));
77         _;
78     }
79     modifier can_cancel(uint id) {
80         assert(isActive(id));
81         assert(getOwner(id) == msg.sender);
82         _;
83     }
84     function isActive(uint id) constant returns (bool active) {
85         return offers[id].active;
86     }
87     function getOwner(uint id) constant returns (address owner) {
88         return offers[id].owner;
89     }
90     function getOffer( uint id ) constant returns (uint, ERC20, uint, ERC20) {
91       var offer = offers[id];
92       return (offer.sell_how_much, offer.sell_which_token,
93               offer.buy_how_much, offer.buy_which_token);
94     }
95 
96     // non underflowing subtraction
97     function safeSub(uint a, uint b) internal returns (uint) {
98         assert(b <= a);
99         return a - b;
100     }
101     // non overflowing multiplication
102     function safeMul(uint a, uint b) internal returns (uint c) {
103         c = a * b;
104         assert(a == 0 || c / a == b);
105     }
106 
107     function trade( address seller, uint sell_how_much, ERC20 sell_which_token,
108                     address buyer,  uint buy_how_much,  ERC20 buy_which_token )
109         internal
110     {
111         var seller_paid_out = buy_which_token.transferFrom( buyer, seller, buy_how_much );
112         assert(seller_paid_out);
113         var buyer_paid_out = sell_which_token.transfer( buyer, sell_how_much );
114         assert(buyer_paid_out);
115         Trade( sell_how_much, sell_which_token, buy_how_much, buy_which_token );
116     }
117 
118     // ---- Public entrypoints ---- //
119 
120     // Make a new offer. Takes funds from the caller into market escrow.
121     function offer( uint sell_how_much, ERC20 sell_which_token
122                   , uint buy_how_much,  ERC20 buy_which_token )
123         can_offer
124         exclusive
125         returns (uint id)
126     {
127         assert(sell_how_much > 0);
128         assert(sell_which_token != ERC20(0x0));
129         assert(buy_how_much > 0);
130         assert(buy_which_token != ERC20(0x0));
131         assert(sell_which_token != buy_which_token);
132 
133         OfferInfo memory info;
134         info.sell_how_much = sell_how_much;
135         info.sell_which_token = sell_which_token;
136         info.buy_how_much = buy_how_much;
137         info.buy_which_token = buy_which_token;
138         info.owner = msg.sender;
139         info.active = true;
140         id = next_id();
141         offers[id] = info;
142 
143         var seller_paid = sell_which_token.transferFrom( msg.sender, this, sell_how_much );
144         assert(seller_paid);
145 
146         ItemUpdate(id);
147     }
148     // Accept given `quantity` of an offer. Transfers funds from caller to
149     // offer maker, and from market to caller.
150     function buy( uint id, uint quantity )
151         can_buy(id)
152         exclusive
153         returns ( bool success )
154     {
155         // read-only offer. Modify an offer by directly accessing offers[id]
156         OfferInfo memory offer = offers[id];
157 
158         // inferred quantity that the buyer wishes to spend
159         uint spend = safeMul(quantity, offer.buy_how_much) / offer.sell_how_much;
160 
161         if ( spend > offer.buy_how_much || quantity > offer.sell_how_much ) {
162             // buyer wants more than is available
163             success = false;
164         } else if ( spend == offer.buy_how_much && quantity == offer.sell_how_much ) {
165             // buyer wants exactly what is available
166             delete offers[id];
167 
168             trade( offer.owner, quantity, offer.sell_which_token,
169                    msg.sender, spend, offer.buy_which_token );
170 
171             ItemUpdate(id);
172             success = true;
173         } else if ( spend > 0 && quantity > 0 ) {
174             // buyer wants a fraction of what is available
175             offers[id].sell_how_much = safeSub(offer.sell_how_much, quantity);
176             offers[id].buy_how_much = safeSub(offer.buy_how_much, spend);
177 
178             trade( offer.owner, quantity, offer.sell_which_token,
179                     msg.sender, spend, offer.buy_which_token );
180 
181             ItemUpdate(id);
182             success = true;
183         } else {
184             // buyer wants an unsatisfiable amount (less than 1 integer)
185             success = false;
186         }
187     }
188     // Cancel an offer. Refunds offer maker.
189     function cancel( uint id )
190         can_cancel(id)
191         exclusive
192         returns ( bool success )
193     {
194         // read-only offer. Modify an offer by directly accessing offers[id]
195         OfferInfo memory offer = offers[id];
196         delete offers[id];
197 
198         var seller_refunded = offer.sell_which_token.transfer( offer.owner , offer.sell_how_much );
199         assert(seller_refunded);
200 
201         ItemUpdate(id);
202         success = true;
203     }
204 }
205 
206 // Simple Market with a market lifetime. When the lifetime has elapsed,
207 // offers can only be cancelled (offer and buy will throw).
208 
209 contract ExpiringMarket is SimpleMarket {
210     uint public close_time;
211     function ExpiringMarket(uint lifetime) {
212         close_time = getTime() + lifetime;
213     }
214     function getTime() constant returns (uint) {
215         return block.timestamp;
216     }
217     function isClosed() constant returns (bool closed) {
218         return (getTime() > close_time);
219     }
220 
221     // after market lifetime has elapsed, no new offers are allowed
222     modifier can_offer {
223         assert(!isClosed());
224         _;
225     }
226     // after close, no new buys are allowed
227     modifier can_buy(uint id) {
228         assert(isActive(id));
229         assert(!isClosed());
230         _;
231     }
232     // after close, anyone can cancel an offer
233     modifier can_cancel(uint id) {
234         assert(isActive(id));
235         assert(isClosed() || (msg.sender == getOwner(id)));
236         _;
237     }
238 }