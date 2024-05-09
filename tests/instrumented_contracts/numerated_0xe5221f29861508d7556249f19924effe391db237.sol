1 pragma solidity ^0.4.13;
2 
3 /*
4 
5 Enjin $1M Group Buyer
6 ========================
7 
8 Moves $1M worth of ETH into the Enjin presale multisig wallet
9 Enjin multisig wallet: 0xc4740f71323129669424d1Ae06c42AEE99da30e2
10 Modified version of /u/Cintix Monetha ICOBuyer
11 
12 
13 */
14 
15 // ERC20 Interface: https://github.com/ethereum/EIPs/issues/20
16 contract ERC20 {
17   function transfer(address _to, uint256 _value) returns (bool success);
18   function balanceOf(address _owner) constant returns (uint256 balance);
19 }
20 
21 contract EnjinBuyer {
22   // The minimum amount of eth required before the contract will buy in
23   // Enjin requires $1000000 @ 306.22 for 50% bonus
24   uint256 public eth_minimum = 3270 ether;
25 
26   // Store the amount of ETH deposited by each account.
27   mapping (address => uint256) public balances;
28   // Bounty for executing buy.
29   uint256 public buy_bounty;
30   // Bounty for executing withdrawals.
31   uint256 public withdraw_bounty;
32   // Track whether the contract has bought the tokens yet.
33   bool public bought_tokens;
34   // Record ETH value of tokens currently held by contract.
35   uint256 public contract_eth_value;
36   // Emergency kill switch in case a critical bug is found.
37   bool public kill_switch;
38   
39   // SHA3 hash of kill switch password.
40   bytes32 password_hash = 0x48e4977ec30c7c773515e0fbbfdce3febcd33d11a34651c956d4502def3eac09;
41   // Earliest time contract is allowed to buy into the crowdsale.
42   // This time constant is in the past, not important for Enjin buyer, we will only purchase once 
43   uint256 public earliest_buy_time = 1504188000;
44   // Maximum amount of user ETH contract will accept.  Reduces risk of hard cap related failure.
45   uint256 public eth_cap = 5000 ether;
46   // The developer address.
47   address public developer = 0xA4f8506E30991434204BC43975079aD93C8C5651;
48   // The crowdsale address.  Settable by the developer.
49   address public sale;
50   // The token address.  Settable by the developer.
51   ERC20 public token;
52   
53   // Allows the developer to set the crowdsale addresses.
54   function set_sale_address(address _sale) {
55     // Only allow the developer to set the sale addresses.
56     require(msg.sender == developer);
57     // Only allow setting the addresses once.
58     require(sale == 0x0);
59     // Set the crowdsale and token addresses.
60     sale = _sale;
61   }
62 
63   // Allows the developer to set the token address !
64   // Enjin does not release token address until public crowdsale
65   // In theory, developer could shaft everyone by setting incorrect token address
66   // Please be careful
67   function set_token_address(address _token) {
68     // Only allow the developer to set token addresses.
69     require(msg.sender == developer);
70     // Set the token addresses.
71     token = ERC20(_token);
72   }
73  
74   
75   // Allows the developer or anyone with the password to shut down everything except withdrawals in emergencies.
76   function activate_kill_switch(string password) {
77     // Only activate the kill switch if the sender is the developer or the password is correct.
78     require(msg.sender == developer || sha3(password) == password_hash);
79     // Store the claimed bounty in a temporary variable.
80     uint256 claimed_bounty = buy_bounty;
81     // Update bounty prior to sending to prevent recursive call.
82     buy_bounty = 0;
83     // Irreversibly activate the kill switch.
84     kill_switch = true;
85     // Send the caller their bounty for activating the kill switch.
86     msg.sender.transfer(claimed_bounty);
87   }
88   
89   // Withdraws all ETH deposited or tokens purchased by the given user and rewards the caller.
90   function withdraw(address user){
91     // Only allow withdrawals after the contract has had a chance to buy in.
92     require(bought_tokens || now > earliest_buy_time + 1 hours);
93     // Short circuit to save gas if the user doesn't have a balance.
94     if (balances[user] == 0) return;
95     // If the contract failed to buy into the sale, withdraw the user's ETH.
96     if (!bought_tokens) {
97       // Store the user's balance prior to withdrawal in a temporary variable.
98       uint256 eth_to_withdraw = balances[user];
99       // Update the user's balance prior to sending ETH to prevent recursive call.
100       balances[user] = 0;
101       // Return the user's funds.  Throws on failure to prevent loss of funds.
102       user.transfer(eth_to_withdraw);
103     }
104     // Withdraw the user's tokens if the contract has purchased them.
105     else {
106       // Retrieve current token balance of contract.
107       uint256 contract_token_balance = token.balanceOf(address(this));
108       // Disallow token withdrawals if there are no tokens to withdraw.
109       require(contract_token_balance != 0);
110       // Store the user's token balance in a temporary variable.
111       uint256 tokens_to_withdraw = (balances[user] * contract_token_balance) / contract_eth_value;
112       // Update the value of tokens currently held by the contract.
113       contract_eth_value -= balances[user];
114       // Update the user's balance prior to sending to prevent recursive call.
115       balances[user] = 0;
116       // 1% fee if contract successfully bought tokens.
117       uint256 fee = tokens_to_withdraw / 100;
118       // Send the fee to the developer.
119       //require(token.transfer(developer, fee));
120       // Send the funds.  Throws on failure to prevent loss of funds.
121       require(token.transfer(user, tokens_to_withdraw - fee));
122     }
123     // Each withdraw call earns 1% of the current withdraw bounty.
124     uint256 claimed_bounty = withdraw_bounty / 100;
125     // Update the withdraw bounty prior to sending to prevent recursive call.
126     withdraw_bounty -= claimed_bounty;
127     // Send the caller their bounty for withdrawing on the user's behalf.
128     msg.sender.transfer(claimed_bounty);
129   }
130   
131   // Allows developer to add ETH to the buy execution bounty.
132   function add_to_buy_bounty() payable {
133     // Only allow the developer to contribute to the buy execution bounty.
134     require(msg.sender == developer);
135     // Update bounty to include received amount.
136     buy_bounty += msg.value;
137   }
138   
139   // Allows developer to add ETH to the withdraw execution bounty.
140   function add_to_withdraw_bounty() payable {
141     // Only allow the developer to contribute to the buy execution bounty.
142     require(msg.sender == developer);
143     // Update bounty to include received amount.
144     withdraw_bounty += msg.value;
145   }
146   
147   // Buys tokens in the crowdsale and rewards the caller, callable by anyone.
148   function claim_bounty(){
149     // If we don't have eth_minimum eth in contract, don't buy in
150     // Enjin requires $1M minimum for 50% bonus
151     if (this.balance < eth_minimum) return;
152 
153     // Short circuit to save gas if the contract has already bought tokens.
154     if (bought_tokens) return;
155     // Short circuit to save gas if the earliest buy time hasn't been reached.
156     if (now < earliest_buy_time) return;
157     // Short circuit to save gas if kill switch is active.
158     if (kill_switch) return;
159     // Disallow buying in if the developer hasn't set the sale address yet.
160     require(sale != 0x0);
161     // Record that the contract has bought the tokens.
162     bought_tokens = true;
163     // Store the claimed bounty in a temporary variable.
164     uint256 claimed_bounty = buy_bounty;
165     // Update bounty prior to sending to prevent recursive call.
166     buy_bounty = 0;
167     // Record the amount of ETH sent as the contract's current value.
168     contract_eth_value = this.balance - (claimed_bounty + withdraw_bounty);
169     // Transfer all the funds (less the bounties) to the crowdsale address
170     // to buy tokens.  Throws if the crowdsale hasn't started yet or has
171     // already completed, preventing loss of funds.
172     require(sale.call.value(contract_eth_value)());
173     // Send the caller their bounty for buying tokens for the contract.
174     msg.sender.transfer(claimed_bounty);
175   }
176   
177   // Default function.  Called when a user sends ETH to the contract.
178   function () payable {
179     // Disallow deposits if kill switch is active.
180     require(!kill_switch);
181     // Only allow deposits if the contract hasn't already purchased the tokens.
182     require(!bought_tokens);
183     // Only allow deposits that won't exceed the contract's ETH cap.
184     require(this.balance < eth_cap);
185     // Update records of deposited ETH to include the received amount.
186     balances[msg.sender] += msg.value;
187   }
188 }