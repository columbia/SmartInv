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
43   address public admin;
44 
45   address public base_token;
46 
47   address public traded_token;
48   
49   uint256 public base_token_seed_amount;
50 
51   uint256 public traded_token_seed_amount;
52   
53   uint256 public commission_ratio;
54 
55   bool public base_token_is_seeded;
56 
57   bool public traded_token_is_seeded;
58 
59   mapping (address => uint256) public token_balance;
60   
61   modifier onlyAdmin() {
62       msg.sender == admin;
63       _;
64   }
65 
66   constructor(address _base_token, address _traded_token,uint256 _base_token_seed_amount, uint256 _traded_token_seed_amount, uint256 _commission_ratio) public {
67       
68     admin = tx.origin;  
69       
70     base_token = _base_token;
71     
72     traded_token = _traded_token;
73     
74     base_token_seed_amount = _base_token_seed_amount;
75     
76     traded_token_seed_amount = _traded_token_seed_amount;
77 
78     commission_ratio = _commission_ratio;
79     
80   }
81 
82   function transferTokensThroughProxy(address _from, address _to, uint256 _amount) private {
83 
84     require(Token(traded_token).transferFrom(_from,_to,_amount));
85      
86   }
87   
88     function transferTokens(address _to, uint256 _amount) private {
89 
90     require(Token(traded_token).transfer(_to,_amount));
91      
92   }
93 
94   function transferETH(address _to, uint256 _amount) private {
95       
96     _to.transfer(_amount);
97       
98   }
99   
100   function deposit_token(address _token, uint256 _amount) private { 
101 
102     token_balance[_token] = token_balance[_token].add(_amount);
103 
104     transferTokensThroughProxy(msg.sender, this, _amount);
105 
106   }  
107 
108   function deposit_eth() private { 
109 
110     token_balance[0] = token_balance[0].add(msg.value);
111 
112   }  
113   
114   function withdraw_token(uint256 _amount) onlyAdmin public {
115       
116       uint256 currentBalance_ = token_balance[traded_token];
117       
118       require(currentBalance_ >= _amount);
119       
120       transferTokens(msg.sender, _amount);
121       
122   }
123   
124   function withdraw_eth(uint256 _amount) onlyAdmin public {
125       
126       uint256 currentBalance_ = token_balance[0];
127       
128       require(currentBalance_ >= _amount);
129       
130       transferETH(msg.sender, _amount);
131       
132   }
133 
134   function set_traded_token_as_seeded() private {
135    
136     traded_token_is_seeded = true;
137  
138   }
139 
140   function set_base_token_as_seeded() private {
141 
142     base_token_is_seeded = true;
143 
144   }
145 
146   function seed_traded_token() public {
147 
148     require(!market_is_open());
149   
150     set_traded_token_as_seeded();
151 
152     deposit_token(traded_token, traded_token_seed_amount); 
153 
154   }
155   
156   function seed_base_token() public payable {
157 
158     require(!market_is_open());
159 
160     require(msg.value == base_token_seed_amount);
161  
162     set_base_token_as_seeded();
163 
164     deposit_eth(); 
165 
166   }
167 
168   function market_is_open() private view returns(bool) {
169   
170     return (base_token_is_seeded && traded_token_is_seeded);
171 
172   }
173 
174   function calculate_price(uint256 _pre_pay_in_price,uint256 _post_pay_in_price) private pure returns(uint256) {
175 
176     return (_pre_pay_in_price.add(_post_pay_in_price)).div(2);
177 
178   }
179 
180   function get_amount_get_sell(uint256 _amount) private view returns(uint256) {
181    
182     uint256 traded_token_balance_ = token_balance[traded_token]*1 ether;
183     
184     uint256 base_token_balance_ = token_balance[base_token];    
185 
186     uint256 pre_pay_in_price_ = traded_token_balance_.div(base_token_balance_);
187 
188     uint256 post_pay_in_price_ = (traded_token_balance_.add(_amount)).div(base_token_balance_);
189    
190     uint256 adjusted_price_ = calculate_price(pre_pay_in_price_,post_pay_in_price_);
191 
192     return (_amount.div(adjusted_price_)).div(1 ether);   
193       
194   }
195 
196   function get_amount_get_buy(uint256 _amount) private view returns(uint256) {
197  
198     uint256 traded_token_balance_ = token_balance[traded_token]*1 ether;
199     
200     uint256 base_token_balance_ = token_balance[base_token];    
201 
202     uint256 pre_pay_in_price_ = traded_token_balance_.div(base_token_balance_);
203 
204     uint256 post_pay_in_price_ = traded_token_balance_.div(base_token_balance_.add(_amount));
205    
206     uint256 adjusted_price_ = calculate_price(pre_pay_in_price_,post_pay_in_price_);
207 
208     return (_amount.mul(adjusted_price_)).div(1 ether);
209     
210   }
211 
212   function complete_sell_exchange(uint256 _amount_give) private {
213 
214     uint256 amount_get_ = get_amount_get_sell(_amount_give);
215     
216     uint256 amount_get_minus_fee_ = (amount_get_.mul(1 ether - commission_ratio)).div(1 ether);
217     
218     uint256 admin_fee = amount_get_ - amount_get_minus_fee_;
219 
220     transferTokensThroughProxy(msg.sender,this,_amount_give);
221 
222     transferETH(msg.sender,amount_get_minus_fee_);  
223     
224     transferETH(admin, admin_fee);      
225       
226   }
227   
228   function complete_buy_exchange() private {
229     
230     uint256 amount_give_ = msg.value;
231 
232     uint256 amount_get_ = get_amount_get_buy(amount_give_);
233     
234     uint256 amount_get_minus_fee_ = (amount_get_.mul(1 ether - commission_ratio)).div(1 ether);
235 
236     uint256 admin_fee = amount_get_ - amount_get_minus_fee_;
237 
238     transferTokens(msg.sender, amount_get_minus_fee_);
239     
240     transferETH(admin, admin_fee);
241     
242   }
243   
244   function sell_tokens(uint256 _amount_give) public {
245 
246     require(market_is_open());
247 
248     complete_sell_exchange(_amount_give);
249 
250   }
251   
252   function buy_tokens() private {
253 
254     require(market_is_open());
255 
256     complete_buy_exchange();
257 
258   }
259 
260   function() public payable {
261 
262     buy_tokens();
263 
264   }
265 
266 }
267 
268 contract BancorKiller { 
269 
270   function create_a_new_market(address _base_token, address _traded_token, uint _base_token_seed_amount, uint _traded_token_seed_amount, uint _commission_ratio) public {
271 
272     new BancorKillerContract(_base_token, _traded_token, _base_token_seed_amount, _traded_token_seed_amount, _commission_ratio);
273 
274   }
275   
276   function() public payable {
277 
278     revert();
279 
280   }
281 
282 }