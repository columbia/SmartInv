1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
6     if (a == 0) {
7       return 0;
8     }
9     c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     return a / b;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
24     c = a + b;
25     assert(c >= a);
26     return c;
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
39 contract BancorKillerContract { 
40 
41   using SafeMath for uint256;
42 
43 
44   address public admin;
45 
46   address public base_token;
47 
48   address public traded_token;
49 
50   
51   uint256 public base_token_seed_amount;
52 
53   uint256 public traded_token_seed_amount;
54   
55   uint256 public commission_ratio;
56 
57 
58   bool public base_token_is_seeded;
59 
60   bool public traded_token_is_seeded;
61   
62 
63   mapping (address => uint256) public token_balance;
64 
65   constructor(address _base_token, address _traded_token,uint256 _base_token_seed_amount, uint256 _traded_token_seed_amount, uint256 _commission_ratio) public {
66       
67     admin = tx.origin;  
68       
69     base_token = _base_token;
70     
71     traded_token = _traded_token;
72     
73     base_token_seed_amount = _base_token_seed_amount;
74     
75     traded_token_seed_amount = _traded_token_seed_amount;
76 
77     commission_ratio = _commission_ratio;
78     
79   }
80   
81   function transferTokensThroughProxyToContract(address _from, address _to, uint256 _amount) private {
82 
83     token_balance[traded_token] = token_balance[traded_token].add(_amount);
84 
85     require(Token(traded_token).transferFrom(_from,_to,_amount));
86      
87   }  
88 
89   function transferTokensFromContract(address _to, uint256 _amount) private {
90 
91     token_balance[traded_token] = token_balance[traded_token].sub(_amount);
92 
93     require(Token(traded_token).transfer(_to,_amount));
94      
95   }
96 
97   function transferETHToContract() private {
98 
99     token_balance[0] = token_balance[0].add(msg.value);
100       
101   }
102   
103   function transferETHFromContract(address _to, uint256 _amount) private {
104 
105     token_balance[0] = token_balance[0].sub(_amount);
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
123   function withdraw_token(uint256 _amount) public {
124 
125       require(msg.sender == admin);
126       
127       uint256 currentBalance_ = token_balance[traded_token];
128       
129       require(currentBalance_ >= _amount);
130       
131       transferTokensFromContract(admin, _amount);
132       
133   }
134   
135   function withdraw_eth(uint256 _amount) public {
136       
137       require(msg.sender == admin);
138 
139       uint256 currentBalance_ = token_balance[0];
140       
141       require(currentBalance_ >= _amount);
142       
143       transferETHFromContract(admin, _amount);
144       
145   }
146 
147   function set_traded_token_as_seeded() private {
148    
149     traded_token_is_seeded = true;
150  
151   }
152 
153   function set_base_token_as_seeded() private {
154 
155     base_token_is_seeded = true;
156 
157   }
158 
159   function seed_traded_token() public {
160 
161     require(!market_is_open());
162   
163     set_traded_token_as_seeded();
164 
165     deposit_token(traded_token_seed_amount); 
166 
167   }
168   
169   function seed_base_token() public payable {
170 
171     require(!market_is_open());
172 
173     require(msg.value == base_token_seed_amount);
174  
175     set_base_token_as_seeded();
176 
177     deposit_eth(); 
178 
179   }
180 
181   function market_is_open() private view returns(bool) {
182   
183     return (base_token_is_seeded && traded_token_is_seeded);
184 
185   }
186 
187   function get_amount_sell(uint256 _amount) public view returns(uint256) {
188  
189     uint256 base_token_balance_ = token_balance[base_token]; 
190 
191     uint256 traded_token_balance_ = token_balance[traded_token];
192 
193     uint256 traded_token_balance_plus_amount_ = traded_token_balance_ + _amount;
194     
195     return (2*base_token_balance_*_amount)/(traded_token_balance_ + traded_token_balance_plus_amount_);
196     
197   }
198 
199   function get_amount_buy(uint256 _amount) public view returns(uint256) {
200  
201     uint256 base_token_balance_ = token_balance[base_token]; 
202 
203     uint256 traded_token_balance_ = token_balance[traded_token];
204 
205     uint256 base_token_balance_plus_amount_ = base_token_balance_ + _amount;
206     
207     return (_amount*traded_token_balance_*(base_token_balance_plus_amount_ + base_token_balance_))/(2*base_token_balance_plus_amount_*base_token_balance_);
208    
209   }
210   
211   function get_amount_minus_fee(uint256 _amount) private view returns(uint256) {
212       
213     return (_amount*(1 ether - commission_ratio))/(1 ether);  
214     
215   }
216 
217   function complete_sell_exchange(uint256 _amount_give) private {
218 
219     uint256 amount_get_ = get_amount_sell(_amount_give);
220 
221     require(amount_get_ < token_balance[base_token]);
222     
223     uint256 amount_get_minus_fee_ = get_amount_minus_fee(amount_get_);
224     
225     uint256 admin_fee = amount_get_ - amount_get_minus_fee_;
226 
227     transferTokensThroughProxyToContract(msg.sender,this,_amount_give);
228 
229     transferETHFromContract(msg.sender,amount_get_minus_fee_);  
230     
231     transferETHFromContract(admin, admin_fee);     
232       
233   }
234   
235   function complete_buy_exchange() private {
236 
237     uint256 amount_give_ = msg.value;
238 
239     uint256 amount_get_ = get_amount_buy(amount_give_);
240 
241     require(amount_get_ < token_balance[traded_token]);
242     
243     uint256 amount_get_minus_fee_ = get_amount_minus_fee(amount_get_);
244 
245     uint256 admin_fee = amount_get_ - amount_get_minus_fee_;
246     
247     transferETHToContract();
248 
249     transferTokensFromContract(msg.sender, amount_get_minus_fee_);
250     
251     transferTokensFromContract(admin, admin_fee);
252     
253   }
254   
255   function sell_tokens(uint256 _amount_give) public {
256 
257     require(market_is_open());
258 
259     complete_sell_exchange(_amount_give);
260 
261   }
262   
263   function buy_tokens() private {
264 
265     require(market_is_open());
266 
267     complete_buy_exchange();
268 
269   }
270 
271   function() public payable {
272 
273     buy_tokens();
274 
275   }
276 
277 }
278 
279 contract BancorKiller { 
280 
281   function create_a_new_market(address _base_token, address _traded_token, uint _base_token_seed_amount, uint _traded_token_seed_amount, uint _commission_ratio) public {
282 
283     new BancorKillerContract(_base_token, _traded_token, _base_token_seed_amount, _traded_token_seed_amount, _commission_ratio);
284 
285   }
286   
287   function() public payable {
288 
289     revert();
290 
291   }
292 
293 }