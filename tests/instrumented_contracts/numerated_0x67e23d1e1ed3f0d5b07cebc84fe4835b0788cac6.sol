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
34   function transfer(address to, uint256 tokens) public returns (bool success);
35 
36 }
37 
38 contract TokenLiquidityMarket { 
39 
40   using SafeMath for uint256;  
41 
42   address public platform;
43   address public admin;
44   address public traded_token;
45   
46   uint256 public eth_seed_amount;
47   uint256 public traded_token_seed_amount;
48   uint256 public commission_ratio;
49   uint256 public eth_balance;
50   uint256 public traded_token_balance;
51 
52   bool public eth_is_seeded;
53   bool public traded_token_is_seeded;
54   bool public trading_deactivated;
55   bool public admin_commission_activated;
56 
57   modifier only_admin() {
58       require(msg.sender == admin);
59       _;
60   }
61   
62   modifier trading_activated() {
63       require(trading_deactivated == false);
64       _;
65   }
66   
67   constructor(address _traded_token,uint256 _eth_seed_amount, uint256 _traded_token_seed_amount, uint256 _commission_ratio) public {
68     admin = tx.origin;
69     platform = msg.sender; 
70     traded_token = _traded_token;
71     eth_seed_amount = _eth_seed_amount;
72     traded_token_seed_amount = _traded_token_seed_amount;
73     commission_ratio = _commission_ratio;
74   }
75 
76   function change_admin(address _newAdmin) public only_admin() {
77     admin = _newAdmin;
78   }
79   
80   function withdraw_arbitrary_token(address _token, uint256 _amount) public only_admin() {
81       require(_token != traded_token);
82       require(Token(_token).transfer(admin, _amount));
83   }
84 
85   function withdraw_excess_tokens(uint256 _excess) public only_admin() {
86     require(Token(traded_token).transfer(address(this), traded_token_balance.add(_excess)));
87     require(Token(traded_token).transfer(admin, _excess));
88   }
89 
90   function transfer_tokens_through_proxy_to_contract(address _from, address _to, uint256 _amount) private {
91     traded_token_balance = traded_token_balance.add(_amount);
92     require(Token(traded_token).transferFrom(_from,_to,_amount));
93   }  
94 
95   function transfer_tokens_from_contract(address _to, uint256 _amount) private {
96     traded_token_balance = traded_token_balance.sub(_amount);
97     require(Token(traded_token).transfer(_to,_amount));
98   }
99 
100   function transfer_eth_to_contract() private {
101     eth_balance = eth_balance.add(msg.value);
102   }
103   
104   function transfer_eth_from_contract(address _to, uint256 _amount) private {
105     eth_balance = eth_balance.sub(_amount);
106     _to.transfer(_amount);
107   }
108   
109   function deposit_token(uint256 _amount) private { 
110     transfer_tokens_through_proxy_to_contract(msg.sender, this, _amount);
111   }  
112 
113   function deposit_eth() private { 
114     transfer_eth_to_contract();
115   }  
116   
117   function withdraw_token(uint256 _amount) public only_admin() {
118     transfer_tokens_from_contract(admin, _amount);
119   }
120   
121   function withdraw_eth(uint256 _amount) public only_admin() {
122     transfer_eth_from_contract(admin, _amount);
123   }
124 
125   function set_traded_token_as_seeded() private {
126     traded_token_is_seeded = true;
127   }
128 
129   function set_eth_as_seeded() private {
130     eth_is_seeded = true;
131   }
132 
133   function seed_traded_token() public only_admin() {
134     require(!traded_token_is_seeded);
135     set_traded_token_as_seeded();
136     deposit_token(traded_token_seed_amount); 
137   }
138   
139   function seed_eth() public payable only_admin() {
140     require(!eth_is_seeded);
141     require(msg.value == eth_seed_amount);
142     set_eth_as_seeded();
143     deposit_eth(); 
144   }
145 
146   function seed_additional_token(uint256 _amount) public only_admin() {
147     require(market_is_open());
148     deposit_token(_amount);
149   }
150 
151   function seed_additional_eth() public payable only_admin() {
152     require(market_is_open());
153     deposit_eth();
154   }
155 
156   function market_is_open() private view returns(bool) {
157     return (eth_is_seeded && traded_token_is_seeded);
158   }
159 
160   function deactivate_trading() public only_admin() {
161     require(!trading_deactivated);
162     trading_deactivated = true;
163   }
164   
165   function reactivate_trading() public only_admin() {
166     require(trading_deactivated);
167     trading_deactivated = false;
168   }
169 
170   function get_amount_sell(uint256 _amount) public view returns(uint256) {
171     uint256 traded_token_balance_plus_amount_ = traded_token_balance.add(_amount);
172     return (eth_balance.mul(_amount)).div(traded_token_balance_plus_amount_);
173   }
174 
175   function get_amount_buy(uint256 _amount) public view returns(uint256) {
176     uint256 eth_balance_plus_amount_ = eth_balance.add(_amount);
177     return ((traded_token_balance).mul(_amount)).div(eth_balance_plus_amount_);
178   }
179   
180   function get_amount_minus_commission(uint256 _amount) private view returns(uint256) {
181     return (_amount*(1 ether - commission_ratio))/(1 ether);  
182   }
183 
184   function activate_admin_commission() public only_admin() {
185     require(!admin_commission_activated);
186     admin_commission_activated = true;
187   }
188 
189   function deactivate_admin_comission() public only_admin() {
190     require(admin_commission_activated);
191     admin_commission_activated = false;
192   }
193 
194   function change_admin_commission(uint256 _new_commission_ratio) public only_admin() {
195      require(_new_commission_ratio != commission_ratio);
196      commission_ratio = _new_commission_ratio;
197   }
198 
199 
200   function complete_sell_exchange(uint256 _amount_give) private {
201     uint256 amount_get_ = get_amount_sell(_amount_give);
202     uint256 amount_get_minus_commission_ = get_amount_minus_commission(amount_get_);
203     uint256 platform_commission_ = (amount_get_ - amount_get_minus_commission_) / 5;
204     uint256 admin_commission_ = ((amount_get_ - amount_get_minus_commission_) * 4) / 5;
205     transfer_tokens_through_proxy_to_contract(msg.sender,this,_amount_give);
206     transfer_eth_from_contract(msg.sender,amount_get_minus_commission_);  
207     transfer_eth_from_contract(platform, platform_commission_);     
208     if(admin_commission_activated) {
209       transfer_eth_from_contract(admin, admin_commission_);     
210     }
211   }
212   
213   function complete_buy_exchange() private {
214     uint256 amount_give_ = msg.value;
215     uint256 amount_get_ = get_amount_buy(amount_give_);
216     uint256 amount_get_minus_commission_ = get_amount_minus_commission(amount_get_);
217     uint256 platform_commission_ = (amount_get_ - amount_get_minus_commission_) / 5;
218     uint256 admin_commission_ = ((amount_get_ - amount_get_minus_commission_) * 4) / 5;
219     transfer_eth_to_contract();
220     transfer_tokens_from_contract(msg.sender, amount_get_minus_commission_);
221     transfer_tokens_from_contract(platform, platform_commission_);
222     if(admin_commission_activated) {
223       transfer_tokens_from_contract(admin, admin_commission_);
224     }
225   }
226   
227   function sell_tokens(uint256 _amount_give) public trading_activated() {
228     require(market_is_open());
229     complete_sell_exchange(_amount_give);
230   }
231   
232   function buy_tokens() private trading_activated() {
233     require(market_is_open());
234     complete_buy_exchange();
235   }
236 
237   function() public payable {
238     buy_tokens();
239   }
240 
241 }
242 
243 contract TokenLiquidity { 
244 
245   address public admin;
246 
247   constructor() public { admin = msg.sender; }
248 
249   function create_a_new_market(address _traded_token, uint256 _base_token_seed_amount, uint256 _traded_token_seed_amount, uint256 _commission_ratio) public {
250     new TokenLiquidityMarket(_traded_token, _base_token_seed_amount, _traded_token_seed_amount, _commission_ratio);
251   }
252 
253   function withdraw_eth() public {
254      admin.transfer(address(this).balance);  
255   }
256 
257   function withdraw_token(address _token, uint256 _amount) public {
258     require(Token(_token).transfer(admin, _amount));
259   }
260   
261   function() public payable {
262     revert();
263   }
264 
265 }