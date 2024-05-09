1 pragma solidity ^0.4.13;
2 
3 /*
4 
5 CoinDash Buyer
6 ========================
7 
8 Buys CoinDash tokens from the crowdsale on your behalf.
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
19 contract CoinDashBuyer {
20   // Store the amount of ETH deposited by each account.
21   mapping (address => uint256) public balances;
22   // Bounty for executing buy.
23   uint256 public bounty;
24   // Track whether the contract has bought the tokens yet.
25   bool public bought_tokens;
26   // Record the time the contract bought the tokens.
27   uint256 public time_bought;
28   // Emergency kill switch in case a critical bug is found.
29   bool public kill_switch;
30   
31   // Token Wei received per ETH Wei contributed in this sale
32   uint256 tokens_per_eth = 6093;
33   // SHA3 hash of kill switch password.
34   bytes32 password_hash = 0x1b266c9bad3a46ed40bf43471d89b83712ed06c2250887c457f5f21f17b2eb97;
35   // Earliest time contract is allowed to buy into the crowdsale.
36   uint256 earliest_buy_time = 1500294600;
37   // The developer address.
38   address developer = 0x000Fb8369677b3065dE5821a86Bc9551d5e5EAb9;
39   // The crowdsale address.  Settable by the developer.
40   address public sale;
41   // The token address.  Settable by the developer.
42   ERC20 public token;
43   
44   // Allows the developer to set the crowdsale and token addresses.
45   function set_addresses(address _sale, address _token) {
46     // Only allow the developer to set the sale and token addresses.
47     if (msg.sender != developer) throw;
48     // Only allow setting the addresses once.
49     if (sale != 0x0) throw;
50     // Set the crowdsale and token addresses.
51     sale = _sale;
52     token = ERC20(_token);
53   }
54   
55   // Allows the developer or anyone with the password to shut down everything except withdrawals in emergencies.
56   function activate_kill_switch(string password) {
57     // Only activate the kill switch if the sender is the developer or the password is correct.
58     if (msg.sender != developer && sha3(password) != password_hash) throw;
59     // Irreversibly activate the kill switch.
60     kill_switch = true;
61   }
62   
63   // Withdraws all ETH deposited or tokens purchased by the user.
64   // "internal" means this function is not externally callable.
65   function withdraw(address user, bool has_fee) internal {
66     // If called before the ICO, cancel user's participation in the sale.
67     if (!bought_tokens) {
68       // Store the user's balance prior to withdrawal in a temporary variable.
69       uint256 eth_to_withdraw = balances[user];
70       // Update the user's balance prior to sending ETH to prevent recursive call.
71       balances[user] = 0;
72       // Return the user's funds.  Throws on failure to prevent loss of funds.
73       user.transfer(eth_to_withdraw);
74     }
75     // Withdraw the user's tokens if the contract has already purchased them.
76     else {
77       // Store the user's token balance in a temporary variable.
78       uint256 tokens_to_withdraw = balances[user] * tokens_per_eth;
79       // Update the user's balance prior to sending to prevent recursive call.
80       balances[user] = 0;
81       // No fee if the user withdraws their own funds manually.
82       uint256 fee = 0;
83       // 1% fee for automatic withdrawals.
84       if (has_fee) {
85         fee = tokens_to_withdraw / 100;
86         // Send the fee to the developer.
87         if(!token.transfer(developer, fee)) throw;
88       }
89       // Send the funds.  Throws on failure to prevent loss of funds.
90       if(!token.transfer(user, tokens_to_withdraw - fee)) throw;
91     }
92   }
93   
94   // Automatically withdraws on users' behalves (less a 1% fee on tokens).
95   function auto_withdraw(address user){
96     // Only allow automatic withdrawals after users have had a chance to manually withdraw.
97     if (!bought_tokens || now < time_bought + 1 hours) throw;
98     // Withdraw the user's funds for them.
99     withdraw(user, true);
100   }
101   
102   // Allows developer to add ETH to the buy execution bounty.
103   function add_to_bounty() payable {
104     // Only allow the developer to contribute to the buy execution bounty.
105     if (msg.sender != developer) throw;
106     // Disallow adding to bounty if kill switch is active.
107     if (kill_switch) throw;
108     // Disallow adding to the bounty if contract has already bought the tokens.
109     if (bought_tokens) throw;
110     // Update bounty to include received amount.
111     bounty += msg.value;
112   }
113   
114   // Buys tokens in the crowdsale and rewards the caller, callable by anyone.
115   function claim_bounty(){
116     // Short circuit to save gas if the contract has already bought tokens.
117     if (bought_tokens) return;
118     // Short circuit to save gas if kill switch is active.
119     if (kill_switch) return;
120     // Short circuit to save gas if the earliest buy time hasn't been reached.
121     if (now < earliest_buy_time) return;
122     // Disallow buying in if the developer hasn't set the sale address yet.
123     if (sale == 0x0) throw;
124     // Record that the contract has bought the tokens.
125     bought_tokens = true;
126     // Record the time the contract bought the tokens.
127     time_bought = now;
128     // Transfer all the funds (less the bounty) to the crowdsale address
129     // to buy tokens.  Throws if the crowdsale hasn't started yet or has
130     // already completed, preventing loss of funds.
131     if(!sale.call.value(this.balance - bounty)()) throw;
132     // Send the caller their bounty for buying tokens for the contract.
133     msg.sender.transfer(bounty);
134   }
135   
136   // A helper function for the default function, allowing contracts to interact.
137   function default_helper() payable {
138     // Treat near-zero ETH transactions as withdrawal requests.
139     if (msg.value <= 1 finney) {
140       // No fee on manual withdrawals.
141       withdraw(msg.sender, false);
142     }
143     // Deposit the user's funds for use in purchasing tokens.
144     else {
145       // Disallow deposits if kill switch is active.
146       if (kill_switch) throw;
147       // Only allow deposits if the contract hasn't already purchased the tokens.
148       if (bought_tokens) throw;
149       // Update records of deposited ETH to include the received amount.
150       balances[msg.sender] += msg.value;
151     }
152   }
153   
154   // Default function.  Called when a user sends ETH to the contract.
155   function () payable {
156     // Delegate to the helper function.
157     default_helper();
158   }
159 }