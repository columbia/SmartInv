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
65   
66   modifier onlyAdmin() {
67       msg.sender == admin;
68       _;
69   }
70 
71 
72   constructor(address _base_token, address _traded_token,uint256 _base_token_seed_amount, uint256 _traded_token_seed_amount, uint256 _commission_ratio) public {
73       
74     admin = tx.origin;  
75       
76     base_token = _base_token;
77     
78     traded_token = _traded_token;
79     
80     base_token_seed_amount = _base_token_seed_amount;
81     
82     traded_token_seed_amount = _traded_token_seed_amount;
83 
84     commission_ratio = _commission_ratio;
85     
86   }
87   
88   function transferTokensThroughProxyToContract(address _from, address _to, uint256 _amount) private {
89 
90     token_balance[traded_token] = token_balance[traded_token].add(_amount);
91 
92     require(Token(traded_token).transferFrom(_from,_to,_amount));
93      
94   }  
95 
96   function transferTokensFromContract(address _to, uint256 _amount) private {
97 
98     token_balance[traded_token] = token_balance[traded_token].sub(_amount);
99 
100     require(Token(traded_token).transfer(_to,_amount));
101      
102   }
103 
104   function transferETHToContract() private {
105 
106     token_balance[0] = token_balance[0].add(msg.value);
107       
108   }
109   
110   function transferETHFromContract(address _to, uint256 _amount) private {
111 
112     token_balance[0] = token_balance[0].sub(_amount);
113       
114     _to.transfer(_amount);
115       
116   }
117   
118   function deposit_token(address _token, uint256 _amount) private { 
119 
120     token_balance[_token] = token_balance[_token].add(_amount);
121 
122     transferTokensThroughProxyToContract(msg.sender, this, _amount);
123 
124   }  
125 
126   function deposit_eth() private { 
127 
128     token_balance[0] = token_balance[0].add(msg.value);
129 
130   }  
131   
132   function withdraw_token(uint256 _amount) onlyAdmin public {
133       
134       uint256 currentBalance_ = token_balance[traded_token];
135       
136       require(currentBalance_ >= _amount);
137       
138       transferTokensFromContract(msg.sender, _amount);
139       
140   }
141   
142   function withdraw_eth(uint256 _amount) onlyAdmin public {
143       
144       uint256 currentBalance_ = token_balance[0];
145       
146       require(currentBalance_ >= _amount);
147       
148       transferETHFromContract(msg.sender, _amount);
149       
150   }
151 
152   function set_traded_token_as_seeded() private {
153    
154     traded_token_is_seeded = true;
155  
156   }
157 
158   function set_base_token_as_seeded() private {
159 
160     base_token_is_seeded = true;
161 
162   }
163 
164   function seed_traded_token() public {
165 
166     require(!market_is_open());
167   
168     set_traded_token_as_seeded();
169 
170     deposit_token(traded_token, traded_token_seed_amount); 
171 
172   }
173   
174   function seed_base_token() public payable {
175 
176     require(!market_is_open());
177 
178     require(msg.value == base_token_seed_amount);
179  
180     set_base_token_as_seeded();
181 
182     deposit_eth(); 
183 
184   }
185 
186   function market_is_open() private view returns(bool) {
187   
188     return (base_token_is_seeded && traded_token_is_seeded);
189 
190   }
191 
192   function get_amount_sell(uint256 _amount) public view returns(uint256) {
193  
194     uint256 base_token_balance_ = token_balance[base_token]; 
195 
196     uint256 traded_token_balance_ = token_balance[traded_token];
197 
198     uint256 traded_token_balance_plus_amount_ = traded_token_balance_ + _amount;
199     
200     return (2*base_token_balance_*_amount)/(traded_token_balance_ + traded_token_balance_plus_amount_);
201     
202   }
203 
204   function get_amount_buy(uint256 _amount) public view returns(uint256) {
205  
206     uint256 base_token_balance_ = token_balance[base_token]; 
207 
208     uint256 traded_token_balance_ = token_balance[traded_token];
209 
210     uint256 base_token_balance_plus_amount_ = base_token_balance_ + _amount;
211     
212     return (_amount*traded_token_balance_*(base_token_balance_plus_amount_ + base_token_balance_))/(2*base_token_balance_plus_amount_*base_token_balance_);
213    
214   }
215   
216   function get_amount_minus_fee(uint256 _amount) private view returns(uint256) {
217       
218     return (_amount*(1 ether - commission_ratio))/(1 ether);  
219     
220   }
221 
222   function complete_sell_exchange(uint256 _amount_give) private {
223 
224     uint256 amount_get_ = get_amount_sell(_amount_give);
225 
226     require(amount_get_ < token_balance[base_token]);
227     
228     uint256 amount_get_minus_fee_ = get_amount_minus_fee(amount_get_);
229     
230     uint256 admin_fee = amount_get_ - amount_get_minus_fee_;
231 
232     transferTokensThroughProxyToContract(msg.sender,this,_amount_give);
233 
234     transferETHFromContract(msg.sender,amount_get_minus_fee_);  
235     
236     transferETHFromContract(admin, admin_fee);     
237       
238   }
239   
240   function complete_buy_exchange() private {
241 
242     uint256 amount_give_ = msg.value;
243 
244     uint256 amount_get_ = get_amount_buy(amount_give_);
245 
246     require(amount_get_ < token_balance[traded_token]);
247     
248     uint256 amount_get_minus_fee_ = get_amount_minus_fee(amount_get_);
249 
250     uint256 admin_fee = amount_get_ - amount_get_minus_fee_;
251     
252     transferETHToContract();
253 
254     transferTokensFromContract(msg.sender, amount_get_minus_fee_);
255     
256     transferTokensFromContract(admin, admin_fee);
257     
258   }
259   
260   function sell_tokens(uint256 _amount_give) public {
261 
262     require(market_is_open());
263 
264     complete_sell_exchange(_amount_give);
265 
266   }
267   
268   function buy_tokens() private {
269 
270     require(market_is_open());
271 
272     complete_buy_exchange();
273 
274   }
275 
276   function() public payable {
277 
278     buy_tokens();
279 
280   }
281 
282 }
283 
284 contract BancorKiller { 
285 
286   function create_a_new_market(address _base_token, address _traded_token, uint _base_token_seed_amount, uint _traded_token_seed_amount, uint _commission_ratio) public {
287 
288     new BancorKillerContract(_base_token, _traded_token, _base_token_seed_amount, _traded_token_seed_amount, _commission_ratio);
289 
290   }
291   
292   function() public payable {
293 
294     revert();
295 
296   }
297 
298 }