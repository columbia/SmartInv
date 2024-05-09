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
17     c = a * b;
18     assert(c >= a);
19     return c; 
20   }
21 }
22 
23 contract Token {
24  
25   function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
26 
27   function transfer(address to, uint256 tokens) public returns (bool success);
28      
29 }
30 
31 contract TokenLiquidityContract { 
32 
33   using SafeMath for uint256;  
34 
35 
36   address public admin;
37 
38   address public traded_token;
39 
40   
41   uint256 public eth_seed_amount;
42 
43   uint256 public traded_token_seed_amount;
44   
45   uint256 public commission_ratio;
46 
47   uint256 public eth_balance;
48 
49   uint256 public traded_token_balance;
50 
51 
52   bool public eth_is_seeded;
53 
54   bool public traded_token_is_seeded;
55   
56   bool public trading_deactivated;
57 
58   bool public admin_commission_activated;
59 
60 
61   modifier only_admin() {
62       require(msg.sender == admin);
63       _;
64   }
65   
66   modifier trading_activated() {
67       require(trading_deactivated == false);
68       _;
69   }
70 
71   
72   constructor(address _traded_token,uint256 _eth_seed_amount, uint256 _traded_token_seed_amount, uint256 _commission_ratio) public {
73       
74     admin = msg.sender;  
75     
76     traded_token = _traded_token;
77     
78     eth_seed_amount = _eth_seed_amount;
79     
80     traded_token_seed_amount = _traded_token_seed_amount;
81 
82     commission_ratio = _commission_ratio;
83     
84   }
85   
86   function transferTokensThroughProxyToContract(address _from, address _to, uint256 _amount) private {
87 
88     traded_token_balance = traded_token_balance.add(_amount);
89 
90     require(Token(traded_token).transferFrom(_from,_to,_amount));
91      
92   }  
93 
94   function transferTokensFromContract(address _to, uint256 _amount) private {
95     traded_token_balance = traded_token_balance.sub(_amount);
96     require(Token(traded_token).transfer(_to,_amount));
97   }
98 
99   function transferETHToContract() private {
100     eth_balance = eth_balance.add(msg.value);
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
206  /// buyAmount*amountTokenA/(amountTokenB + buyAmount)
207  /// buy: (tokenAmountInContract*_ethAmountFromBuyer)/(contract_eth_balamce + _ethAmountFromBuyer)
208  /// sell: sellAmount*(contract_eth_balance)/(tokenAmount + sellAmount)
209   function get_amount_sell(uint256 _amount) public view returns(uint256) {
210     return eth_balance.mul(_amount) / traded_token_balance.add(_amount);
211   }
212 
213   function get_amount_buy(uint256 _amount) public view returns(uint256) {
214 
215     return traded_token_balance.mul(_amount) / eth_balance.add(_amount);
216    
217   }
218   
219   function get_amount_minus_commission(uint256 _amount) private view returns(uint256) {
220       
221     return (_amount*(1 ether - commission_ratio))/(1 ether);  
222     
223   }
224 
225   function activate_admin_commission() public only_admin {
226 
227     require(!admin_commission_activated);
228 
229     admin_commission_activated = true;
230 
231   }
232 
233   function deactivate_admin_comission() public only_admin {
234 
235     require(admin_commission_activated);
236 
237     admin_commission_activated = false;
238 
239   }
240 
241   function change_admin_commission(uint256 _new_commission_ratio) public only_admin {
242   
243      require(_new_commission_ratio != commission_ratio);
244 
245      commission_ratio = _new_commission_ratio;
246 
247   }
248 
249 
250   function complete_sell_exchange(uint256 _amount_give) private {
251 
252     uint256 amount_get_ = get_amount_sell(_amount_give);
253 
254 
255     // this is the amount that is transferred to the seller -minus the commision ANYWAY (even if admin_commission_activated is False) 
256     uint256 amount_get_minus_commission_ = get_amount_minus_commission(amount_get_);
257     
258     transferTokensThroughProxyToContract(msg.sender,this,_amount_give);
259 
260 
261     // the commission is transferred to admin only if admin_commission_activated, but the commission is subtracted anyway
262     if(admin_commission_activated) {
263       transferETHFromContract(msg.sender,amount_get_minus_commission_);
264 
265       uint256 admin_commission_ = amount_get_ - amount_get_minus_commission_;
266 
267       transferETHFromContract(admin, admin_commission_);     
268 
269     }
270     else {
271       transferETHFromContract(msg.sender,amount_get_);
272     }
273   }
274   
275   function complete_buy_exchange() private {
276 
277     // SAME problem that is in complete_sell_exchange
278     uint256 amount_give_ = msg.value;
279 
280     uint256 amount_get_ = get_amount_buy(amount_give_);
281 
282     uint256 amount_get_minus_commission_ = get_amount_minus_commission(amount_get_);
283 
284     transferETHToContract();
285 
286 
287     if(admin_commission_activated) {
288       transferTokensFromContract(msg.sender, amount_get_minus_commission_); // minus commision anyway?
289 
290       uint256 admin_commission_ = amount_get_ - amount_get_minus_commission_; // not safe if commision is calculated in a weird way?
291 
292       transferTokensFromContract(admin, admin_commission_);
293 
294     } 
295     else {
296       transferTokensFromContract(msg.sender, amount_get_);
297     }
298     
299   }
300   
301   function sell_tokens(uint256 _amount_give) public trading_activated {
302 
303     require(market_is_open());
304 
305     complete_sell_exchange(_amount_give);
306 
307   }
308   
309   function buy_tokens() private trading_activated {
310 
311     require(market_is_open());
312 
313     complete_buy_exchange();
314 
315   }
316 
317 
318   function() public payable {
319 
320     buy_tokens();
321 
322   }
323 
324 }