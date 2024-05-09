1 pragma solidity ^0.4.16;
2 
3 /*
4 
5 Enjin $1M Group Buyer
6 ========================
7 
8 Moves $1M worth of ETH into the Enjin presale multisig wallet
9 Enjin multisig wallet: 0xc4740f71323129669424d1Ae06c42AEE99da30e2
10 Modified version of /u/Cintix Monetha ICOBuyer
11 Modified by @ezra242
12 Fixes suggested by @icoscammer and @adevabhaktuni
13 
14 Please be aware users must possess the know-how to execute a function
15 in Parity or Ethereum Mist Wallet to withdraw their tokens from this contract
16 User must specify the token address manually to withdraw tokens
17 */
18 
19 // ERC20 Interface: https://github.com/ethereum/EIPs/issues/20
20 contract ERC20 {
21   function transfer(address _to, uint256 _value) returns (bool success);
22   function balanceOf(address _owner) constant returns (uint256 balance);
23 }
24 
25 contract EnjinBuyer {
26   // The minimum amount of eth required before the contract will buy in
27   // Enjin requires $1000000 @ 306.22 for 50% bonus
28   uint256 public eth_minimum = 3270 ether;
29 
30   // Store the amount of ETH deposited by each account.
31   mapping (address => uint256) public balances;
32   // Bounty for executing buy.
33   uint256 public buy_bounty;
34   // Bounty for executing withdrawals.
35   uint256 public withdraw_bounty;
36   // Track whether the contract has bought the tokens yet.
37   bool public bought_tokens;
38   // Record ETH value of tokens currently held by contract.
39   uint256 public contract_eth_value;
40   // Emergency kill switch in case a critical bug is found.
41   bool public kill_switch;
42   
43   // SHA3 hash of kill switch password.
44   bytes32 password_hash = 0x48e4977ec30c7c773515e0fbbfdce3febcd33d11a34651c956d4502def3eac09;
45   // Earliest time contract is allowed to buy into the crowdsale.
46   // This time constant is in the past, not important for Enjin buyer, we will only purchase once 
47   uint256 public earliest_buy_time = 1504188000;
48   // Maximum amount of user ETH contract will accept.  Reduces risk of hard cap related failure.
49   uint256 public eth_cap = 5000 ether;
50   // The developer address.
51   address public developer = 0xA4f8506E30991434204BC43975079aD93C8C5651;
52   // The crowdsale address.  Settable by the developer.
53   address public sale;
54   // The token address.  Settable by the developer.
55   ERC20 public token;
56   
57   // Allows the developer to set the crowdsale addresses.
58   function set_sale_address(address _sale) {
59     // Only allow the developer to set the sale addresses.
60     require(msg.sender == developer);
61     // Only allow setting the addresses once.
62     require(sale == 0x0);
63     // Set the crowdsale and token addresses.
64     sale = _sale;
65   }
66   
67   // DEPRECATED -- Users must execute withdraw and specify the token address explicitly
68   // This contract was formerly exploitable by a malicious dev zeroing out former
69   // user balances with a junk token
70   // Allows the developer to set the token address !
71   // Enjin does not release token address until public crowdsale
72   // In theory, developer could shaft everyone by setting incorrect token address
73   // Please be careful
74   //function set_token_address(address _token) {
75   // Only allow the developer to set token addresses.
76   //  require(msg.sender == developer);
77   // Set the token addresses.
78   //  token = ERC20(_token);
79   //}
80  
81   
82   // Allows the developer or anyone with the password to shut down everything except withdrawals in emergencies.
83   function activate_kill_switch(string password) {
84     // Only activate the kill switch if the sender is the developer or the password is correct.
85     require(msg.sender == developer || sha3(password) == password_hash);
86     // Store the claimed bounty in a temporary variable.
87     uint256 claimed_bounty = buy_bounty;
88     // Update bounty prior to sending to prevent recursive call.
89     buy_bounty = 0;
90     // Irreversibly activate the kill switch.
91     kill_switch = true;
92     // Send the caller their bounty for activating the kill switch.
93     msg.sender.transfer(claimed_bounty);
94   }
95   
96   // Withdraws all ETH deposited or tokens purchased by the given user and rewards the caller.
97   function withdraw(address user, address _token){
98     // Only allow withdrawal requests initiated by the user!
99     // This means every user of this contract must be versed in how to 
100     // execute a function on a contract. Every user must also supply
101     // the correct token address for Enjin. This address will not be known until
102     // October 3 2017
103     require(msg.sender == user);
104     // Only allow withdrawals after the contract has had a chance to buy in.
105     require(bought_tokens || now > earliest_buy_time + 1 hours);
106     // Short circuit to save gas if the user doesn't have a balance.
107     if (balances[user] == 0) return;
108     // If the contract failed to buy into the sale, withdraw the user's ETH.
109     if (!bought_tokens) {
110       // Store the user's balance prior to withdrawal in a temporary variable.
111       uint256 eth_to_withdraw = balances[user];
112       // Update the user's balance prior to sending ETH to prevent recursive call.
113       balances[user] = 0;
114       // Return the user's funds.  Throws on failure to prevent loss of funds.
115       user.transfer(eth_to_withdraw);
116     }
117     // Withdraw the user's tokens if the contract has purchased them.
118     else {
119       // Set token to the token specified by the user
120       // Should work in cases where the user specifies a token not held by the contract
121       // Should also work in cases where the user specifies a worthless token held by the contract
122       // In aforementioned case, the user will zero out their balance
123       // and receive their worthless token, but affect no one else
124       token = ERC20(_token);
125       // Retrieve current token balance of contract.
126       uint256 contract_token_balance = token.balanceOf(address(this));
127       // Disallow token withdrawals if there are no tokens to withdraw.
128       require(contract_token_balance != 0);
129       // Store the user's token balance in a temporary variable.
130       uint256 tokens_to_withdraw = (balances[user] * contract_token_balance) / contract_eth_value;
131       // Update the value of tokens currently held by the contract.
132       contract_eth_value -= balances[user];
133       // Update the user's balance prior to sending to prevent recursive call.
134       balances[user] = 0;
135       // 1% fee if contract successfully bought tokens.
136       //uint256 fee = tokens_to_withdraw / 100;
137       // Send the fee to the developer.
138       //require(token.transfer(developer, fee));
139       // Send the funds.  Throws on failure to prevent loss of funds.
140       require(token.transfer(user, tokens_to_withdraw));
141     }
142     // Each withdraw call earns 1% of the current withdraw bounty.
143     uint256 claimed_bounty = withdraw_bounty / 100;
144     // Update the withdraw bounty prior to sending to prevent recursive call.
145     withdraw_bounty -= claimed_bounty;
146     // Send the caller their bounty for withdrawing on the user's behalf.
147     msg.sender.transfer(claimed_bounty);
148   }
149   
150   // Allows developer to add ETH to the buy execution bounty.
151   function add_to_buy_bounty() payable {
152     // Only allow the developer to contribute to the buy execution bounty.
153     require(msg.sender == developer);
154     // Update bounty to include received amount.
155     buy_bounty += msg.value;
156   }
157   
158   // Allows developer to add ETH to the withdraw execution bounty.
159   function add_to_withdraw_bounty() payable {
160     // Only allow the developer to contribute to the buy execution bounty.
161     require(msg.sender == developer);
162     // Update bounty to include received amount.
163     withdraw_bounty += msg.value;
164   }
165   
166   // Buys tokens in the crowdsale and rewards the caller, callable by anyone.
167   function claim_bounty(){
168     // If we don't have eth_minimum eth in contract, don't buy in
169     // Enjin requires $1M minimum for 50% bonus
170     if (this.balance < eth_minimum) return;
171 
172     // Short circuit to save gas if the contract has already bought tokens.
173     if (bought_tokens) return;
174     // Short circuit to save gas if the earliest buy time hasn't been reached.
175     if (now < earliest_buy_time) return;
176     // Short circuit to save gas if kill switch is active.
177     if (kill_switch) return;
178     // Disallow buying in if the developer hasn't set the sale address yet.
179     require(sale != 0x0);
180     // Record that the contract has bought the tokens.
181     bought_tokens = true;
182     // Store the claimed bounty in a temporary variable.
183     uint256 claimed_bounty = buy_bounty;
184     // Update bounty prior to sending to prevent recursive call.
185     buy_bounty = 0;
186     // Record the amount of ETH sent as the contract's current value.
187     contract_eth_value = this.balance - (claimed_bounty + withdraw_bounty);
188     // Transfer all the funds (less the bounties) to the crowdsale address
189     // to buy tokens.  Throws if the crowdsale hasn't started yet or has
190     // already completed, preventing loss of funds.
191     require(sale.call.value(contract_eth_value)());
192     // Send the caller their bounty for buying tokens for the contract.
193     msg.sender.transfer(claimed_bounty);
194   }
195   
196   // Default function.  Called when a user sends ETH to the contract.
197   function () payable {
198     // Disallow deposits if kill switch is active.
199     require(!kill_switch);
200     // Only allow deposits if the contract hasn't already purchased the tokens.
201     require(!bought_tokens);
202     // Only allow deposits that won't exceed the contract's ETH cap.
203     require(this.balance < eth_cap);
204     // Update records of deposited ETH to include the received amount.
205     balances[msg.sender] += msg.value;
206   }
207 }