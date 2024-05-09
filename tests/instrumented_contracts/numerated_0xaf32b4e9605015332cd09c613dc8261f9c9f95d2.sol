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
33   function transferFrom(address from, address to, uint tokens) public returns (bool success);
34 
35   function transfer(address to, uint tokens) public returns (bool success);
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
49   uint public base_token_seed_amount;
50 
51   uint public traded_token_seed_amount;
52   
53   uint public commission_ratio;
54 
55   bool public base_token_is_seeded;
56 
57   bool public traded_token_is_seeded;
58 
59   mapping (address => uint) public token_balance;
60   
61   modifier onlyAdmin() {
62       msg.sender == admin;
63       _;
64   }
65 
66   constructor(address _base_token, address _traded_token,uint _base_token_seed_amount, uint _traded_token_seed_amount, uint _commission_ratio) public {
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
100   function deposit_token(address _token, uint _amount) private { 
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
114   function withdraw_token(uint _amount) onlyAdmin public {
115       
116       uint currentBalance_ = token_balance[traded_token];
117       
118       require(currentBalance_ >= _amount);
119       
120       transferTokens(msg.sender, _amount);
121       
122   }
123   
124   function withdraw_eth(uint _amount) onlyAdmin public {
125       
126       uint currentBalance_ = token_balance[0];
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
160     set_base_token_as_seeded();
161 
162     deposit_eth(); 
163 
164   }
165 
166   function market_is_open() private view returns(bool) {
167   
168     return (base_token_is_seeded && traded_token_is_seeded);
169 
170   }
171 
172   function calculate_price(uint _pre_pay_in_price,uint _post_pay_in_price) private pure returns(uint256) {
173 
174     return (_pre_pay_in_price.add(_post_pay_in_price)).div(2);
175 
176   }
177 
178   function get_amount_get_sell(uint256 _amount) private view returns(uint256) {
179    
180     uint traded_token_balance_ = token_balance[traded_token];
181     
182     uint base_token_balance_ = token_balance[base_token];    
183 
184     uint pre_pay_in_price_ = traded_token_balance_.div(base_token_balance_);
185 
186     uint post_pay_in_price_ = (traded_token_balance_.add(_amount)).div(base_token_balance_);
187    
188     uint adjusted_price_ = calculate_price(pre_pay_in_price_,post_pay_in_price_);
189 
190     return _amount.div(adjusted_price_);   
191       
192   }
193 
194   function get_amount_get_buy(uint256 _amount) private view returns(uint256) {
195  
196     uint traded_token_balance_ = token_balance[traded_token];
197     
198     uint base_token_balance_ = token_balance[base_token];    
199 
200     uint pre_pay_in_price_ = traded_token_balance_.div(base_token_balance_);
201 
202     uint post_pay_in_price_ = traded_token_balance_.div(base_token_balance_.add(_amount));
203    
204     uint adjusted_price_ = calculate_price(pre_pay_in_price_,post_pay_in_price_);
205 
206     return _amount.mul(adjusted_price_);
207     
208   }
209 
210   function complete_sell_exchange(uint _amount_give) private {
211 
212     uint amount_get_ = get_amount_get_sell(_amount_give);
213     
214     uint amount_get_minus_fee_ = (amount_get_.mul(1 ether - commission_ratio)).div(1 ether);
215     
216     uint admin_fee = amount_get_ - amount_get_minus_fee_;
217 
218     transferTokensThroughProxy(msg.sender,this,_amount_give);
219 
220     transferETH(msg.sender,amount_get_minus_fee_);  
221     
222     transferETH(admin, admin_fee);      
223       
224   }
225   
226   function complete_buy_exchange() private {
227     
228     uint amount_give_ = msg.value;
229 
230     uint amount_get_ = get_amount_get_buy(amount_give_);
231     
232     uint amount_get_minus_fee_ = (amount_get_.mul(1 ether - commission_ratio)).div(1 ether);
233 
234     uint admin_fee = amount_get_ - amount_get_minus_fee_;
235 
236     transferTokens(msg.sender, amount_get_minus_fee_);
237     
238     transferETH(admin, admin_fee);
239     
240   }
241   
242   function sell_tokens(uint _amount_give) public {
243 
244     require(market_is_open());
245 
246     complete_sell_exchange(_amount_give);
247 
248   }
249   
250   function buy_tokens() private {
251 
252     require(market_is_open());
253 
254     complete_buy_exchange();
255 
256   }
257 
258   function() public payable {
259 
260     buy_tokens();
261 
262   }
263 
264 }