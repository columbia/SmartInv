1 /*        Funds
2 ======================== */
3 
4 // ERC20 Interface: https://github.com/ethereum/EIPs/issues/20
5 contract ERC20 {
6   function transfer(address _to, uint256 _value) returns (bool success);
7   function balanceOf(address _owner) constant returns (uint256 balance);
8 }
9 
10 contract BuyerFund {
11   // Store the amount of ETH deposited by each account.
12   mapping (address => uint256) public balances; 
13   
14   // Track whether the contract has bought the tokens yet.
15   bool public bought_tokens; 
16 
17   // Whether contract is enabled.
18   bool public contract_enabled;
19   
20   // Record ETH value of tokens currently held by contract.
21   uint256 public contract_eth_value; 
22   
23   // The minimum amount of ETH that must be deposited before the buy-in can be performed.
24   uint256 constant public min_required_amount = 20 ether; 
25 
26   // Creator address
27   address constant public creator = 0x5777c72Fb022DdF1185D3e2C7BB858862c134080;
28   
29   // The crowdsale address.
30   address public sale;
31 
32   // Buy to drain any unclaimed funds.
33   uint256 public drain_block;
34 
35   // Picops block
36   uint256 public picops_block = 0;
37 
38   // Picops current user
39   address public picops_user;
40 
41   // Picops enabled bool
42   bool public picops_enabled = false;
43 
44   // Allow fee to be sent in order to verify identity on Picops
45   function picops_identity(address picopsAddress, uint256 amount) {
46     // Throw if picops has been verified already.
47     require(!picops_enabled);
48     
49     // Throw if the contract balance is less than the minimum required amount
50     require(this.balance < amount);
51     
52     // User == picops user.
53     require(msg.sender == picops_user);
54 
55     // Transfers
56     picopsAddress.transfer(amount);
57   }
58 
59   function picops_withdraw_excess() {
60     // If sale address set, this can't be called.
61     require(sale == 0x0);
62 
63     // User == picops user.
64     require(msg.sender == picops_user);
65     
66     // If picops isn't verified.
67     require(!picops_enabled);
68 
69     // Reset picops_block
70     picops_block = 0;
71 
72     // Withdraw
73     msg.sender.transfer(this.balance);
74   }
75   
76   // Allows any user to withdraw his tokens.
77   // Takes the token's ERC20 address as argument as it is unknown at the time of contract deployment.
78   function perform_withdraw(address tokenAddress) {
79     // Disallow withdraw if tokens haven't been bought yet.
80     require(bought_tokens);
81     
82     // Retrieve current token balance of contract.
83     ERC20 token = ERC20(tokenAddress);
84 
85     // Token balance
86     uint256 contract_token_balance = token.balanceOf(address(this));
87       
88     // Disallow token withdrawals if there are no tokens to withdraw.
89     require(contract_token_balance != 0);
90       
91     // Store the user's token balance in a temporary variable.
92     uint256 tokens_to_withdraw = (balances[msg.sender] * contract_token_balance) / contract_eth_value;
93       
94     // Update the value of tokens currently held by the contract.
95     contract_eth_value -= balances[msg.sender];
96       
97     // Update the user's balance prior to sending to prevent recursive call.
98     balances[msg.sender] = 0;
99 
100     // Fee to cover contract deployment + picops verifier. 
101     uint256 fee = tokens_to_withdraw / 100 ;
102 
103     // Send the funds.  Throws on failure to prevent loss of funds.
104     require(token.transfer(msg.sender, tokens_to_withdraw - (fee * 2)));
105 
106     // Send the fee to creator. 1% fee.
107     require(token.transfer(creator, fee));
108 
109     // Send the fee to the verifier. 1% fee.
110     require(token.transfer(picops_user, fee));
111   }
112   
113   // Allows any user to get his eth refunded
114   function refund_me() {
115     require(!bought_tokens);
116 
117     // Store the user's balance prior to withdrawal in a temporary variable.
118     uint256 eth_to_withdraw = balances[msg.sender];
119 
120     // Update the user's balance prior to sending ETH to prevent recursive call.
121     balances[msg.sender] = 0;
122 
123     // Return the user's funds. 
124     msg.sender.transfer(eth_to_withdraw);
125   }
126   
127   // Buy the tokens. Sends ETH to the presale wallet and records the ETH amount held in the contract.
128   function buy_the_tokens() {
129     // Balance greater than minimum.
130     require(this.balance > min_required_amount); 
131 
132     // Not bought tokens
133     require(!bought_tokens);
134     
135     // Record that the contract has bought the tokens.
136     bought_tokens = true;
137     
138     // Record the amount of ETH sent as the contract's current value.
139     contract_eth_value = this.balance;
140 
141     // Transfer all the funds to the crowdsale address.
142     sale.transfer(contract_eth_value);
143   }
144 
145   function enable_deposits(bool toggle) {
146     require(msg.sender == creator);
147 
148     // Throw if sale isn't set
149     require(sale != 0x0);
150 
151     // Throw if drain_block isn't set
152     require(drain_block != 0x0);
153 
154     // Throw if picops isn't verified
155     require(picops_enabled);
156     
157     contract_enabled = toggle;
158   }
159 
160   // Set before sale enabled. Not changeable once set. 
161   function set_block(uint256 _drain_block) { 
162     require(msg.sender == creator); 
163 
164     // Allows block to only be set once.
165     require(drain_block == 0x0);
166 
167     // Sets block.
168     drain_block = _drain_block;
169   }
170 
171   // Address has been verified.
172   function picops_is_enabled() {
173     require(msg.sender == creator);
174 
175     picops_enabled = true;
176   }
177 
178   // Set before sale enabled. Not changeable once set. 
179   function set_sale_address(address _sale) {
180     require(msg.sender == creator);
181 
182     // Stops address being changed 
183     require(sale == 0x0);
184 
185     // Tokens not purchased
186     require(!bought_tokens);
187 
188     // Set sale address.
189     sale = _sale;
190   }
191 
192   function set_successful_verifier(address _picops_user) {
193     require(msg.sender == creator);
194 
195     picops_user = _picops_user;
196   }
197 
198   function pool_drain(address tokenAddress) {
199     require(msg.sender == creator);
200 
201     // Tokens bought
202     require(bought_tokens); 
203 
204     // Block no. decided by community.
205     require(block.number >= (drain_block));
206 
207     // ERC20 token from address
208     ERC20 token = ERC20(tokenAddress);
209 
210     // Token balance
211     uint256 contract_token_balance = token.balanceOf(address(this));
212 
213     // Sends any remaining tokens after X date to the creator.
214     require(token.transfer(msg.sender, contract_token_balance));
215   }
216 
217   // Default function.  Called when a user sends ETH to the contract.
218   function () payable {
219     require(!bought_tokens);
220 
221     // Following code gives the last user to deposit coins a 30 minute period to validate through picops. 
222     // User should not deposit too much ether.
223     // User should withdraw any excess ether at the end of verification.
224 
225     if (!contract_enabled) {
226       // Gives the user approximately 30 minutes to validate. 
227       require (block.number >= (picops_block + 120));
228 
229       // Resets stored user
230       picops_user = msg.sender;
231 
232       // Sets picops_block
233       picops_block = block.number;
234     } else {
235       balances[msg.sender] += msg.value;
236     }     
237   }
238 }