1 contract Assertive {
2     function assert(bool assertion) internal {
3         if (!assertion) throw;
4     }
5 }
6 
7 contract MutexUser {
8     bool private lock;
9     modifier exclusive {
10         if (lock) throw;
11         lock = true;
12         _
13         lock = false;
14     }
15 }
16 contract ERC20 {
17     function totalSupply() constant returns (uint);
18     function balanceOf(address who) constant returns (uint);
19     function allowance(address owner, address spender) constant returns (uint);
20 
21     function transfer(address to, uint value) returns (bool ok);
22     function transferFrom(address from, address to, uint value) returns (bool ok);
23     function approve(address spender, uint value) returns (bool ok);
24 
25     event Transfer(address indexed from, address indexed to, uint value);
26     event Approval(address indexed owner, address indexed spender, uint value);
27 }
28 contract FallbackFailer {
29   function () {
30     throw;
31   }
32 }
33 
34 // A simple direct exchange order manager.
35 
36 contract EventfulMarket {
37     event ItemUpdate( uint id );
38     event Trade( uint sell_how_much, address indexed sell_which_token,
39                  uint buy_how_much, address indexed buy_which_token );
40 }
41 contract SimpleMarket is EventfulMarket
42                        , Assertive
43                        , FallbackFailer
44                        , MutexUser
45 {
46     struct OfferInfo {
47         uint sell_how_much;
48         ERC20 sell_which_token;
49         uint buy_how_much;
50         ERC20 buy_which_token;
51         address owner;
52         bool active;
53     }
54     mapping( uint => OfferInfo ) public offers;
55 
56     uint public last_offer_id;
57 
58     function next_id() internal returns (uint) {
59         last_offer_id++; return last_offer_id;
60     }
61 
62     modifier can_offer {
63         _
64     }
65     modifier can_buy(uint id) {
66         assert(isActive(id));
67         _
68     }
69     modifier can_cancel(uint id) {
70         assert(isActive(id));
71         assert(getOwner(id) == msg.sender);
72         _
73     }
74     function isActive(uint id) constant returns (bool active) {
75         return offers[id].active;
76     }
77     function getOwner(uint id) constant returns (address owner) {
78         return offers[id].owner;
79     }
80     function getOffer( uint id ) constant returns (uint, ERC20, uint, ERC20) {
81       var offer = offers[id];
82       return (offer.sell_how_much, offer.sell_which_token,
83               offer.buy_how_much, offer.buy_which_token);
84     }
85 
86     // non underflowing subtraction
87     function safeSub(uint a, uint b) internal returns (uint) {
88         assert(b <= a);
89         return a - b;
90     }
91     // non overflowing multiplication
92     function safeMul(uint a, uint b) internal returns (uint c) {
93         c = a * b;
94         assert(a == 0 || c / a == b);
95     }
96 
97     function trade( address seller, uint sell_how_much, ERC20 sell_which_token,
98                     address buyer,  uint buy_how_much,  ERC20 buy_which_token )
99         internal
100     {
101         var seller_paid_out = buy_which_token.transferFrom( buyer, seller, buy_how_much );
102         assert(seller_paid_out);
103         var buyer_paid_out = sell_which_token.transfer( buyer, sell_how_much );
104         assert(buyer_paid_out);
105         Trade( sell_how_much, sell_which_token, buy_how_much, buy_which_token );
106     }
107 
108     // ---- Public entrypoints ---- //
109 
110     // Make a new offer. Takes funds from the caller into market escrow.
111     function offer( uint sell_how_much, ERC20 sell_which_token
112                   , uint buy_how_much,  ERC20 buy_which_token )
113         can_offer
114         exclusive
115         returns (uint id)
116     {
117         assert(sell_how_much > 0);
118         assert(sell_which_token != ERC20(0x0));
119         assert(buy_how_much > 0);
120         assert(buy_which_token != ERC20(0x0));
121         assert(sell_which_token != buy_which_token);
122 
123         OfferInfo memory info;
124         info.sell_how_much = sell_how_much;
125         info.sell_which_token = sell_which_token;
126         info.buy_how_much = buy_how_much;
127         info.buy_which_token = buy_which_token;
128         info.owner = msg.sender;
129         info.active = true;
130         id = next_id();
131         offers[id] = info;
132 
133         var seller_paid = sell_which_token.transferFrom( msg.sender, this, sell_how_much );
134         assert(seller_paid);
135 
136         ItemUpdate(id);
137     }
138     // Accept given `quantity` of an offer. Transfers funds from caller to
139     // offer maker, and from market to caller.
140     function buy( uint id, uint quantity )
141         can_buy(id)
142         exclusive
143         returns ( bool success )
144     {
145         // read-only offer. Modify an offer by directly accessing offers[id]
146         OfferInfo memory offer = offers[id];
147 
148         // inferred quantity that the buyer wishes to spend
149         uint spend = safeMul(quantity, offer.buy_how_much) / offer.sell_how_much;
150 
151         if ( spend > offer.buy_how_much || quantity > offer.sell_how_much ) {
152             // buyer wants more than is available
153             success = false;
154         } else if ( spend == offer.buy_how_much && quantity == offer.sell_how_much ) {
155             // buyer wants exactly what is available
156             delete offers[id];
157 
158             trade( offer.owner, quantity, offer.sell_which_token,
159                    msg.sender, spend, offer.buy_which_token );
160 
161             ItemUpdate(id);
162             success = true;
163         } else if ( spend > 0 && quantity > 0 ) {
164             // buyer wants a fraction of what is available
165             offers[id].sell_how_much = safeSub(offer.sell_how_much, quantity);
166             offers[id].buy_how_much = safeSub(offer.buy_how_much, spend);
167 
168             trade( offer.owner, quantity, offer.sell_which_token,
169                     msg.sender, spend, offer.buy_which_token );
170 
171             ItemUpdate(id);
172             success = true;
173         } else {
174             // buyer wants an unsatisfiable amount (less than 1 integer)
175             success = false;
176         }
177     }
178     // Cancel an offer. Refunds offer maker.
179     function cancel( uint id )
180         can_cancel(id)
181         exclusive
182         returns ( bool success )
183     {
184         // read-only offer. Modify an offer by directly accessing offers[id]
185         OfferInfo memory offer = offers[id];
186         delete offers[id];
187 
188         var seller_refunded = offer.sell_which_token.transfer( offer.owner , offer.sell_how_much );
189         assert(seller_refunded);
190 
191         ItemUpdate(id);
192         success = true;
193     }
194 }
195 
196 // Simple Market with a market lifetime. When the lifetime has elapsed,
197 // offers can only be cancelled (offer and buy will throw).
198 
199 contract ExpiringMarket is SimpleMarket {
200     uint public close_time;
201     function ExpiringMarket(uint lifetime) {
202         close_time = getTime() + lifetime;
203     }
204     function getTime() constant returns (uint) {
205         return block.timestamp;
206     }
207     function isClosed() constant returns (bool closed) {
208         return (getTime() > close_time);
209     }
210 
211     // after market lifetime has elapsed, no new offers are allowed
212     modifier can_offer {
213         assert(!isClosed());
214         _
215     }
216     // after close, no new buys are allowed
217     modifier can_buy(uint id) {
218         assert(isActive(id));
219         assert(!isClosed());
220         _
221     }
222     // after close, anyone can cancel an offer
223     modifier can_cancel(uint id) {
224         assert(isActive(id));
225         assert(isClosed() || (msg.sender == getOwner(id)));
226         _
227     }
228 }
229 
230 // Flat file implementation of `dappsys/token/base.sol::DSTokenBase`
231 
232 // Everything throws instead of returning false on failure.
233 
234 contract ERC20Base is ERC20
235 {
236     mapping( address => uint ) _balances;
237     mapping( address => mapping( address => uint ) ) _approvals;
238     uint _supply;
239     function ERC20Base( uint initial_balance ) {
240         _balances[msg.sender] = initial_balance;
241         _supply = initial_balance;
242     }
243     function totalSupply() constant returns (uint supply) {
244         return _supply;
245     }
246     function balanceOf( address who ) constant returns (uint value) {
247         return _balances[who];
248     }
249     function transfer( address to, uint value) returns (bool ok) {
250         if( _balances[msg.sender] < value ) {
251             throw;
252         }
253         if( !safeToAdd(_balances[to], value) ) {
254             throw;
255         }
256         _balances[msg.sender] -= value;
257         _balances[to] += value;
258         Transfer( msg.sender, to, value );
259         return true;
260     }
261     function transferFrom( address from, address to, uint value) returns (bool ok) {
262         // if you don't have enough balance, throw
263         if( _balances[from] < value ) {
264             throw;
265         }
266         // if you don't have approval, throw
267         if( _approvals[from][msg.sender] < value ) {
268             throw;
269         }
270         if( !safeToAdd(_balances[to], value) ) {
271             throw;
272         }
273         // transfer and return true
274         _approvals[from][msg.sender] -= value;
275         _balances[from] -= value;
276         _balances[to] += value;
277         Transfer( from, to, value );
278         return true;
279     }
280     function approve(address spender, uint value) returns (bool ok) {
281         _approvals[msg.sender][spender] = value;
282         Approval( msg.sender, spender, value );
283         return true;
284     }
285     function allowance(address owner, address spender) constant returns (uint _allowance) {
286         return _approvals[owner][spender];
287     }
288     function safeToAdd(uint a, uint b) internal returns (bool) {
289         return (a + b >= a);
290     }
291 }