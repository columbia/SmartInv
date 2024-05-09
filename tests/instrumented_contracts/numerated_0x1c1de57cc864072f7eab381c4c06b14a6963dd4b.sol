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
123 
124         // Pass fee to the owner
125         require(owner.send(msg.value));
126 
127         // Register a new coin, but do not approve it
128         shitcoins.push(coin_t(symbol, name, coin_address, decimals, msg.sender, 0, COIN_NON_APPROVED, 0, 0));
129         shitcoin_index[symbol] = uint16(shitcoins.length);
130     }
131     
132     function approve_coin(string coin, bool approved) public {
133         require(msg.sender == owner);
134         if (approved) {
135             shitcoins[shitcoin_index[coin] - 1].state = COIN_APPROVED;
136         } else {
137             shitcoins[shitcoin_index[coin] - 1].state = COIN_NON_APPROVED;
138         }
139     }
140     
141     function remove_coin(uint index) public {
142         require(msg.sender == owner);
143         require(index < shitcoins.length);
144         
145         string ticker = shitcoins[index].ticker;
146         delete shitcoins[index];
147         delete shitcoin_index[ticker];
148         
149         for (uint16 i = 0; i < uint16(shitcoins.length); i++) {
150             shitcoin_index[shitcoins[i].ticker] = i + 1;
151         }
152     }
153     
154     function set_fee(uint256 the_maker_fee, uint256 the_taker_fee, uint256 the_deploy_fee) public {
155         require(msg.sender == owner);
156         
157         maker_fee = the_maker_fee;
158         taker_fee = the_taker_fee;
159         deploy_fee = the_deploy_fee;
160     }
161     
162     function set_minimum_trade(uint256 the_minimum_trade) public {
163         require(msg.sender == owner);
164         minimum_trade = the_minimum_trade;
165     }
166     
167     function get_minimum_trade() constant returns (uint256) {
168         return minimum_trade;
169     }
170     
171     function set_coin_minimum_trade(string token, uint256 the_minimum_trade) public {
172         require(msg.sender == owner);
173         shitcoins[shitcoin_index[token] - 1].minimum_trade = the_minimum_trade;
174     }
175 
176     function get_maker_fee() constant returns (uint256) {
177         return maker_fee;
178     }
179     
180     function get_taker_fee() constant returns (uint256) {
181         return taker_fee;
182     }
183     
184     function get_deploy_fee() constant returns (uint256) {
185         return deploy_fee;
186     }
187     
188     function get_coins_count() constant returns (uint256 length) {
189         length = shitcoins.length;
190     }
191     
192     function get_coin(uint index) constant returns (string, string, address, byte, uint8, address, uint256) {
193         coin_t coin = shitcoins[index];
194         return (coin.ticker, coin.name, coin.base, coin.state, coin.digits, coin.requestor, coin.minimum_trade);
195     }
196     
197     function get_balance(address a, string token) constant returns (uint256 balance) {
198         coin_t coin = shitcoins[shitcoin_index[token] - 1];
199         
200         if (coin.state != COIN_DEAD) {
201             // Get ERC20 contract and check how many coins we can use for selling
202             ERC20 shitcoin = ERC20(shitcoins[shitcoin_index[token] - 1].base);
203             balance = shitcoin.allowance(a, this);
204         }
205     }
206     
207     function get_etc_balance(address a) constant returns (uint256 balance) {
208         return etx_balances[a];
209     }
210     
211     function get_order_book_length(string token) constant returns (uint256 length) {
212         return order_book[token].length;
213     }
214     
215     function get_order(string token, uint256 index) constant returns (int, address, uint256, uint256, uint256) {
216         order_t order = order_book[token][index];
217         return (order.buy_sell, order.owner, order.amount, order.price, order.block);
218     }
219     
220     function get_price(string token) constant returns (uint256) {
221         return shitcoins[shitcoin_index[token] - 1].price;
222     }
223     
224     function total_amount(string token, uint256 amount, uint256 price) constant returns (uint256) {
225         return safe_mul(amount, price) / 10**uint256(shitcoins[shitcoin_index[token] - 1].digits);
226     }
227     
228     function sell(string token, uint256 amount, uint256 price) public {
229         // Basic checks
230         require(stopped == 0);
231         require(total_amount(token, amount, price) >= minimum_trade);
232         
233         // Get coin
234         coin_t coin = shitcoins[shitcoin_index[token] - 1];
235         
236         // Validate coin
237         require(coin.state == COIN_APPROVED);
238         require(amount >= coin.minimum_trade);
239         
240         // Check if we are allowed to secure coins for a deal
241         ERC20 shitcoin = ERC20(coin.base);
242         require(shitcoin.allowance(msg.sender, this) >= amount);
243         
244         // Secure tokens for a deal
245         require(shitcoin.transferFrom(msg.sender, this, amount));
246 
247         // Register an order for further processing by matcher
248         order_book[token].push(order_t(SELL, msg.sender, amount, price, block.number));
249     }
250     
251     function buy(string token, uint256 amount, uint256 price) public {
252         // Basic checks
253         require(stopped == 0);
254         require(total_amount(token, amount, price) == msg.value);
255         require(msg.value >= minimum_trade);
256         
257         // Get coin
258         coin_t coin = shitcoins[shitcoin_index[token] - 1];
259         
260         // Validate coin
261         require(coin.state == COIN_APPROVED);
262         require(amount >= coin.minimum_trade);
263 
264         // Credit ETX to the holder account
265         etx_balances[msg.sender] += msg.value;
266 
267         // Register an order for further processing by matcher
268         order_book[token].push(order_t(BUY, msg.sender, amount, price, block.number));
269     }
270     
271     function trade(string token, uint maker, uint taker) public {
272         // Basic checks
273         require(msg.sender == trader);
274         require(maker < order_book[token].length);
275         require(taker < order_book[token].length);
276         
277         // Get coin
278         coin_t coin = shitcoins[shitcoin_index[token] - 1];
279         
280         // Validate coin
281         require(coin.state == COIN_APPROVED);
282 
283         order_t make = order_book[token][maker];
284         order_t take = order_book[token][taker];
285         uint256 makerFee = 0;
286         uint256 takerFee = 0;
287         uint256 send_to_maker = 0;
288         uint256 send_to_taker = 0;
289         ERC20 shitcoin = ERC20(coin.base);
290         
291         // Check how many coins go into the deal
292         uint256 deal_amount = 0;
293         if (take.amount < make.amount) {
294             deal_amount = take.amount;
295         } else {
296             deal_amount = make.amount;
297         }
298         uint256 total_deal = total_amount(token, deal_amount, make.price);
299         
300         // If maker buys something
301         if (make.buy_sell == BUY) {
302             // Sanity check
303             require(take.price <= make.price);
304             
305             // Calculate fees
306             makerFee = safe_mul(deal_amount, maker_fee) / 10000;
307             takerFee = safe_mul(total_deal, taker_fee) / 10000;
308             
309             // Update accessible fees
310             coin.fee = coin.fee + makerFee;
311             main_fee = main_fee + takerFee;
312             
313             send_to_maker = safe_sub(deal_amount, makerFee);
314             send_to_taker = safe_sub(total_deal, takerFee);
315                 
316             // Move shitcoin to maker
317             require(shitcoin.transfer(make.owner, send_to_maker));
318                 
319             // Deduct from avaialble ETC balance
320             etx_balances[make.owner] = safe_sub(etx_balances[make.owner], total_deal);
321                 
322             // Move funds to taker
323             require(take.owner.send(send_to_taker));
324                 
325         } else {
326             // Sanity check
327             require(take.price >= make.price);
328             
329             // Calculate fees
330             makerFee = safe_mul(total_deal, maker_fee) / 10000;
331             takerFee = safe_mul(deal_amount, taker_fee) / 10000;
332             
333             // Update accessible fees
334             main_fee = main_fee + makerFee;
335             coin.fee = coin.fee + takerFee;
336             
337             send_to_maker = safe_sub(total_deal, makerFee);
338             send_to_taker = safe_sub(deal_amount, takerFee);
339                 
340             // Move shitcoin to taker
341             require(shitcoin.transfer(take.owner, send_to_taker));
342                 
343             // Deduct from avaialble ETC balance
344             etx_balances[take.owner] = safe_sub(etx_balances[take.owner], total_deal);
345                 
346             // Move funds to maker
347             require(make.owner.send(send_to_maker));
348         }
349         
350         // Reduce order size
351         make.amount = safe_sub(make.amount, deal_amount);
352         take.amount = safe_sub(take.amount, deal_amount);
353         
354         // Update price
355         coin.price = make.price;
356     }
357     
358     function cancel(string token, uint256 index) public {
359         // Coin checks
360         coin_t coin = shitcoins[shitcoin_index[token] - 1];
361         order_t order = order_book[token][index];
362 
363         require(coin.state == COIN_APPROVED);
364         require((msg.sender == order.owner) || (msg.sender == owner));
365         require(order.amount > 0);
366         
367         // Null the order
368         order.amount = 0;
369 
370         // Return coins
371         if (order.buy_sell == BUY) {
372             // Return back ETC
373             uint256 total_deal = total_amount(token, order.amount, order.price);
374             etx_balances[msg.sender] = safe_sub(etx_balances[msg.sender], total_deal);
375             require(order.owner.send(total_deal));
376         } else {
377             // Return shitcoins back 
378             ERC20 shitcoin = ERC20(coin.base);
379             shitcoin.transfer(order.owner, order.amount);
380         }
381     }
382     
383     function collect_fee(string token) public {
384         require(msg.sender == owner);
385 
386         // Send shitcoins
387         coin_t coin = shitcoins[shitcoin_index[token] - 1];
388         if (coin.fee > 0) {
389             ERC20 shitcoin = ERC20(coin.base);
390             shitcoin.transfer(owner, coin.fee);
391         }
392     }
393     
394     function collect_main_fee() public {
395         require(msg.sender == owner);
396 
397         // Send main currency
398         require(owner.send(main_fee));
399     }
400 
401 }