1 contract ERC20 {
2     function totalSupply() constant returns (uint totalSupply);
3     function balanceOf(address _owner) constant returns (uint balance);
4     function transfer(address _to, uint _value) returns (bool success);
5     function transferFrom(address _from, address _to, uint _value) returns (bool success);
6     function approve(address _spender, uint _value) returns (bool success);
7     function allowance(address _owner, address _spender) constant returns (uint remaining);
8     event Transfer(address indexed _from, address indexed _to, uint _value);
9     event Approval(address indexed _owner, address indexed _spender, uint _value);
10 }
11 
12 contract ERC20dex {
13     int constant SELL = 0;
14     int constant BUY  = 1;
15     
16     byte constant COIN_DEAD         = 0;
17     byte constant COIN_NON_APPROVED = 1;
18     byte constant COIN_APPROVED     = 2;
19     
20     address owner = 0;
21     address trader = 0;
22     uint256 maker_fee = 0;
23     uint256 taker_fee = 0;
24     uint256 deploy_fee = 0;
25     int stopped = 0;
26     uint256 main_fee = 0;
27     
28     struct order_t {
29         int buy_sell;
30         address owner;
31         uint256 amount;
32         uint256 price;
33         uint256 block;
34     }
35     
36     struct coin_t {
37         string ticker;
38         string name;
39         address base;
40         uint8 digits;
41         address requestor;
42         uint256 minimum_trade;
43         byte state;
44         uint256 fee;
45         uint256 price;
46     }
47     
48     // List of registered coins
49     coin_t[] shitcoins;
50     
51     // Minimum value of a trade
52     uint256 minimum_trade;
53     
54     // Indexing for shitcoins array
55     mapping(string => uint16) shitcoin_index;
56 
57     // Order book
58     mapping(string => order_t[]) order_book;
59     
60     // Balances
61     mapping(address => uint256) etx_balances;
62 
63     function ERC20dex() {
64         owner = msg.sender;
65         trader = msg.sender;
66     }
67     
68     function set_owner(address new_owner) {
69         require(msg.sender == owner);
70         owner = new_owner;
71     }
72     function set_trader(address new_trader) {
73         require(msg.sender == owner);
74         trader = new_trader;
75     }
76     
77     function require(bool condition) constant private {
78         if (condition == false) {
79             throw;
80         }
81     }
82 
83     function assert(bool condition) constant private {
84         if (condition == false) {
85             throw;
86         }
87     }
88     
89     function safe_mul(uint256 a, uint256 b) constant returns (uint256 c) {
90         c = a * b;
91         assert(a == 0 || c / a == b);
92         
93         return c;
94     }
95     
96     function safe_add(uint256 a, uint256 b) constant returns (uint256 c) {
97         require(a + b >= a);
98         return a + b;
99     }
100     
101     function safe_sub(uint256 a, uint256 b) constant returns (uint256 c) {
102         require(a >= b);
103         return a - b;
104     }
105     
106     function stop() public {
107         require(msg.sender == owner);
108         stopped = 1;
109     }
110 
111     function add_coin(string coin, string name, address base, uint8 digits) public {
112         require(msg.sender == owner);
113         require(shitcoin_index[coin] == 0);
114         
115         // Register a new coin
116         shitcoins.push(coin_t(coin, name, base, digits, msg.sender, 0, COIN_APPROVED, 0, 0));
117         shitcoin_index[coin] = uint16(shitcoins.length);
118     }
119     
120     function createToken(string symbol, string name, address coin_address, uint8 decimals) public {
121         // Check if sender included enough ETC for creation
122         require(msg.value == deploy_fee);
123         require(shitcoin_index[symbol] == 0);
124 
125         // Pass fee to the owner
126         require(owner.send(msg.value));
127 
128         // Register a new coin, but do not approve it
129         shitcoins.push(coin_t(symbol, name, coin_address, decimals, msg.sender, 0, COIN_NON_APPROVED, 0, 0));
130         shitcoin_index[symbol] = uint16(shitcoins.length);
131     }
132     
133     function approve_coin(string coin, bool approved) public {
134         require(msg.sender == owner);
135         if (approved) {
136             shitcoins[shitcoin_index[coin] - 1].state = COIN_APPROVED;
137         } else {
138             shitcoins[shitcoin_index[coin] - 1].state = COIN_NON_APPROVED;
139         }
140     }
141     
142     function remove_coin(uint index) public {
143         require(msg.sender == owner);
144         require(index < shitcoins.length);
145         
146         shitcoin_index[shitcoins[index].ticker] = 0;
147         shitcoins[index].state = COIN_DEAD;
148     }
149     
150     function set_fee(uint256 the_maker_fee, uint256 the_taker_fee, uint256 the_deploy_fee) public {
151         require(msg.sender == owner);
152         
153         maker_fee = the_maker_fee;
154         taker_fee = the_taker_fee;
155         deploy_fee = the_deploy_fee;
156     }
157     
158     function set_minimum_trade(uint256 the_minimum_trade) public {
159         require(msg.sender == owner);
160         minimum_trade = the_minimum_trade;
161     }
162     
163     function get_minimum_trade() constant returns (uint256) {
164         return minimum_trade;
165     }
166     
167     function set_coin_minimum_trade(string token, uint256 the_minimum_trade) public {
168         require(msg.sender == owner);
169         shitcoins[shitcoin_index[token] - 1].minimum_trade = the_minimum_trade;
170     }
171 
172     function get_maker_fee() constant returns (uint256) {
173         return maker_fee;
174     }
175     
176     function get_taker_fee() constant returns (uint256) {
177         return taker_fee;
178     }
179     
180     function get_deploy_fee() constant returns (uint256) {
181         return deploy_fee;
182     }
183     
184     function get_coins_count() constant returns (uint256 length) {
185         length = shitcoins.length;
186     }
187     
188     function get_coin(uint index) constant returns (string, string, address, byte, uint8, address, uint256) {
189         coin_t coin = shitcoins[index];
190         return (coin.ticker, coin.name, coin.base, coin.state, coin.digits, coin.requestor, coin.minimum_trade);
191     }
192     
193     function get_balance(address a, string token) constant returns (uint256 balance) {
194         coin_t coin = shitcoins[shitcoin_index[token] - 1];
195         
196         if (coin.state != COIN_DEAD) {
197             // Get ERC20 contract and check how many coins we can use for selling
198             ERC20 shitcoin = ERC20(shitcoins[shitcoin_index[token] - 1].base);
199             balance = shitcoin.allowance(a, this);
200         }
201     }
202     
203     function get_etc_balance(address a) constant returns (uint256 balance) {
204         return etx_balances[a];
205     }
206     
207     function get_order_book_length(string token) constant returns (uint256 length) {
208         return order_book[token].length;
209     }
210     
211     function get_order(string token, uint256 index) constant returns (int, address, uint256, uint256, uint256) {
212         order_t order = order_book[token][index];
213         return (order.buy_sell, order.owner, order.amount, order.price, order.block);
214     }
215     
216     function get_price(string token) constant returns (uint256) {
217         return shitcoins[shitcoin_index[token] - 1].price;
218     }
219     
220     function total_amount(string token, uint256 amount, uint256 price) constant returns (uint256) {
221         return safe_mul(amount, price) / 10**uint256(shitcoins[shitcoin_index[token] - 1].digits);
222     }
223     
224     function sell(string token, uint256 amount, uint256 price) public {
225         // Basic checks
226         require(stopped == 0);
227         require(total_amount(token, amount, price) >= minimum_trade);
228         
229         // Get coin
230         coin_t coin = shitcoins[shitcoin_index[token] - 1];
231         
232         // Validate coin
233         require(coin.state == COIN_APPROVED);
234         require(amount >= coin.minimum_trade);
235         
236         // Check if we are allowed to secure coins for a deal
237         ERC20 shitcoin = ERC20(coin.base);
238         require(shitcoin.allowance(msg.sender, this) >= amount);
239         
240         // Secure tokens for a deal
241         require(shitcoin.transferFrom(msg.sender, this, amount));
242 
243         // Register an order for further processing by matcher
244         order_book[token].push(order_t(SELL, msg.sender, amount, price, block.number));
245     }
246     
247     function buy(string token, uint256 amount, uint256 price) public {
248         // Basic checks
249         require(stopped == 0);
250         require(total_amount(token, amount, price) == msg.value);
251         require(msg.value >= minimum_trade);
252         
253         // Get coin
254         coin_t coin = shitcoins[shitcoin_index[token] - 1];
255         
256         // Validate coin
257         require(coin.state == COIN_APPROVED);
258         require(amount >= coin.minimum_trade);
259 
260         // Credit ETX to the holder account
261         etx_balances[msg.sender] += msg.value;
262 
263         // Register an order for further processing by matcher
264         order_book[token].push(order_t(BUY, msg.sender, amount, price, block.number));
265     }
266     
267     function trade(string token, uint maker, uint taker) public {
268         // Basic checks
269         require(msg.sender == trader);
270         require(maker < order_book[token].length);
271         require(taker < order_book[token].length);
272         
273         // Get coin
274         coin_t coin = shitcoins[shitcoin_index[token] - 1];
275         
276         // Validate coin
277         require(coin.state == COIN_APPROVED);
278 
279         order_t make = order_book[token][maker];
280         order_t take = order_book[token][taker];
281         uint256 makerFee = 0;
282         uint256 takerFee = 0;
283         uint256 send_to_maker = 0;
284         uint256 send_to_taker = 0;
285         ERC20 shitcoin = ERC20(coin.base);
286         
287         // Check how many coins go into the deal
288         uint256 deal_amount = 0;
289         if (take.amount < make.amount) {
290             deal_amount = take.amount;
291         } else {
292             deal_amount = make.amount;
293         }
294         uint256 total_deal = total_amount(token, deal_amount, make.price);
295         
296         // If maker buys something
297         if (make.buy_sell == BUY) {
298             // Sanity check
299             require(take.price <= make.price);
300             
301             // Calculate fees
302             makerFee = safe_mul(deal_amount, maker_fee) / 10000;
303             takerFee = safe_mul(total_deal, taker_fee) / 10000;
304             
305             // Update accessible fees
306             coin.fee = coin.fee + makerFee;
307             main_fee = main_fee + takerFee;
308             
309             send_to_maker = safe_sub(deal_amount, makerFee);
310             send_to_taker = safe_sub(total_deal, takerFee);
311                 
312             // Move shitcoin to maker
313             require(shitcoin.transfer(make.owner, send_to_maker));
314                 
315             // Deduct from avaialble ETC balance
316             etx_balances[make.owner] = safe_sub(etx_balances[make.owner], total_deal);
317                 
318             // Move funds to taker
319             require(take.owner.send(send_to_taker));
320                 
321         } else {
322             // Sanity check
323             require(take.price >= make.price);
324             
325             // Calculate fees
326             makerFee = safe_mul(total_deal, maker_fee) / 10000;
327             takerFee = safe_mul(deal_amount, taker_fee) / 10000;
328             
329             // Update accessible fees
330             main_fee = main_fee + makerFee;
331             coin.fee = coin.fee + takerFee;
332             
333             send_to_maker = safe_sub(total_deal, makerFee);
334             send_to_taker = safe_sub(deal_amount, takerFee);
335                 
336             // Move shitcoin to taker
337             require(shitcoin.transfer(take.owner, send_to_taker));
338                 
339             // Deduct from avaialble ETC balance
340             etx_balances[take.owner] = safe_sub(etx_balances[take.owner], total_deal);
341                 
342             // Move funds to maker
343             require(make.owner.send(send_to_maker));
344         }
345         
346         // Reduce order size
347         make.amount = safe_sub(make.amount, deal_amount);
348         take.amount = safe_sub(take.amount, deal_amount);
349         
350         // Update price
351         coin.price = make.price;
352     }
353     
354     function cancel(string token, uint256 index) public {
355         // Coin checks
356         coin_t coin = shitcoins[shitcoin_index[token] - 1];
357         order_t order = order_book[token][index];
358 
359         require(coin.state == COIN_APPROVED);
360         require((msg.sender == order.owner) || (msg.sender == owner));
361         require(order.amount > 0);
362         
363         // Null the order
364         uint256 old_amount = order.amount;
365         order.amount = 0;
366 
367         // Return coins
368         if (order.buy_sell == BUY) {
369             // Return back ETC
370             uint256 total_deal = total_amount(token, old_amount, order.price);
371             etx_balances[msg.sender] = safe_sub(etx_balances[msg.sender], total_deal);
372             require(order.owner.send(total_deal));
373         } else {
374             // Return shitcoins back 
375             ERC20 shitcoin = ERC20(coin.base);
376             shitcoin.transfer(order.owner, old_amount);
377         }
378     }
379     
380     function collect_fee(string token) public {
381         require(msg.sender == owner);
382 
383         // Send shitcoins
384         coin_t coin = shitcoins[shitcoin_index[token] - 1];
385         if (coin.fee > 0) {
386             ERC20 shitcoin = ERC20(coin.base);
387             shitcoin.transfer(owner, coin.fee);
388             coin.fee = 0;
389         }
390     }
391     
392     function collect_main_fee() public {
393         require(msg.sender == owner);
394 
395         // Send main currency
396         require(owner.send(main_fee));
397         main_fee = 0;
398     }
399 
400 }