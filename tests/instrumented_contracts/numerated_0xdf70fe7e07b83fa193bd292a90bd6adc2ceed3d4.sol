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
49     string public name = "Exchange Arbitrage Token";
50     uint8 public decimals = 18;
51 
52     uint minted_tokens;
53     uint exchange_rate;
54     uint max_minted_supply;
55     uint cash_out_rate;
56 
57     mapping(address => mapping (address => uint)) allowed;
58 
59     event Transfer(address indexed from, address indexed to, uint tokens);
60     event MintTokens(address from, uint amount);
61 
62     event ExchangeRateSet(uint exchange_rate);
63     event CashOutRateSet(uint exchange_rate);
64     event MaxMintedSupplySet(uint max_minted_supply);
65     event Approval(address tokenOwner, address spender, uint tokens);
66 
67     // historical tracking of balances at a particular block
68     mapping(address => BlockBalance[]) block_balances;
69     struct BlockBalance {
70         uint block_id;
71         uint balance;
72     }
73 
74     // keep track of which token owners picked up their payout amounts
75     // ( token_owner => ( payout_id => paid_out_amount ) )
76     mapping(address => mapping(uint16 => uint)) collected_payouts;
77 
78     // basic array that has all of the payout ids
79     uint16[] payout_ids;
80 
81     // mapping that has the payout details.
82     mapping(uint16 => PayoutBlock) payouts;
83     struct PayoutBlock {
84         uint block_id;
85         uint amount;
86         uint minted_tokens;
87     }
88 
89     constructor() public payable {
90         minted_tokens = 0;
91         exchange_rate = 210;
92         cash_out_rate = 50000000000000;
93         max_minted_supply = 450000000000000000000000;
94         emit MaxMintedSupplySet(max_minted_supply);
95         emit CashOutRateSet(cash_out_rate);
96         emit ExchangeRateSet(exchange_rate);
97     }
98 
99     function totalSupply() public view returns (uint) {
100         return minted_tokens;
101     }
102 
103     function balanceOf(address tokenOwner) public view returns (uint balance) {
104         return getTokenBalanceOf(tokenOwner);
105     }
106 
107     function allowance(address tokenOwner, address spender) public constant returns(uint remaining){
108         return allowed[tokenOwner][spender];
109     }
110 
111     function approve(address spender, uint tokens) public returns (bool success) {
112         allowed[msg.sender][spender] = tokens;
113         emit Approval(msg.sender, spender, tokens);
114         return true;
115     }
116 
117     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
118         require(tokens > 0, "Transfer must be positive.");
119         require(allowed[from][msg.sender] >= tokens, "Not enough allowed tokens.");
120         subtractTokenBalanceFrom(from, tokens);
121         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
122         addTokenBalanceTo(to, tokens);
123         emit Transfer(from, to, tokens);
124         return true;
125     }
126 
127     function ownershipPercentageOf(address tokenOwner) public view returns (uint percentage_8_decimals) {
128         return balanceOf(tokenOwner).mul(10000000000).div(minted_tokens);
129     }
130 
131     function allPayoutIds() public view returns (uint16[]) {
132         return payout_ids;
133     }
134 
135     function getPayoutAmountForId(uint16 payout_id) public view returns (uint) {
136         return payouts[payout_id].amount;
137     }
138 
139     function getPayoutBlockForId(uint16 payout_id) public view returns (uint) {
140         return payouts[payout_id].block_id;
141     }
142 
143     function ethToTokenExchangeRate() public view returns (uint) {
144         return exchange_rate;
145     }
146 
147     function limitMintedSupply() public view returns (uint) {
148         return max_minted_supply;
149     }
150 
151     function limitCashOutRate() public view returns (uint) {
152         return cash_out_rate;
153     }
154 
155     function payoutAmountFor(uint16 payout_id) public view returns (uint) {
156         require(payouts[payout_id].block_id > 0, "Invalid payout_id");
157         require(block_balances[msg.sender].length > 0, "This address has no history on this contract.");
158 
159         PayoutBlock storage payout_block = payouts[payout_id];
160         BlockBalance memory relevant_block;
161         for(uint i = 0; i < block_balances[msg.sender].length; i++) {
162             if (block_balances[msg.sender][i].block_id < payout_block.block_id  ) {
163                 relevant_block = block_balances[msg.sender][i];
164             }
165         }
166         return relevant_block.balance.mul(payout_block.amount).div(payout_block.minted_tokens);
167     }
168 
169     function payoutCollected(uint16 payout_id) public view returns (bool) {
170         return collected_payouts[msg.sender][payout_id] > 0;
171     }
172 
173     function payoutCollect(uint16 payout_id) public returns (bool success) {
174         require(collected_payouts[msg.sender][payout_id] == 0, "Payment already collected");
175         uint payout = payoutAmountFor(payout_id);
176         require(address(this).balance >= payout, "Balance is too low.");
177         collected_payouts[msg.sender][payout_id] = payout;
178         msg.sender.transfer(payout);
179         return true;
180     }
181 
182     function calculateCashOut() public view returns (uint amount) {
183         uint current_token_balance = getTokenBalanceOf(msg.sender);
184         uint payout = current_token_balance.mul(cash_out_rate).div(1000000000000000000);
185         return payout;
186     }
187 
188     function cashOut() public returns (bool success) {
189         uint current_token_balance = getTokenBalanceOf(msg.sender);
190         require(current_token_balance > 0, 'Address has no balance');
191         uint payout = current_token_balance.mul(cash_out_rate).div(1000000000000000000);
192         subtractTokenBalanceFrom(msg.sender, current_token_balance);
193         minted_tokens = minted_tokens.sub(current_token_balance);
194         msg.sender.transfer(payout);
195         return true;
196     }
197 
198     // Allow anyone to transfer to anyone else as long as they have enough balance.
199     function transfer(address to, uint tokens) public returns (bool success) {
200         require(tokens > 0, "Transfer must be positive.");
201 
202         subtractTokenBalanceFrom(msg.sender, tokens);
203         addTokenBalanceTo(to, tokens);
204 
205         emit Transfer(msg.sender, to, tokens);
206         return true;
207     }
208 
209     function () public payable {
210         if (msg.sender != owner){
211             require(msg.value.mul(exchange_rate) + minted_tokens < max_minted_supply, "Contract Fully Funded.  Try again later.");
212             mint(msg.sender, msg.value);
213             if (!owner.send(msg.value)) { revert(); }
214         } else {
215             require(msg.value > 0);  // owner sent funds.  keep on contract for payouts.
216         }
217     }
218 
219     // ----------------------------------------------------------------------------
220     //   private functions
221     // ----------------------------------------------------------------------------
222 
223     function mint(address sender, uint value) private {
224         uint tokens = value.mul(exchange_rate);
225         addTokenBalanceTo(sender, tokens);
226         minted_tokens = minted_tokens.add(tokens);
227         emit MintTokens(sender, tokens);
228     }
229 
230     function getTokenBalanceOf(address tokenOwner) private view returns (uint tokens) {
231         uint owner_block_balance_length = block_balances[tokenOwner].length;
232         if (owner_block_balance_length == 0) {
233             return 0;
234         } else {
235             return block_balances[tokenOwner][owner_block_balance_length-1].balance;
236         }
237     }
238 
239     function addTokenBalanceTo(address tokenOwner, uint value) private {
240         uint owner_block_balance_length = block_balances[tokenOwner].length;
241         if (owner_block_balance_length == 0) {
242             block_balances[tokenOwner].push(BlockBalance({ block_id: block.number, balance: value }));
243         } else {
244             BlockBalance storage owner_last_block_balance = block_balances[tokenOwner][owner_block_balance_length-1];
245 
246             uint owner_current_balance = getTokenBalanceOf(tokenOwner);
247 
248             // if we have never had any payouts or there has been no payout since the last time the user sent eth.
249             //   --> reuse the last location
250             // else --> create a new location
251             if (payout_ids.length == 0 || owner_last_block_balance.block_id > payouts[payout_ids[payout_ids.length-1]].block_id ) {
252                 // overwrite last item in the array.
253                 block_balances[tokenOwner][owner_block_balance_length-1] = BlockBalance({ block_id: block.number, balance: owner_current_balance.add(value) });
254             } else {
255                 block_balances[tokenOwner].push(BlockBalance({ block_id: block.number, balance: owner_current_balance.add(value) }));
256             }
257         }
258     }
259 
260     function subtractTokenBalanceFrom(address tokenOwner, uint value) private {
261         uint owner_block_balance_length = block_balances[tokenOwner].length;
262         if (owner_block_balance_length == 0) {
263             revert('Can not remove balance from an address with no history.');
264         } else {
265             BlockBalance storage owner_last_block_balance = block_balances[tokenOwner][owner_block_balance_length-1];
266 
267             uint owner_current_balance = getTokenBalanceOf(tokenOwner);
268 
269             // if we have never had any payouts or there has been no payout since the last time the user sent eth.
270             //   --> reuse the last location
271             // else --> create a new location
272             if (payout_ids.length == 0 || owner_last_block_balance.block_id > payouts[payout_ids[payout_ids.length-1]].block_id ) {
273                 // overwrite last item in the array.
274                 block_balances[tokenOwner][owner_block_balance_length-1] = BlockBalance({ block_id: block.number, balance: owner_current_balance.sub(value) });
275             } else {
276                 block_balances[tokenOwner].push(BlockBalance({ block_id: block.number, balance: owner_current_balance.sub(value) }));
277             }
278         }
279 
280     }
281 
282     // ----------------------------------------------------------------------------
283     //   onlyOwner functions.
284     // ----------------------------------------------------------------------------
285 
286     function payout(uint16 payout_id, uint amount) public onlyOwner returns (bool success) {
287         require(payouts[payout_id].block_id == 0);
288         payouts[payout_id] = PayoutBlock({ block_id: block.number, amount: amount, minted_tokens: minted_tokens });
289         payout_ids.push(payout_id);
290         return true;
291     }
292 
293     function setExchangeRate(uint newRate) public onlyOwner returns (bool success) {
294         exchange_rate = newRate;
295         emit ExchangeRateSet(newRate);
296         return true;
297     }
298 
299     function setCashOutRate(uint newRate) public onlyOwner returns (bool success) {
300         cash_out_rate = newRate;
301         emit CashOutRateSet(newRate);
302         return true;
303     }
304 
305     function setMaxMintedSupply(uint newMaxMintedSupply) public onlyOwner returns (bool success) {
306         max_minted_supply = newMaxMintedSupply;
307         emit MaxMintedSupplySet(max_minted_supply);
308         return true;
309     }
310 
311     function ownerTransfer(address from, address to, uint tokens) public onlyOwner returns (bool success) {
312         require(tokens > 0, "Transfer must be positive.");
313 
314         subtractTokenBalanceFrom(from, tokens);
315         addTokenBalanceTo(to, tokens);
316 
317         emit Transfer(from, to, tokens);
318         return true;
319     }
320 
321     function ownerMint(address to, uint tokens) public onlyOwner returns (bool success) {
322         addTokenBalanceTo(to, tokens);
323         minted_tokens = minted_tokens.add(tokens);
324         emit MintTokens(to, tokens);
325         return true;
326     }
327 
328     function destroy() public onlyOwner {
329         selfdestruct(owner);
330     }
331 
332 }