1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
5     assert(b <= a);
6     return a - b;
7   }
8   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
9     c = a + b;
10     assert(c >= a);
11     return c;
12   }
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     if (a == 0) {
15       return 0;
16     }
17     c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21   function div(uint256 a, uint256 b) internal pure returns (uint256) {
22     return a / b;
23   }
24 }
25 
26 contract Token {
27   function balanceOf(address _owner) public returns (uint256); 
28   function transfer(address to, uint256 tokens) public returns (bool);
29   function transferFrom(address from, address to, uint256 tokens) public returns(bool);
30 }
31 
32 contract TokenLiquidityMarket { 
33     
34   using SafeMath for uint256;  
35 
36   address public platform;
37   address public admin;
38   address public traded_token;
39   
40   uint256 public eth_seed_amount;
41   uint256 public traded_token_seed_amount;
42   uint256 public commission_ratio;
43   uint256 public eth_balance;
44   uint256 public traded_token_balance;
45 
46   bool public eth_is_seeded;
47   bool public traded_token_is_seeded;
48   bool public trading_deactivated;
49   bool public admin_commission_activated;
50 
51   modifier only_admin() {
52       require(msg.sender == admin);
53       _;
54   }
55   
56   modifier trading_activated() {
57       require(trading_deactivated == false);
58       _;
59   }
60   
61   function TokenLiquidityMarket(address _traded_token,uint256 _eth_seed_amount, uint256 _traded_token_seed_amount, uint256 _commission_ratio) public {
62     admin = tx.origin;
63     platform = msg.sender; 
64     traded_token = _traded_token;
65     eth_seed_amount = _eth_seed_amount;
66     traded_token_seed_amount = _traded_token_seed_amount;
67     commission_ratio = _commission_ratio;
68   }
69 
70   function change_admin(address _newAdmin) public only_admin() {
71     admin = _newAdmin;
72   }
73   
74   function withdraw_arbitrary_token(address _token, uint256 _amount) public only_admin() {
75       require(_token != traded_token);
76       require(Token(_token).transfer(admin, _amount));
77   }
78 
79   function withdraw_excess_tokens() public only_admin() {
80     uint256 queried_traded_token_balance_ = Token(traded_token).balanceOf(this);
81     require(queried_traded_token_balance_ >= traded_token_balance);
82     uint256 excess_ = queried_traded_token_balance_.sub(traded_token_balance);
83     require(Token(traded_token).transfer(admin, excess_));
84   }
85 
86   function transfer_tokens_through_proxy_to_contract(address _from, address _to, uint256 _amount) private {
87     traded_token_balance = traded_token_balance.add(_amount);
88     require(Token(traded_token).transferFrom(_from,_to,_amount));
89   }  
90 
91   function transfer_tokens_from_contract(address _to, uint256 _amount) private {
92     traded_token_balance = traded_token_balance.sub(_amount);
93     require(Token(traded_token).transfer(_to,_amount));
94   }
95 
96   function transfer_eth_to_contract() private {
97     eth_balance = eth_balance.add(msg.value);
98   }
99   
100   function transfer_eth_from_contract(address _to, uint256 _amount) private {
101     eth_balance = eth_balance.sub(_amount);
102     _to.transfer(_amount);
103   }
104   
105   function deposit_token(uint256 _amount) private { 
106     transfer_tokens_through_proxy_to_contract(msg.sender, this, _amount);
107   }  
108 
109   function deposit_eth() private { 
110     transfer_eth_to_contract();
111   }  
112   
113   function withdraw_token(uint256 _amount) public only_admin() {
114     transfer_tokens_from_contract(admin, _amount);
115   }
116   
117   function withdraw_eth(uint256 _amount) public only_admin() {
118     transfer_eth_from_contract(admin, _amount);
119   }
120 
121   function set_traded_token_as_seeded() private {
122     traded_token_is_seeded = true;
123   }
124 
125   function set_eth_as_seeded() private {
126     eth_is_seeded = true;
127   }
128 
129   function seed_traded_token() public only_admin() {
130     require(!traded_token_is_seeded);
131     set_traded_token_as_seeded();
132     deposit_token(traded_token_seed_amount); 
133   }
134   
135   function seed_eth() public payable only_admin() {
136     require(!eth_is_seeded);
137     require(msg.value == eth_seed_amount);
138     set_eth_as_seeded();
139     deposit_eth(); 
140   }
141 
142   function seed_additional_token(uint256 _amount) public only_admin() {
143     require(market_is_open());
144     deposit_token(_amount);
145   }
146 
147   function seed_additional_eth() public payable only_admin() {
148     require(market_is_open());
149     deposit_eth();
150   }
151 
152   function market_is_open() private view returns(bool) {
153     return (eth_is_seeded && traded_token_is_seeded);
154   }
155 
156   function deactivate_trading() public only_admin() {
157     require(!trading_deactivated);
158     trading_deactivated = true;
159   }
160   
161   function reactivate_trading() public only_admin() {
162     require(trading_deactivated);
163     trading_deactivated = false;
164   }
165 
166   function get_amount_sell(uint256 _amount) public view returns(uint256) {
167     uint256 traded_token_balance_plus_amount_ = traded_token_balance.add(_amount);
168     return (eth_balance.mul(_amount)).div(traded_token_balance_plus_amount_);
169   }
170 
171   function get_amount_buy(uint256 _amount) public view returns(uint256) {
172     uint256 eth_balance_plus_amount_ = eth_balance.add(_amount);
173     return ((traded_token_balance).mul(_amount)).div(eth_balance_plus_amount_);
174   }
175   
176   function get_amount_minus_commission(uint256 _amount) private view returns(uint256) {
177     return (_amount.mul(uint256(1 ether).sub(commission_ratio))).div(1 ether);  
178 
179   }
180 
181   function activate_admin_commission() public only_admin() {
182     require(!admin_commission_activated);
183     admin_commission_activated = true;
184   }
185 
186   function deactivate_admin_comission() public only_admin() {
187     require(admin_commission_activated);
188     admin_commission_activated = false;
189   }
190 
191   function change_admin_commission(uint256 _new_commission_ratio) public only_admin() {
192      require(_new_commission_ratio != commission_ratio);
193      commission_ratio = _new_commission_ratio;
194   }
195 
196 
197   function complete_sell_exchange(uint256 _amount_give) private {
198     uint256 amount_get_ = get_amount_sell(_amount_give);
199     uint256 amount_get_minus_commission_ = get_amount_minus_commission(amount_get_);
200     uint256 platform_commission_ = (amount_get_.sub(amount_get_minus_commission_)).div(5);
201     uint256 admin_commission_ = ((amount_get_.sub(amount_get_minus_commission_)).mul(4)).div(5);
202     transfer_tokens_through_proxy_to_contract(msg.sender,this,_amount_give);
203     transfer_eth_from_contract(msg.sender,amount_get_minus_commission_);  
204     transfer_eth_from_contract(platform, platform_commission_);     
205     if(admin_commission_activated) {
206       transfer_eth_from_contract(admin, admin_commission_);     
207     }
208   }
209   
210   function complete_buy_exchange() private {
211     uint256 amount_get_ = get_amount_buy(msg.value);
212     uint256 amount_get_minus_commission_ = get_amount_minus_commission(amount_get_);
213     uint256 platform_commission_ = (amount_get_.sub(amount_get_minus_commission_)).div(5);
214     uint256 admin_commission_ = ((amount_get_.sub(amount_get_minus_commission_)).mul(4)).div(5);
215     transfer_eth_to_contract();
216     transfer_tokens_from_contract(msg.sender, amount_get_minus_commission_);
217     transfer_tokens_from_contract(platform, platform_commission_);
218     if(admin_commission_activated) {
219       transfer_tokens_from_contract(admin, admin_commission_);
220     }
221   }
222   
223   function sell_tokens(uint256 _amount_give) public trading_activated() {
224     require(market_is_open());
225     complete_sell_exchange(_amount_give);
226   }
227   
228   function buy_tokens() private trading_activated() {
229     require(market_is_open());
230     complete_buy_exchange();
231   }
232 
233   function() public payable {
234     buy_tokens();
235   }
236 
237 }
238 
239 contract TokenLiquidityPlatform { 
240 
241   address public admin;
242 
243   modifier only_admin() {
244       require(msg.sender == admin);
245       _;
246   }
247   
248   function TokenLiquidityPlatform() public { admin = msg.sender; }
249 
250   function create_a_new_market(address _traded_token, uint256 _base_token_seed_amount, uint256 _traded_token_seed_amount, uint256 _commission_ratio) public {
251     new TokenLiquidityMarket(_traded_token, _base_token_seed_amount, _traded_token_seed_amount, _commission_ratio);
252   }
253 
254   function withdraw_eth(uint256 _amount) public only_admin() {
255     admin.transfer(_amount);  
256   }
257 
258   function withdraw_token(address _token, uint256 _amount) public only_admin() {
259     require(Token(_token).transfer(admin, _amount));
260   }
261   
262 }