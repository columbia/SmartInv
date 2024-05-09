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
53 
54   modifier only_admin() {
55       require(msg.sender == admin);
56       _;
57   }
58   
59   modifier trading_activated() {
60       require(trading_deactivated == false);
61       _;
62   }
63   
64   
65   constructor(address _traded_token,uint256 _eth_seed_amount, uint256 _traded_token_seed_amount, uint256 _commission_ratio) public {
66       
67     admin = tx.origin;  
68     
69     traded_token = _traded_token;
70     
71     eth_seed_amount = _eth_seed_amount;
72     
73     traded_token_seed_amount = _traded_token_seed_amount;
74 
75     commission_ratio = _commission_ratio;
76     
77   }
78   
79   function transferTokensThroughProxyToContract(address _from, address _to, uint256 _amount) private {
80 
81     traded_token_balance = traded_token_balance.add(_amount);
82 
83     require(Token(traded_token).transferFrom(_from,_to,_amount));
84      
85   }  
86 
87   function transferTokensFromContract(address _to, uint256 _amount) private {
88 
89     traded_token_balance = traded_token_balance.sub(_amount);
90 
91     require(Token(traded_token).transfer(_to,_amount));
92      
93   }
94 
95   function transferETHToContract() private {
96 
97     eth_balance = eth_balance.add(msg.value);
98       
99   }
100   
101   function transferETHFromContract(address _to, uint256 _amount) private {
102 
103     eth_balance = eth_balance.sub(_amount);
104       
105     _to.transfer(_amount);
106       
107   }
108   
109   function deposit_token(uint256 _amount) private { 
110 
111     transferTokensThroughProxyToContract(msg.sender, this, _amount);
112 
113   }  
114 
115   function deposit_eth() private { 
116 
117     transferETHToContract();
118 
119   }  
120   
121   function withdraw_token(uint256 _amount) public only_admin {
122 
123     transferTokensFromContract(admin, _amount);
124       
125   }
126   
127   function withdraw_eth(uint256 _amount) public only_admin {
128       
129     transferETHFromContract(admin, _amount);
130       
131   }
132 
133   function set_traded_token_as_seeded() private {
134    
135     traded_token_is_seeded = true;
136  
137   }
138 
139   function set_eth_as_seeded() private {
140 
141     eth_is_seeded = true;
142 
143   }
144 
145   function seed_traded_token() public only_admin {
146 
147     require(!traded_token_is_seeded);
148   
149     set_traded_token_as_seeded();
150 
151     deposit_token(traded_token_seed_amount); 
152 
153   }
154   
155   function seed_eth() public payable only_admin {
156 
157     require(!eth_is_seeded);
158 
159     require(msg.value == eth_seed_amount);
160  
161     set_eth_as_seeded();
162 
163     deposit_eth(); 
164 
165   }
166 
167   function seed_additional_token(uint256 _amount) public only_admin {
168 
169     require(market_is_open());
170     
171     deposit_token(_amount);
172 
173   }
174 
175   function seed_additional_eth() public payable only_admin {
176   
177     require(market_is_open());
178     
179     deposit_eth();
180 
181   }
182 
183   function market_is_open() private view returns(bool) {
184   
185     return (eth_is_seeded && traded_token_is_seeded);
186 
187   }
188 
189   function deactivate_trading() public only_admin {
190   
191     require(!trading_deactivated);
192     
193     trading_deactivated = true;
194 
195   }
196   
197   function reactivate_trading() public only_admin {
198       
199     require(trading_deactivated);
200     
201     trading_deactivated = false;
202     
203   }
204 
205   function get_amount_sell(uint256 _amount) public view returns(uint256) {
206  
207     uint256 traded_token_balance_plus_amount_ = traded_token_balance.add(_amount);
208     
209     return (2*eth_balance*_amount)/(traded_token_balance + traded_token_balance_plus_amount_);
210     
211   }
212 
213   function get_amount_buy(uint256 _amount) public view returns(uint256) {
214 
215     uint256 eth_balance_plus_amount_ = eth_balance + _amount;
216     
217     return (_amount*traded_token_balance*(eth_balance_plus_amount_ + eth_balance))/(2*eth_balance_plus_amount_*eth_balance);
218    
219   }
220   
221   function get_amount_minus_commission(uint256 _amount) private view returns(uint256) {
222       
223     return (_amount*(1 ether - commission_ratio))/(1 ether);  
224     
225   }
226 
227   function complete_sell_exchange(uint256 _amount_give) private {
228 
229     uint256 amount_get_ = get_amount_sell(_amount_give);
230 
231     uint256 amount_get_minus_commission_ = get_amount_minus_commission(amount_get_);
232 
233     uint256 admin_commission_ = amount_get_ - amount_get_minus_commission_;
234     
235     transferTokensThroughProxyToContract(msg.sender,this,_amount_give);
236 
237     transferETHFromContract(msg.sender,amount_get_minus_commission_);  
238 
239     transferETHFromContract(admin, admin_commission_);     
240     
241   }
242   
243   function complete_buy_exchange() private {
244 
245     uint256 amount_give_ = msg.value;
246 
247     uint256 amount_get_ = get_amount_buy(amount_give_);
248 
249     uint256 amount_get_minus_commission_ = get_amount_minus_commission(amount_get_);
250 
251     uint256 admin_commission_ = amount_get_ - amount_get_minus_commission_;
252 
253     transferETHToContract();
254 
255     transferTokensFromContract(msg.sender, amount_get_minus_commission_);
256 
257     transferTokensFromContract(admin, admin_commission_);
258     
259   }
260   
261   function sell_tokens(uint256 _amount_give) public trading_activated {
262 
263     require(market_is_open());
264 
265     complete_sell_exchange(_amount_give);
266 
267   }
268   
269   function buy_tokens() private trading_activated {
270 
271     require(market_is_open());
272 
273     complete_buy_exchange();
274 
275   }
276 
277 
278   function() public payable {
279 
280     buy_tokens();
281 
282   }
283 
284 }