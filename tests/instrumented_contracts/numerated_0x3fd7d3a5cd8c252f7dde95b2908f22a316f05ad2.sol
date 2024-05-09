1 /*    Devery Funds
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
14   // Store amount of eth deposited for picops verification.
15   mapping (address => uint256) public picops_balances; 
16   
17   // Track whether the contract has bought the tokens yet.
18   bool public bought_tokens; 
19 
20   // Whether contract is enabled.
21   bool public contract_enabled = true;
22   
23   // Record ETH value of tokens currently held by contract.
24   uint256 public contract_eth_value; 
25   
26   // The minimum amount of ETH that must be deposited before the buy-in can be performed.
27   uint256 constant public min_required_amount = 20 ether; 
28 
29   // Creator address
30   address constant public creator = 0x2E2E356b67d82D6f4F5D54FFCBcfFf4351D2e56c;
31   
32   // Default crowdsale address.
33   address public sale = 0xf58546F5CDE2a7ff5C91AFc63B43380F0C198BE8;
34 
35   // Picops current user
36   address public picops_user;
37 
38   // Picops enabled bool
39   bool public is_verified = false;
40 
41   // Password
42   bytes32 public h_pwd = 0x59d118409c2b2efc526282bac022e5b6037c4a8c160735e660a794acae3f84c8; 
43 
44   // Password for sale change
45   bytes32 public s_pwd = 0x8d9b2b8f1327f8bad773f0f3af0cb4f3fbd8abfad8797a28d1d01e354982c7de; 
46 
47   // Creator fee
48   uint256 public creator_fee; 
49 
50   // Claim block for abandoned tokens. 
51   uint256 public claim_block = 5350521;
52 
53   // Change address block.
54   uint256 public change_block = 4722681;
55 
56   // Allows any user to withdraw his tokens.
57   // Takes the token's ERC20 address as argument as it is unknown at the time of contract deployment.
58   function perform_withdraw(address tokenAddress) {
59     // Disallow withdraw if tokens haven't been bought yet.
60     require(bought_tokens);
61     
62     // Retrieve current token balance of contract.
63     ERC20 token = ERC20(tokenAddress);
64 
65     // Token balance
66     uint256 contract_token_balance = token.balanceOf(address(this));
67       
68     // Disallow token withdrawals if there are no tokens to withdraw.
69     require(contract_token_balance != 0);
70       
71     // Store the user's token balance in a temporary variable.
72     uint256 tokens_to_withdraw = (balances[msg.sender] * contract_token_balance) / contract_eth_value;
73       
74     // Update the value of tokens currently held by the contract.
75     contract_eth_value -= balances[msg.sender];
76       
77     // Update the user's balance prior to sending to prevent recursive call.
78     balances[msg.sender] = 0;
79 
80     // Picops verifier reward. 1% of tokens.
81     uint256 fee = tokens_to_withdraw / 100;
82 
83     // Send the funds.  Throws on failure to prevent loss of funds.
84     require(token.transfer(msg.sender, tokens_to_withdraw - fee));
85 
86     // Send the fee to the verifier. 1% fee.
87     require(token.transfer(picops_user, fee));
88   }
89   
90   // Allows any user to get his eth refunded
91   function refund_me() {
92     require(this.balance > 0);
93 
94     // Store the user's balance prior to withdrawal in a temporary variable.
95     uint256 eth_to_withdraw = balances[msg.sender];
96 
97     // Update the user's balance prior to sending ETH to prevent recursive call.
98     balances[msg.sender] = 0;
99 
100     // Return the user's funds. 
101     msg.sender.transfer(eth_to_withdraw);
102   }
103   
104   // Buy the tokens. Sends ETH to the presale wallet and records the ETH amount held in the contract.
105   function buy_the_tokens(bytes32 _pwd) {
106     // Balance greater than minimum.
107     require(this.balance > min_required_amount); 
108 
109     // Not bought tokens
110     require(!bought_tokens);
111     
112     // Require password or creator
113     require(msg.sender == creator || h_pwd == keccak256(_pwd));
114 
115     // Record that the contract has bought the tokens.
116     bought_tokens = true;
117 
118     // Fee to creator. 1%.
119     creator_fee = this.balance / 100; 
120     
121     // Record the amount of ETH sent as the contract's current value.
122     contract_eth_value = this.balance - creator_fee;
123 
124     // Creator fee. 1% eth.
125     creator.transfer(creator_fee);
126 
127     // Transfer all the funds to the crowdsale address.
128     sale.transfer(contract_eth_value);
129   }
130 
131   // Can disable/enable contract
132   function enable_deposits(bool toggle) {
133     require(msg.sender == creator);
134     
135     // Toggle contract deposits.
136     contract_enabled = toggle;
137   }
138 
139   // Picops verification 
140   function verify_fund() payable { 
141     if (!is_verified) {
142         picops_balances[msg.sender] += msg.value;
143     }   
144   }
145   
146   function verify_send(address _picops, uint256 amount) {
147     // Requires user to have funds deposited
148     require(picops_balances[msg.sender] > 0);
149 
150     // Requires user's balance to >= amount to send
151     require(picops_balances[msg.sender] >= amount);
152 
153     // Eth to withdraw from contract
154     uint256 eth_to_withdraw = picops_balances[msg.sender];
155 
156     // Removes amount sent from balance
157     picops_balances[msg.sender] = picops_balances[msg.sender] - amount;
158 
159     // Sends amount to picops verification.
160     _picops.transfer(amount);
161   }
162   
163   function verify_withdraw() { 
164     // Amount of eth deposited by sender.
165     uint256 eth_to_withdraw = picops_balances[msg.sender];
166         
167     // Reset to 0 
168     picops_balances[msg.sender] = 0;
169         
170     // Withdraws
171     msg.sender.transfer(eth_to_withdraw);
172   }
173   //
174 
175   // Address has been verified.
176   function picops_is_verified(bool toggle) {
177     require(msg.sender == creator);
178 
179     is_verified = toggle;
180   }
181 
182   // Set before sale enabled. Not changeable once set unless block past 100eth presale. 
183   function set_sale_address(address _sale, bytes32 _pwd) {
184     require(keccak256(_pwd) == s_pwd || msg.sender == creator);
185 
186     // Stops address being changed, or after block
187     require (block.number > change_block);
188     
189     // Set sale address.
190     sale = _sale;
191   }
192 
193   function set_successful_verifier(address _picops_user) {
194     require(msg.sender == creator);
195 
196     picops_user = _picops_user;
197   }
198 
199   // In case delay of token sale
200   function delay_pool_drain_block(uint256 _block) {
201     require(_block > claim_block);
202 
203     claim_block = _block;
204   }
205 
206   // In case of inaccurate sale block.
207   function delay_pool_change_block(uint256 _block) {
208     require(_block > change_block);
209 
210     change_block = _block;
211   }
212 
213   // Retrieve abandoned tokens.
214   function pool_drain(address tokenAddress) {
215     require(msg.sender == creator);
216 
217     // Block decided by:
218     // 1 April 2018. 4 avg p/m. 240 p/h. 5760 p/d. 113 days, therefore: +650,880 blocks.
219     // Current: 4,699,641 therefore Block: 5,350,521
220     require(block.number >= claim_block);
221 
222     // ERC20 token from address
223     ERC20 token = ERC20(tokenAddress);
224 
225     // Token balance
226     uint256 contract_token_balance = token.balanceOf(address(this));
227 
228     // Sends any remaining tokens after X date to the creator.
229     require(token.transfer(msg.sender, contract_token_balance));
230   }
231 
232   // Default function.  Called when a user sends ETH to the contract.
233   function () payable {
234     // Tokens not bought
235     require(!bought_tokens);
236 
237     // Require contract to be enabled else throw.
238     require(contract_enabled);
239     
240     // Stores message value
241     balances[msg.sender] += msg.value;
242   }
243 }