1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4 
5   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
6     assert(b <= a);
7     return a - b;
8   }
9 
10   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
11     c = a + b;
12     assert(c >= a);
13     return c;
14   }
15 
16   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
17     if (a == 0) {
18       return 0;
19     }
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     return a / b;
27   }
28   
29 }
30 
31 contract Token {
32  
33   function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
34 
35   function transfer(address to, uint256 tokens) public returns (bool success);
36      
37 }
38 
39 contract TokenLiquidityContract { 
40 
41   using SafeMath for uint256;  
42 
43 
44   address public admin;
45 
46   address public traded_token;
47 
48   
49   uint256 public eth_seed_amount;
50 
51   uint256 public traded_token_seed_amount;
52   
53   uint256 public commission_ratio;
54 
55   uint256 public eth_balance;
56 
57   uint256 public traded_token_balance;
58 
59 
60   bool public eth_is_seeded;
61 
62   bool public traded_token_is_seeded;
63   
64   bool public trading_deactivated;
65 
66   bool public admin_commission_activated;
67 
68 
69   modifier only_admin() {
70       require(msg.sender == admin);
71       _;
72   }
73   
74   modifier trading_activated() {
75       require(trading_deactivated == false);
76       _;
77   }
78 
79   
80   constructor(address _traded_token,uint256 _eth_seed_amount, uint256 _traded_token_seed_amount, uint256 _commission_ratio) public {
81       
82     admin = tx.origin;  
83     
84     traded_token = _traded_token;
85     
86     eth_seed_amount = _eth_seed_amount;
87     
88     traded_token_seed_amount = _traded_token_seed_amount;
89 
90     commission_ratio = _commission_ratio;
91     
92   }
93   
94   function transferTokensThroughProxyToContract(address _from, address _to, uint256 _amount) private {
95 
96     traded_token_balance = traded_token_balance.add(_amount);
97 
98     require(Token(traded_token).transferFrom(_from,_to,_amount));
99      
100   }  
101 
102   function transferTokensFromContract(address _to, uint256 _amount) private {
103 
104     traded_token_balance = traded_token_balance.sub(_amount);
105 
106     require(Token(traded_token).transfer(_to,_amount));
107      
108   }
109 
110   function transferETHToContract() private {
111 
112     eth_balance = eth_balance.add(msg.value);
113       
114   }
115   
116   function transferETHFromContract(address _to, uint256 _amount) private {
117 
118     eth_balance = eth_balance.sub(_amount);
119       
120     _to.transfer(_amount);
121       
122   }
123   
124   function deposit_token(uint256 _amount) private { 
125 
126     transferTokensThroughProxyToContract(msg.sender, this, _amount);
127 
128   }  
129 
130   function deposit_eth() private { 
131 
132     transferETHToContract();
133 
134   }  
135   
136   function withdraw_token(uint256 _amount) public only_admin() {
137 
138     transferTokensFromContract(admin, _amount);
139       
140   }
141   
142   function withdraw_eth(uint256 _amount) public only_admin() {
143       
144     transferETHFromContract(admin, _amount);
145       
146   }
147 
148   function set_traded_token_as_seeded() private {
149    
150     traded_token_is_seeded = true;
151  
152   }
153 
154   function set_eth_as_seeded() private {
155 
156     eth_is_seeded = true;
157 
158   }
159 
160   function seed_traded_token() public only_admin() {
161 
162     require(!traded_token_is_seeded);
163   
164     set_traded_token_as_seeded();
165 
166     deposit_token(traded_token_seed_amount); 
167 
168   }
169   
170   function seed_eth() public payable only_admin() {
171 
172     require(!eth_is_seeded);
173 
174     require(msg.value == eth_seed_amount);
175  
176     set_eth_as_seeded();
177 
178     deposit_eth(); 
179 
180   }
181 
182   function seed_additional_token(uint256 _amount) public only_admin() {
183 
184     require(market_is_open());
185     
186     deposit_token(_amount);
187 
188   }
189 
190   function seed_additional_eth() public payable only_admin() {
191   
192     require(market_is_open());
193     
194     deposit_eth();
195 
196   }
197 
198   function market_is_open() private view returns(bool) {
199   
200     return (eth_is_seeded && traded_token_is_seeded);
201 
202   }
203 
204   function deactivate_trading() public only_admin() {
205   
206     require(!trading_deactivated);
207     
208     trading_deactivated = true;
209 
210   }
211   
212   function reactivate_trading() public only_admin() {
213       
214     require(trading_deactivated);
215     
216     trading_deactivated = false;
217     
218   }
219 
220   function get_amount_sell(uint256 _amount) public view returns(uint256) {
221  
222     uint256 traded_token_balance_plus_amount_ = traded_token_balance.add(_amount);
223     
224     return (eth_balance.mul(_amount)).div(traded_token_balance_plus_amount_);
225     
226   }
227 
228   function get_amount_buy(uint256 _amount) public view returns(uint256) {
229 
230     uint256 eth_balance_plus_amount_ = eth_balance.add(_amount);
231 
232     return (traded_token_balance.mul(_amount)).div(eth_balance_plus_amount_);
233 
234   }
235   
236   function get_amount_minus_commission(uint256 _amount) private view returns(uint256) {
237       
238     return (_amount*(1 ether - commission_ratio))/(1 ether);  
239     
240   }
241 
242   function activate_admin_commission() public only_admin() {
243 
244     require(!admin_commission_activated);
245 
246     admin_commission_activated = true;
247 
248   }
249 
250   function deactivate_admin_comission() public only_admin() {
251 
252     require(admin_commission_activated);
253 
254     admin_commission_activated = false;
255 
256   }
257 
258   function change_admin_commission(uint256 _new_commission_ratio) public only_admin() {
259   
260      require(_new_commission_ratio != commission_ratio);
261 
262      commission_ratio = _new_commission_ratio;
263 
264   }
265 
266 
267   function complete_sell_exchange(uint256 _amount_give) private {
268 
269     uint256 amount_get_ = get_amount_sell(_amount_give);
270 
271     uint256 amount_get_minus_commission_ = get_amount_minus_commission(amount_get_);
272     
273     transferTokensThroughProxyToContract(msg.sender,this,_amount_give);
274 
275     transferETHFromContract(msg.sender,amount_get_minus_commission_);  
276 
277     if(admin_commission_activated) {
278 
279       uint256 admin_commission_ = amount_get_ - amount_get_minus_commission_;
280 
281       transferETHFromContract(admin, admin_commission_);     
282 
283     }
284     
285   }
286   
287   function complete_buy_exchange() private {
288 
289     uint256 amount_give_ = msg.value;
290 
291     uint256 amount_get_ = get_amount_buy(amount_give_);
292 
293     uint256 amount_get_minus_commission_ = get_amount_minus_commission(amount_get_);
294 
295     transferETHToContract();
296 
297     transferTokensFromContract(msg.sender, amount_get_minus_commission_);
298 
299     if(admin_commission_activated) {
300 
301       uint256 admin_commission_ = amount_get_ - amount_get_minus_commission_;
302 
303       transferTokensFromContract(admin, admin_commission_);
304 
305     }
306     
307   }
308   
309   function sell_tokens(uint256 _amount_give) public trading_activated() {
310 
311     require(market_is_open());
312 
313     complete_sell_exchange(_amount_give);
314 
315   }
316   
317   function buy_tokens() private trading_activated() {
318 
319     require(market_is_open());
320 
321     complete_buy_exchange();
322 
323   }
324 
325 
326   function() public payable {
327 
328     buy_tokens();
329 
330   }
331 
332 }