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
35   function balanceOf(address _owner) public returns (uint256 balance);      
36 
37 }
38 
39 contract TokenLiquidityMarket { 
40 
41   using SafeMath for uint256;  
42 
43   address public platform;
44   address public admin;
45   address public traded_token;
46   
47   uint256 public eth_seed_amount;
48   uint256 public traded_token_seed_amount;
49   uint256 public commission_ratio;
50   uint256 public eth_balance;
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
80   function withdraw_arbitrary_token(address _token) public only_admin() {
81       require(_token != traded_token);
82       Token(_token).transfer(admin, Token(_token).balanceOf(address(this)));
83   }
84 
85   function transfer_tokens_through_proxy_to_contract(address _from, address _to, uint256 _amount) private {
86     require(Token(traded_token).transferFrom(_from,_to,_amount));
87   }  
88 
89   function transfer_tokens_from_contract(address _to, uint256 _amount) private {
90     require(Token(traded_token).transfer(_to,_amount));
91   }
92 
93   function transfer_eth_to_contract() private {
94     eth_balance = eth_balance.add(msg.value);
95   }
96   
97   function transfer_eth_from_contract(address _to, uint256 _amount) private {
98     eth_balance = eth_balance.sub(_amount);
99     _to.transfer(_amount);
100   }
101   
102   function deposit_token(uint256 _amount) private { 
103     transfer_tokens_through_proxy_to_contract(msg.sender, this, _amount);
104   }  
105 
106   function deposit_eth() private { 
107     transfer_eth_to_contract();
108   }  
109   
110   function withdraw_token(uint256 _amount) public only_admin() {
111     transfer_tokens_from_contract(admin, _amount);
112   }
113   
114   function withdraw_eth(uint256 _amount) public only_admin() {
115     transfer_eth_from_contract(admin, _amount);
116   }
117 
118   function set_traded_token_as_seeded() private {
119     traded_token_is_seeded = true;
120   }
121 
122   function set_eth_as_seeded() private {
123     eth_is_seeded = true;
124   }
125 
126   function seed_traded_token() public only_admin() {
127     require(!traded_token_is_seeded);
128     set_traded_token_as_seeded();
129     deposit_token(traded_token_seed_amount); 
130   }
131   
132   function seed_eth() public payable only_admin() {
133     require(!eth_is_seeded);
134     require(msg.value == eth_seed_amount);
135     set_eth_as_seeded();
136     deposit_eth(); 
137   }
138 
139   function seed_additional_token(uint256 _amount) public only_admin() {
140     require(market_is_open());
141     deposit_token(_amount);
142   }
143 
144   function seed_additional_eth() public payable only_admin() {
145     require(market_is_open());
146     deposit_eth();
147   }
148 
149   function market_is_open() private view returns(bool) {
150     return (eth_is_seeded && traded_token_is_seeded);
151   }
152 
153   function deactivate_trading() public only_admin() {
154     require(!trading_deactivated);
155     trading_deactivated = true;
156   }
157   
158   function reactivate_trading() public only_admin() {
159     require(trading_deactivated);
160     trading_deactivated = false;
161   }
162 
163   function get_amount_sell(uint256 _amount) public view returns(uint256) {
164     uint256 traded_token_balance_plus_amount_ = Token(traded_token).balanceOf(address(this)).add(_amount);
165     return (eth_balance.mul(_amount)).div(traded_token_balance_plus_amount_);
166   }
167 
168   function get_amount_buy(uint256 _amount) public view returns(uint256) {
169     uint256 eth_balance_plus_amount_ = eth_balance.add(_amount);
170     return (Token(traded_token).balanceOf(address(this)).mul(_amount)).div(eth_balance_plus_amount_);
171   }
172   
173   function get_amount_minus_commission(uint256 _amount) private view returns(uint256) {
174     return (_amount*(1 ether - commission_ratio))/(1 ether);  
175   }
176 
177   function activate_admin_commission() public only_admin() {
178     require(!admin_commission_activated);
179     admin_commission_activated = true;
180   }
181 
182   function deactivate_admin_comission() public only_admin() {
183     require(admin_commission_activated);
184     admin_commission_activated = false;
185   }
186 
187   function change_admin_commission(uint256 _new_commission_ratio) public only_admin() {
188      require(_new_commission_ratio != commission_ratio);
189      commission_ratio = _new_commission_ratio;
190   }
191 
192 
193   function complete_sell_exchange(uint256 _amount_give) private {
194     uint256 amount_get_ = get_amount_sell(_amount_give);
195     uint256 amount_get_minus_commission_ = get_amount_minus_commission(amount_get_);
196     uint256 platform_commission_ = (amount_get_ - amount_get_minus_commission_) / 5;
197     uint256 admin_commission_ = ((amount_get_ - amount_get_minus_commission_) * 4) / 5;
198     transfer_tokens_through_proxy_to_contract(msg.sender,this,_amount_give);
199     transfer_eth_from_contract(msg.sender,amount_get_minus_commission_);  
200     transfer_eth_from_contract(platform, platform_commission_);     
201     if(admin_commission_activated) {
202       transfer_eth_from_contract(admin, admin_commission_);     
203     }
204   }
205   
206   function complete_buy_exchange() private {
207     uint256 amount_give_ = msg.value;
208     uint256 amount_get_ = get_amount_buy(amount_give_);
209     uint256 amount_get_minus_commission_ = get_amount_minus_commission(amount_get_);
210     uint256 platform_commission_ = (amount_get_ - amount_get_minus_commission_) / 5;
211     uint256 admin_commission_ = ((amount_get_ - amount_get_minus_commission_) * 4) / 5;
212     transfer_eth_to_contract();
213     transfer_tokens_from_contract(msg.sender, amount_get_minus_commission_);
214     transfer_tokens_from_contract(platform, platform_commission_);
215     if(admin_commission_activated) {
216       transfer_tokens_from_contract(admin, admin_commission_);
217     }
218   }
219   
220   function sell_tokens(uint256 _amount_give) public trading_activated() {
221     require(market_is_open());
222     complete_sell_exchange(_amount_give);
223   }
224   
225   function buy_tokens() private trading_activated() {
226     require(market_is_open());
227     complete_buy_exchange();
228   }
229 
230   function() public payable {
231     buy_tokens();
232   }
233 
234 }