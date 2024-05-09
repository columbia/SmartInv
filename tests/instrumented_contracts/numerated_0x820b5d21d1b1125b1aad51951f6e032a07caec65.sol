1 pragma solidity ^0.4.13;
2 
3 /*
4 
5 Monetha Buyer
6 ========================
7 
8 Buys Monetha tokens from the crowdsale on your behalf.
9 Author: /u/Cintix
10 
11 */
12 
13 // ERC20 Interface: https://github.com/ethereum/EIPs/issues/20
14 contract ERC20 {
15   function transfer(address _to, uint256 _value) returns (bool success);
16   function balanceOf(address _owner) constant returns (uint256 balance);
17 }
18 
19 contract MonethaBuyer {
20   // Store the amount of ETH deposited by each account.
21   mapping (address => uint256) public balances;
22   // Bounty for executing buy.
23   uint256 public buy_bounty;
24   // Bounty for executing withdrawals.
25   uint256 public withdraw_bounty;
26   // Track whether the contract has bought the tokens yet.
27   bool public bought_tokens;
28   // Record ETH value of tokens currently held by contract.
29   uint256 public contract_eth_value;
30   // Emergency kill switch in case a critical bug is found.
31   bool public kill_switch;
32   
33   // SHA3 hash of kill switch password.
34   bytes32 password_hash = 0x8223cba4d8b54dc1e03c41c059667f6adb1a642a0a07bef5a9d11c18c4f14612;
35   // Earliest time contract is allowed to buy into the crowdsale.
36   uint256 public earliest_buy_time = 1504188000;
37   // Maximum amount of user ETH contract will accept.  Reduces risk of hard cap related failure.
38   uint256 public eth_cap = 30000 ether;
39   // The developer address.
40   address public developer = 0x000Fb8369677b3065dE5821a86Bc9551d5e5EAb9;
41   // The crowdsale address.  Settable by the developer.
42   address public sale;
43   // The token address.  Settable by the developer.
44   ERC20 public token;
45   
46   // Allows the developer to set the crowdsale and token addresses.
47   function set_addresses(address _sale, address _token) {
48     // Only allow the developer to set the sale and token addresses.
49     require(msg.sender == developer);
50     // Only allow setting the addresses once.
51     require(sale == 0x0);
52     // Set the crowdsale and token addresses.
53     sale = _sale;
54     token = ERC20(_token);
55   }
56   
57   // Allows the developer or anyone with the password to shut down everything except withdrawals in emergencies.
58   function activate_kill_switch(string password) {
59     // Only activate the kill switch if the sender is the developer or the password is correct.
60     require(msg.sender == developer || sha3(password) == password_hash);
61     // Store the claimed bounty in a temporary variable.
62     uint256 claimed_bounty = buy_bounty;
63     // Update bounty prior to sending to prevent recursive call.
64     buy_bounty = 0;
65     // Irreversibly activate the kill switch.
66     kill_switch = true;
67     // Send the caller their bounty for activating the kill switch.
68     msg.sender.transfer(claimed_bounty);
69   }
70   
71   // Withdraws all ETH deposited or tokens purchased by the given user and rewards the caller.
72   function withdraw(address user){
73     // Only allow withdrawals after the contract has had a chance to buy in.
74     require(bought_tokens || now > earliest_buy_time + 1 hours);
75     // Short circuit to save gas if the user doesn't have a balance.
76     if (balances[user] == 0) return;
77     // If the contract failed to buy into the sale, withdraw the user's ETH.
78     if (!bought_tokens) {
79       // Store the user's balance prior to withdrawal in a temporary variable.
80       uint256 eth_to_withdraw = balances[user];
81       // Update the user's balance prior to sending ETH to prevent recursive call.
82       balances[user] = 0;
83       // Return the user's funds.  Throws on failure to prevent loss of funds.
84       user.transfer(eth_to_withdraw);
85     }
86     // Withdraw the user's tokens if the contract has purchased them.
87     else {
88       // Retrieve current token balance of contract.
89       uint256 contract_token_balance = token.balanceOf(address(this));
90       // Disallow token withdrawals if there are no tokens to withdraw.
91       require(contract_token_balance != 0);
92       // Store the user's token balance in a temporary variable.
93       uint256 tokens_to_withdraw = (balances[user] * contract_token_balance) / contract_eth_value;
94       // Update the value of tokens currently held by the contract.
95       contract_eth_value -= balances[user];
96       // Update the user's balance prior to sending to prevent recursive call.
97       balances[user] = 0;
98       // 1% fee if contract successfully bought tokens.
99       uint256 fee = tokens_to_withdraw / 100;
100       // Send the fee to the developer.
101       require(token.transfer(developer, fee));
102       // Send the funds.  Throws on failure to prevent loss of funds.
103       require(token.transfer(user, tokens_to_withdraw - fee));
104     }
105     // Each withdraw call earns 1% of the current withdraw bounty.
106     uint256 claimed_bounty = withdraw_bounty / 100;
107     // Update the withdraw bounty prior to sending to prevent recursive call.
108     withdraw_bounty -= claimed_bounty;
109     // Send the caller their bounty for withdrawing on the user's behalf.
110     msg.sender.transfer(claimed_bounty);
111   }
112   
113   // Allows developer to add ETH to the buy execution bounty.
114   function add_to_buy_bounty() payable {
115     // Only allow the developer to contribute to the buy execution bounty.
116     require(msg.sender == developer);
117     // Update bounty to include received amount.
118     buy_bounty += msg.value;
119   }
120   
121   // Allows developer to add ETH to the withdraw execution bounty.
122   function add_to_withdraw_bounty() payable {
123     // Only allow the developer to contribute to the buy execution bounty.
124     require(msg.sender == developer);
125     // Update bounty to include received amount.
126     withdraw_bounty += msg.value;
127   }
128   
129   // Buys tokens in the crowdsale and rewards the caller, callable by anyone.
130   function claim_bounty(){
131     // Short circuit to save gas if the contract has already bought tokens.
132     if (bought_tokens) return;
133     // Short circuit to save gas if the earliest buy time hasn't been reached.
134     if (now < earliest_buy_time) return;
135     // Short circuit to save gas if kill switch is active.
136     if (kill_switch) return;
137     // Disallow buying in if the developer hasn't set the sale address yet.
138     require(sale != 0x0);
139     // Record that the contract has bought the tokens.
140     bought_tokens = true;
141     // Store the claimed bounty in a temporary variable.
142     uint256 claimed_bounty = buy_bounty;
143     // Update bounty prior to sending to prevent recursive call.
144     buy_bounty = 0;
145     // Record the amount of ETH sent as the contract's current value.
146     contract_eth_value = this.balance - (claimed_bounty + withdraw_bounty);
147     // Transfer all the funds (less the bounties) to the crowdsale address
148     // to buy tokens.  Throws if the crowdsale hasn't started yet or has
149     // already completed, preventing loss of funds.
150     require(sale.call.value(contract_eth_value)());
151     // Send the caller their bounty for buying tokens for the contract.
152     msg.sender.transfer(claimed_bounty);
153   }
154   
155   // Default function.  Called when a user sends ETH to the contract.
156   function () payable {
157     // Disallow deposits if kill switch is active.
158     require(!kill_switch);
159     // Only allow deposits if the contract hasn't already purchased the tokens.
160     require(!bought_tokens);
161     // Only allow deposits that won't exceed the contract's ETH cap.
162     require(this.balance < eth_cap);
163     // Update records of deposited ETH to include the received amount.
164     balances[msg.sender] += msg.value;
165   }
166 }