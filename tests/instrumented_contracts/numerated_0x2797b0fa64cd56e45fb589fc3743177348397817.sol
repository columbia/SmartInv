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
46   address public traded_token;
47 
48   
49   uint256 public eth_seed_amount;
50 
51   uint256 public traded_token_seed_amount;
52   
53   uint256 public commission_ratio;
54 
55   uint256 eth_balance;
56 
57   uint256 traded_token_balance;
58 
59 
60   bool public eth_is_seeded;
61 
62   bool public traded_token_is_seeded;
63   
64   bool public trading_deactivated;
65   
66 
67   modifier onlyAdmin() {
68       require(msg.sender == admin);
69       _;
70   }
71   
72   modifier tradingActivated() {
73       require(trading_deactivated == false);
74       _;
75   }
76   
77   constructor(address _traded_token,uint256 _eth_seed_amount, uint256 _traded_token_seed_amount, uint256 _commission_ratio) public {
78       
79     admin = tx.origin;  
80     
81     traded_token = _traded_token;
82     
83     eth_seed_amount = _eth_seed_amount;
84     
85     traded_token_seed_amount = _traded_token_seed_amount;
86 
87     commission_ratio = _commission_ratio;
88     
89   }
90   
91   function transferTokensThroughProxyToContract(address _from, address _to, uint256 _amount) private {
92 
93     traded_token_balance = traded_token_balance.add(_amount);
94 
95     require(Token(traded_token).transferFrom(_from,_to,_amount));
96      
97   }  
98 
99   function transferTokensFromContract(address _to, uint256 _amount) private {
100 
101     traded_token_balance = traded_token_balance.sub(_amount);
102 
103     require(Token(traded_token).transfer(_to,_amount));
104      
105   }
106 
107   function transferETHToContract() private {
108 
109     eth_balance = eth_balance.add(msg.value);
110       
111   }
112   
113   function transferETHFromContract(address _to, uint256 _amount) private {
114 
115     eth_balance = eth_balance.sub(_amount);
116       
117     _to.transfer(_amount);
118       
119   }
120   
121   function deposit_token(uint256 _amount) private { 
122 
123     transferTokensThroughProxyToContract(msg.sender, this, _amount);
124 
125   }  
126 
127   function deposit_eth() private { 
128 
129     transferETHToContract();
130 
131   }  
132   
133   function withdraw_token(uint256 _amount) public onlyAdmin {
134 
135     transferTokensFromContract(admin, _amount);
136       
137   }
138   
139   function withdraw_eth(uint256 _amount) public onlyAdmin {
140       
141     transferETHFromContract(admin, _amount);
142       
143   }
144 
145   function set_traded_token_as_seeded() private {
146    
147     traded_token_is_seeded = true;
148  
149   }
150 
151   function set_eth_as_seeded() private {
152 
153     eth_is_seeded = true;
154 
155   }
156 
157   function seed_traded_token() public onlyAdmin {
158 
159     require(!traded_token_is_seeded);
160   
161     set_traded_token_as_seeded();
162 
163     deposit_token(traded_token_seed_amount); 
164 
165   }
166   
167   function seed_eth() public payable onlyAdmin {
168 
169     require(!eth_is_seeded);
170 
171     require(msg.value == eth_seed_amount);
172  
173     set_eth_as_seeded();
174 
175     deposit_eth(); 
176 
177   }
178 
179   function seed_additional_token(uint256 _amount) public onlyAdmin {
180 
181     require(market_is_open());
182     
183     deposit_token(_amount);
184 
185   }
186 
187   function seed_additional_eth() public payable onlyAdmin {
188   
189     require(market_is_open());
190     
191     deposit_eth();
192 
193   }
194 
195   function market_is_open() private view returns(bool) {
196   
197     return (eth_is_seeded && traded_token_is_seeded);
198 
199   }
200 
201   function deactivate_trading() public onlyAdmin {
202   
203     require(!trading_deactivated);
204     
205     trading_deactivated = true;
206 
207   }
208   
209   function reactivate_trading() public onlyAdmin {
210       
211     require(trading_deactivated);
212     
213     trading_deactivated = false;
214     
215   }
216 
217   function get_amount_sell(uint256 _amount) public view returns(uint256) {
218  
219     uint256 eth_balance_ = eth_balance; 
220 
221     uint256 traded_token_balance_ = traded_token_balance;
222 
223     uint256 traded_token_balance_plus_amount_ = traded_token_balance_ + _amount;
224     
225     return (2*eth_balance_*_amount)/(traded_token_balance_ + traded_token_balance_plus_amount_);
226     
227   }
228 
229   function get_amount_buy(uint256 _amount) public view returns(uint256) {
230  
231     uint256 eth_balance_ = eth_balance; 
232 
233     uint256 traded_token_balance_ = traded_token_balance;
234 
235     uint256 eth_balance_plus_amount_ = eth_balance_ + _amount;
236     
237     return (_amount*traded_token_balance_*(eth_balance_plus_amount_ + eth_balance_))/(2*eth_balance_plus_amount_*eth_balance_);
238    
239   }
240   
241   function get_amount_minus_commission(uint256 _amount) private view returns(uint256) {
242       
243     return (_amount*(1 ether - commission_ratio))/(1 ether);  
244     
245   }
246 
247   function complete_sell_exchange(uint256 _amount_give) private {
248 
249     uint256 amount_get_ = get_amount_sell(_amount_give);
250 
251     uint256 amount_get_minus_commission_ = get_amount_minus_commission(amount_get_);
252 
253     uint256 admin_commission = amount_get_ - amount_get_minus_commission_;
254     
255     transferTokensThroughProxyToContract(msg.sender,this,_amount_give);
256 
257     transferETHFromContract(msg.sender,amount_get_minus_commission_);  
258 
259     transferETHFromContract(admin, admin_commission);     
260     
261   }
262   
263   function complete_buy_exchange() private {
264 
265     uint256 amount_give_ = msg.value;
266 
267     uint256 amount_get_ = get_amount_buy(amount_give_);
268 
269     uint256 amount_get_minus_commission_ = get_amount_minus_commission(amount_get_);
270 
271     uint256 admin_commission = amount_get_ - amount_get_minus_commission_;
272 
273     transferETHToContract();
274 
275     transferTokensFromContract(msg.sender, amount_get_minus_commission_);
276 
277     transferTokensFromContract(admin, admin_commission);
278     
279   }
280   
281   function sell_tokens(uint256 _amount_give) public tradingActivated {
282 
283     require(market_is_open());
284 
285     complete_sell_exchange(_amount_give);
286 
287   }
288   
289   function buy_tokens() private tradingActivated {
290 
291     require(market_is_open());
292 
293     complete_buy_exchange();
294 
295   }
296 
297 
298   function() public payable {
299 
300     buy_tokens();
301 
302   }
303 
304 }