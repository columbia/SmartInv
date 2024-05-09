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
16 }
17 
18 contract Token {
19  
20   function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
21 
22   function transfer(address to, uint256 tokens) public returns (bool success);
23      
24 }
25 
26 contract TokenLiquidityContract { 
27 
28   using SafeMath for uint256;  
29 
30 
31   address public admin;
32 
33   address public traded_token;
34 
35   
36   uint256 public eth_seed_amount;
37 
38   uint256 public traded_token_seed_amount;
39   
40   uint256 public commission_ratio;
41 
42   uint256 public eth_balance;
43 
44   uint256 public traded_token_balance;
45 
46 
47   bool public eth_is_seeded;
48 
49   bool public traded_token_is_seeded;
50   
51   bool public trading_deactivated;
52 
53   bool public admin_commission_activated;
54 
55 
56   modifier only_admin() {
57       require(msg.sender == admin);
58       _;
59   }
60   
61   modifier trading_activated() {
62       require(trading_deactivated == false);
63       _;
64   }
65 
66   
67   constructor(address _traded_token,uint256 _eth_seed_amount, uint256 _traded_token_seed_amount, uint256 _commission_ratio) public {
68       
69     admin = tx.origin;  
70     
71     traded_token = _traded_token;
72     
73     eth_seed_amount = _eth_seed_amount;
74     
75     traded_token_seed_amount = _traded_token_seed_amount;
76 
77     commission_ratio = _commission_ratio;
78     
79   }
80   
81   function transferTokensThroughProxyToContract(address _from, address _to, uint256 _amount) private {
82 
83     traded_token_balance = traded_token_balance.add(_amount);
84 
85     require(Token(traded_token).transferFrom(_from,_to,_amount));
86      
87   }  
88 
89   function transferTokensFromContract(address _to, uint256 _amount) private {
90 
91     traded_token_balance = traded_token_balance.sub(_amount);
92 
93     require(Token(traded_token).transfer(_to,_amount));
94      
95   }
96 
97   function transferETHToContract() private {
98 
99     eth_balance = eth_balance.add(msg.value);
100       
101   }
102   
103   function transferETHFromContract(address _to, uint256 _amount) private {
104 
105     eth_balance = eth_balance.sub(_amount);
106       
107     _to.transfer(_amount);
108       
109   }
110   
111   function deposit_token(uint256 _amount) private { 
112 
113     transferTokensThroughProxyToContract(msg.sender, this, _amount);
114 
115   }  
116 
117   function deposit_eth() private { 
118 
119     transferETHToContract();
120 
121   }  
122   
123   function withdraw_token(uint256 _amount) public only_admin {
124 
125     transferTokensFromContract(admin, _amount);
126       
127   }
128   
129   function withdraw_eth(uint256 _amount) public only_admin {
130       
131     transferETHFromContract(admin, _amount);
132       
133   }
134 
135   function set_traded_token_as_seeded() private {
136    
137     traded_token_is_seeded = true;
138  
139   }
140 
141   function set_eth_as_seeded() private {
142 
143     eth_is_seeded = true;
144 
145   }
146 
147   function seed_traded_token() public only_admin {
148 
149     require(!traded_token_is_seeded);
150   
151     set_traded_token_as_seeded();
152 
153     deposit_token(traded_token_seed_amount); 
154 
155   }
156   
157   function seed_eth() public payable only_admin {
158 
159     require(!eth_is_seeded);
160 
161     require(msg.value == eth_seed_amount);
162  
163     set_eth_as_seeded();
164 
165     deposit_eth(); 
166 
167   }
168 
169   function seed_additional_token(uint256 _amount) public only_admin {
170 
171     require(market_is_open());
172     
173     deposit_token(_amount);
174 
175   }
176 
177   function seed_additional_eth() public payable only_admin {
178   
179     require(market_is_open());
180     
181     deposit_eth();
182 
183   }
184 
185   function market_is_open() private view returns(bool) {
186   
187     return (eth_is_seeded && traded_token_is_seeded);
188 
189   }
190 
191   function deactivate_trading() public only_admin {
192   
193     require(!trading_deactivated);
194     
195     trading_deactivated = true;
196 
197   }
198   
199   function reactivate_trading() public only_admin {
200       
201     require(trading_deactivated);
202     
203     trading_deactivated = false;
204     
205   }
206 
207   function get_amount_sell(uint256 _amount) public view returns(uint256) {
208  
209     uint256 traded_token_balance_plus_amount_ = traded_token_balance.add(_amount);
210     
211     return (2*eth_balance*_amount)/(traded_token_balance + traded_token_balance_plus_amount_);
212     
213   }
214 
215   function get_amount_buy(uint256 _amount) public view returns(uint256) {
216 
217     uint256 eth_balance_plus_amount_ = eth_balance + _amount;
218     
219     return (_amount*traded_token_balance*(eth_balance_plus_amount_ + eth_balance))/(2*eth_balance_plus_amount_*eth_balance);
220    
221   }
222   
223   function get_amount_minus_commission(uint256 _amount) private view returns(uint256) {
224       
225     return (_amount*(1 ether - commission_ratio))/(1 ether);  
226     
227   }
228 
229   function activate_admin_commission() public only_admin {
230 
231     require(!admin_commission_activated);
232 
233     admin_commission_activated = true;
234 
235   }
236 
237   function deactivate_admin_comission() public only_admin {
238 
239     require(admin_commission_activated);
240 
241     admin_commission_activated = false;
242 
243   }
244 
245   function change_admin_commission(uint256 _new_commission_ratio) public only_admin {
246   
247      require(_new_commission_ratio != commission_ratio);
248 
249      commission_ratio = _new_commission_ratio;
250 
251   }
252 
253 
254   function complete_sell_exchange(uint256 _amount_give) private {
255 
256     uint256 amount_get_ = get_amount_sell(_amount_give);
257 
258     uint256 amount_get_minus_commission_ = get_amount_minus_commission(amount_get_);
259     
260     transferTokensThroughProxyToContract(msg.sender,this,_amount_give);
261 
262     transferETHFromContract(msg.sender,amount_get_minus_commission_);  
263 
264     if(admin_commission_activated) {
265 
266       uint256 admin_commission_ = amount_get_ - amount_get_minus_commission_;
267 
268       transferETHFromContract(admin, admin_commission_);     
269 
270     }
271     
272   }
273   
274   function complete_buy_exchange() private {
275 
276     uint256 amount_give_ = msg.value;
277 
278     uint256 amount_get_ = get_amount_buy(amount_give_);
279 
280     uint256 amount_get_minus_commission_ = get_amount_minus_commission(amount_get_);
281 
282     transferETHToContract();
283 
284     transferTokensFromContract(msg.sender, amount_get_minus_commission_);
285 
286     if(admin_commission_activated) {
287 
288       uint256 admin_commission_ = amount_get_ - amount_get_minus_commission_;
289 
290       transferTokensFromContract(admin, admin_commission_);
291 
292     }
293     
294   }
295   
296   function sell_tokens(uint256 _amount_give) public trading_activated {
297 
298     require(market_is_open());
299 
300     complete_sell_exchange(_amount_give);
301 
302   }
303   
304   function buy_tokens() private trading_activated {
305 
306     require(market_is_open());
307 
308     complete_buy_exchange();
309 
310   }
311 
312 
313   function() public payable {
314 
315     buy_tokens();
316 
317   }
318 
319 }
320 
321 contract TokenLiquidity { 
322 
323   function create_a_new_market(address _traded_token, uint256 _base_token_seed_amount, uint256 _traded_token_seed_amount, uint256 _commission_ratio) public {
324 
325     new TokenLiquidityContract(_traded_token, _base_token_seed_amount, _traded_token_seed_amount, _commission_ratio);
326 
327   }
328   
329   function() public payable {
330 
331     revert();
332 
333   }
334 
335 }