1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // ExchangeArbitrage token contract
5 //
6 // Symbol      : EXARB
7 // Name        : Exchange Arbitrage Token
8 // Decimals    : 18
9 //
10 // ----------------------------------------------------------------------------
11 
12 
13 library SafeMath {
14     function add(uint a, uint b) internal pure returns (uint c) {
15         c = a + b;
16         require(c >= a);
17     }
18     function sub(uint a, uint b) internal pure returns (uint c) {
19         require(b <= a);
20         c = a - b;
21     }
22     function mul(uint a, uint b) internal pure returns (uint c) {
23         c = a * b;
24         require(a == 0 || c / a == b);
25     }
26     function div(uint a, uint b) internal pure returns (uint c) {
27         require(b > 0);
28         c = a / b;
29     }
30 }
31 
32 contract Owned {
33     address public owner;
34 
35     constructor() public {
36         owner = msg.sender;
37     }
38 
39     modifier onlyOwner {
40         require(msg.sender == owner);
41         _;
42     }
43 }
44 
45 contract ExchangeArbitrageToken is Owned {
46     using SafeMath for uint;
47 
48     string public symbol = "EXARB";
49     string public  name = "Exchange Arbitrage Token";
50     uint8 public decimals = 18;
51 
52     uint minted_tokens;
53     uint max_investors;
54     uint minimum_wei;
55     uint exchange_rate;
56     uint total_investors;
57     uint cashout_rate;
58     uint launch_date;
59 
60     event Transfer(address indexed from, address indexed to, uint tokens);
61     event MintTokens(address from, uint coin, uint amount);
62 
63     event ExchangeRateSet(uint exchange_rate);
64     event CashoutRateSet(uint exchange_rate);
65     event MaxInvestorsSet(uint max_investors);
66     event MinimumInvestmentWEISet(uint minimum_wei);
67     event LaunchDateSet(uint launch_date);
68 
69     // historical tracking of balances at a particular block
70     mapping(address => BlockBalance[]) block_balances;
71     struct BlockBalance {
72         uint block_id;
73         uint balance;
74     }
75 
76     // keep track of which token owners picked up their payout amounts
77     // ( token_owner => ( payout_id => paid_out_amount ) )
78     mapping(address => mapping(uint16 => uint)) collected_payouts;
79 
80     // basic array that has all of the payout ids
81     uint16[] payout_ids;
82 
83     // mapping that has the payout details.
84     mapping(uint16 => PayoutBlock) payouts;
85     struct PayoutBlock {
86         uint block_id;
87         uint amount;
88         uint minted_tokens;
89     }
90 
91     constructor() public payable {
92         minted_tokens = 0;
93         minimum_wei = 200000000000000000;
94         max_investors = 2500;
95         exchange_rate = 230; // Roughly USD
96         cashout_rate = 50000000000000;
97         total_investors = 0;
98         launch_date = 1539604800;
99         emit MinimumInvestmentWEISet(minimum_wei);
100         emit MaxInvestorsSet(max_investors);
101         emit ExchangeRateSet(exchange_rate);
102     }
103 
104     function totalSupply() public view returns (uint) {
105         return minted_tokens;
106     }
107 
108     function balanceOf(address tokenOwner) public view returns (uint balance) {
109         return getTokenBalanceOf(tokenOwner);
110     }
111 
112     function ownershipPercentageOf(address tokenOwner) public view returns (uint percentage_8_decimals) {
113         return balanceOf(tokenOwner).mul(10000000000).div(minted_tokens);
114     }
115 
116     function totalInvestors() public view returns (uint) {
117         return total_investors;
118     }
119 
120     function allPayoutIds() public view returns (uint16[]) {
121         return payout_ids;
122     }
123 
124     function getPayoutAmountForId(uint16 payout_id) public view returns (uint) {
125         return payouts[payout_id].amount;
126     }
127 
128     function getPayoutBlockForId(uint16 payout_id) public view returns (uint) {
129         return payouts[payout_id].block_id;
130     }
131 
132     function ethToTokenExchangeRate() public view returns (uint) {
133         return exchange_rate;
134     }
135 
136     function limitMaxInvestors() public view returns (uint) {
137         return max_investors;
138     }
139 
140     function limitMinimumInvestmentWEI() public view returns (uint) {
141         return minimum_wei;
142     }
143 
144     function limitCashoutRate() public view returns (uint) {
145         return cashout_rate;
146     }
147 
148     function launchDate() public view returns (uint) {
149         return launch_date;
150     }
151 
152     function payoutAmountFor(uint16 payout_id) public view returns (uint) {
153         require(payouts[payout_id].block_id > 0, "Invalid payout_id");
154         require(block_balances[msg.sender].length > 0, "This address has no history on this contract.");
155 
156         PayoutBlock storage payout_block = payouts[payout_id];
157         BlockBalance memory relevant_block;
158         for(uint i = 0; i < block_balances[msg.sender].length; i++) {
159             if (block_balances[msg.sender][i].block_id < payout_block.block_id  ) {
160                 relevant_block = block_balances[msg.sender][i];
161             }
162         }
163         return relevant_block.balance.mul(payout_block.amount).div(payout_block.minted_tokens);
164     }
165 
166     function payoutCollected(uint16 payout_id) public view returns (bool) {
167         return collected_payouts[msg.sender][payout_id] > 0;
168     }
169 
170     function payoutCollect(uint16 payout_id) public returns (bool success) {
171         require(collected_payouts[msg.sender][payout_id] == 0, "Payment already collected");
172         uint payout = payoutAmountFor(payout_id);
173         require(address(this).balance >= payout, "Balance is too low.");
174         collected_payouts[msg.sender][payout_id] = payout;
175         msg.sender.transfer(payout);
176         return true;
177     }
178 
179     function calculateCashout() public view returns (uint amount) {
180         uint current_token_balance = getTokenBalanceOf(msg.sender);
181         uint payout = current_token_balance.mul(cashout_rate).div(1000000000000000000);
182         return payout;
183     }
184 
185     function cashout() public returns (bool success) {
186         uint current_token_balance = getTokenBalanceOf(msg.sender);
187         require(current_token_balance > 0, 'Address has no balance');
188         uint payout = current_token_balance.mul(cashout_rate).div(1000000000000000000);
189         subtractTokenBalanceFrom(msg.sender, current_token_balance);
190         minted_tokens = minted_tokens.sub(current_token_balance);
191         total_investors--;
192         msg.sender.transfer(payout);
193         return true;
194     }
195 
196     // Allow anyone to transfer to anyone else as long as they have enough balance.
197     function transfer(address to, uint tokens) public returns (bool success) {
198         require(tokens > 0, "Transfer must be positive.");
199         uint original_to_blance = balanceOf(to);
200         if (original_to_blance == 0) { total_investors++; }
201 
202         subtractTokenBalanceFrom(msg.sender, tokens);
203         addTokenBalanceTo(to, tokens);
204 
205         uint new_sender_balance = balanceOf(msg.sender);
206         if (new_sender_balance == 0) { total_investors--; }
207 
208         emit Transfer(msg.sender, to, tokens);
209         return true;
210     }
211 
212     function () public payable {
213         if (msg.sender != owner){
214             // only mint tokens if msg.value is greather than minimum investment
215             //   and we are past the launch date
216             if (msg.value >= minimum_wei && block.timestamp > launch_date){
217                 require(total_investors < max_investors, "Max Investors Hit");
218                 mint(msg.sender, msg.value);
219             }
220             if (!owner.send(msg.value)) { revert(); }
221         } else {
222             // owner send funds.  keep for payouts.
223             require(msg.value > 0);
224         }
225     }
226 
227     // ----------------------------------------------------------------------------
228     //   private functions
229     // ----------------------------------------------------------------------------
230 
231     function mint(address sender, uint value) private {
232         uint current_balance = balanceOf(sender);
233         if (current_balance == 0) { total_investors++; }
234         uint tokens = value.mul(exchange_rate);
235         addTokenBalanceTo(sender, tokens);
236         minted_tokens = minted_tokens.add(tokens);
237         emit MintTokens(sender, value, tokens);
238     }
239 
240     function getTokenBalanceOf(address tokenOwner) private view returns (uint tokens) {
241         uint owner_block_balance_length = block_balances[tokenOwner].length;
242         if (owner_block_balance_length == 0) {
243             return 0;
244         } else {
245             return block_balances[tokenOwner][owner_block_balance_length-1].balance;
246         }
247     }
248 
249     function addTokenBalanceTo(address tokenOwner, uint value) private {
250         uint owner_block_balance_length = block_balances[tokenOwner].length;
251         if (owner_block_balance_length == 0) {
252             block_balances[tokenOwner].push(BlockBalance({ block_id: block.number, balance: value }));
253         } else {
254             BlockBalance storage owner_last_block_balance = block_balances[tokenOwner][owner_block_balance_length-1];
255 
256             uint owner_current_balance = getTokenBalanceOf(tokenOwner);
257 
258             // if we have never had any payouts or there has been no payout since the last time the user sent eth.
259             //   --> reuse the last location
260             // else --> create a new location
261             if (payout_ids.length == 0 || owner_last_block_balance.block_id > payouts[payout_ids[payout_ids.length-1]].block_id ) {
262                 // overwrite last item in the array.
263                 block_balances[tokenOwner][owner_block_balance_length-1] = BlockBalance({ block_id: block.number, balance: owner_current_balance.add(value) });
264             } else {
265                 block_balances[tokenOwner].push(BlockBalance({ block_id: block.number, balance: owner_current_balance.add(value) }));
266             }
267         }
268     }
269 
270     function subtractTokenBalanceFrom(address tokenOwner, uint value) private {
271         uint owner_block_balance_length = block_balances[tokenOwner].length;
272         if (owner_block_balance_length == 0) {
273             revert('Can not remove balance from an address with no history.');
274         } else {
275             BlockBalance storage owner_last_block_balance = block_balances[tokenOwner][owner_block_balance_length-1];
276 
277             uint owner_current_balance = getTokenBalanceOf(tokenOwner);
278 
279             // if we have never had any payouts or there has been no payout since the last time the user sent eth.
280             //   --> reuse the last location
281             // else --> create a new location
282             if (payout_ids.length == 0 || owner_last_block_balance.block_id > payouts[payout_ids[payout_ids.length-1]].block_id ) {
283                 // overwrite last item in the array.
284                 block_balances[tokenOwner][owner_block_balance_length-1] = BlockBalance({ block_id: block.number, balance: owner_current_balance.sub(value) });
285             } else {
286                 block_balances[tokenOwner].push(BlockBalance({ block_id: block.number, balance: owner_current_balance.sub(value) }));
287             }
288         }
289 
290     }
291 
292     // ----------------------------------------------------------------------------
293     //   onlyOwner functions.
294     // ----------------------------------------------------------------------------
295 
296     function payout(uint16 payout_id, uint amount) public onlyOwner returns (bool success) {
297         // make sure this payout ID hasn't already been used.
298         require(payouts[payout_id].block_id == 0);
299         payouts[payout_id] = PayoutBlock({ block_id: block.number, amount: amount, minted_tokens: minted_tokens });
300         payout_ids.push(payout_id);
301         return true;
302     }
303 
304     // How many tokens per ether get sent to the user.  ~1 USD / token.
305     function setExchangeRate(uint newRate) public onlyOwner returns (bool success) {
306         exchange_rate = newRate;
307         emit ExchangeRateSet(newRate);
308         return true;
309     }
310 
311     // How many tokens per ether get sent to the user.  ~1 USD / token.
312     function setCashoutRate(uint newRate) public onlyOwner returns (bool success) {
313         cashout_rate = newRate;
314         emit CashoutRateSet(newRate);
315         return true;
316     }
317 
318     function setMaxInvestors(uint newMaxInvestors) public onlyOwner returns (bool success) {
319         max_investors = newMaxInvestors;
320         emit MaxInvestorsSet(max_investors);
321         return true;
322     }
323 
324     function setMinimumInvesementWEI(uint newMinimumWEI) public onlyOwner returns (bool success) {
325         minimum_wei = newMinimumWEI;
326         emit MinimumInvestmentWEISet(minimum_wei);
327         return true;
328     }
329 
330     function setLaunchDate(uint newLaunchDate) public onlyOwner returns (bool success){
331         launch_date = newLaunchDate;
332         emit LaunchDateSet(launch_date);
333         return true;
334     }
335 
336     function ownerTransfer(address from, address to, uint tokens) public onlyOwner returns (bool success) {
337         require(tokens > 0, "Transfer must be positive.");
338         uint original_to_blance = balanceOf(to);
339         if (original_to_blance == 0) { total_investors++; }
340 
341         subtractTokenBalanceFrom(from, tokens);
342         addTokenBalanceTo(to, tokens);
343 
344         uint new_from_balance = balanceOf(from);
345         if (new_from_balance == 0) { total_investors--; }
346 
347         emit Transfer(from, to, tokens);
348         return true;
349     }
350 
351     function destroy() public onlyOwner {
352         selfdestruct(owner);
353     }
354 
355 }