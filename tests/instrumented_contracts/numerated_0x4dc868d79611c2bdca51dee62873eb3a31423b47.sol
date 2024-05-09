1 pragma solidity ^0.4.13;
2 
3 /*
4 
5 Decentraland Buyer
6 ========================
7 
8 Buys MANA tokens from the crowdsale on your behalf.
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
19 contract DecentralandBuyer {
20   // Store the amount of ETH deposited by each account.
21   mapping (address => uint256) public balances;
22   // Bounty for executing buy.
23   uint256 public bounty;
24   // Track whether the contract has bought the tokens yet.
25   bool public bought_tokens;
26   // Record the time the contract bought the tokens.
27   uint256 public time_bought;
28   // Record ETH value of tokens currently held by contract.
29   uint256 public contract_eth_value;
30   // Emergency kill switch in case a critical bug is found.
31   bool public kill_switch;
32   
33   // SHA3 hash of kill switch password.
34   bytes32 password_hash = 0x8223cba4d8b54dc1e03c41c059667f6adb1a642a0a07bef5a9d11c18c4f14612;
35   // Earliest time contract is allowed to buy into the crowdsale.
36   uint256 earliest_buy_block = 4170700;
37   // The developer address.
38   address developer = 0x000Fb8369677b3065dE5821a86Bc9551d5e5EAb9;
39   // The crowdsale address.
40   address public sale = 0xA66d83716c7CFE425B44D0f7ef92dE263468fb3d;
41   // The token address.
42   ERC20 public token = ERC20(0x0F5D2fB29fb7d3CFeE444a200298f468908cC942);
43   
44   // Allows the developer or anyone with the password to claim the bounty and shut down everything except withdrawals in emergencies.
45   function activate_kill_switch(string password) {
46     // Only activate the kill switch if the sender is the developer or the password is correct.
47     if (msg.sender != developer && sha3(password) != password_hash) throw;
48     // Store the claimed bounty in a temporary variable.
49     uint256 claimed_bounty = bounty;
50     // Update bounty prior to sending to prevent recursive call.
51     bounty = 0;
52     // Irreversibly activate the kill switch.
53     kill_switch = true;
54     // Send the caller their bounty for activating the kill switch.
55     msg.sender.transfer(claimed_bounty);
56   }
57   
58   // Withdraws all ETH deposited or tokens purchased by the user.
59   // "internal" means this function is not externally callable.
60   function withdraw(address user, bool has_fee) internal {
61     // If called before the ICO, cancel user's participation in the sale.
62     if (!bought_tokens) {
63       // Store the user's balance prior to withdrawal in a temporary variable.
64       uint256 eth_to_withdraw = balances[user];
65       // Update the user's balance prior to sending ETH to prevent recursive call.
66       balances[user] = 0;
67       // Return the user's funds.  Throws on failure to prevent loss of funds.
68       user.transfer(eth_to_withdraw);
69     }
70     // Withdraw the user's tokens if the contract has already purchased them.
71     else {
72       // Retrieve current token balance of contract.
73       uint256 contract_token_balance = token.balanceOf(address(this));
74       // Disallow token withdrawals if there are no tokens to withdraw.
75       if (contract_token_balance == 0) throw;
76       // Store the user's token balance in a temporary variable.
77       uint256 tokens_to_withdraw = (balances[user] * contract_token_balance) / contract_eth_value;
78       // Update the value of tokens currently held by the contract.
79       contract_eth_value -= balances[user];
80       // Update the user's balance prior to sending to prevent recursive call.
81       balances[user] = 0;
82       // No fee if the user withdraws their own funds manually.
83       uint256 fee = 0;
84       // 1% fee for automatic withdrawals.
85       if (has_fee) {
86         fee = tokens_to_withdraw / 100;
87         // Send the fee to the developer.
88         if(!token.transfer(developer, fee)) throw;
89       }
90       // Send the funds.  Throws on failure to prevent loss of funds.
91       if(!token.transfer(user, tokens_to_withdraw - fee)) throw;
92     }
93   }
94   
95   // Automatically withdraws on users' behalves (less a 1% fee on tokens).
96   function auto_withdraw(address user){
97     // Only allow automatic withdrawals after users have had a chance to manually withdraw.
98     if (!bought_tokens || now < time_bought + 1 hours) throw;
99     // Withdraw the user's funds for them.
100     withdraw(user, true);
101   }
102   
103   // Allows developer to add ETH to the buy execution bounty.
104   function add_to_bounty() payable {
105     // Only allow the developer to contribute to the buy execution bounty.
106     if (msg.sender != developer) throw;
107     // Disallow adding to bounty if kill switch is active.
108     if (kill_switch) throw;
109     // Disallow adding to the bounty if contract has already bought the tokens.
110     if (bought_tokens) throw;
111     // Update bounty to include received amount.
112     bounty += msg.value;
113   }
114   
115   // Buys tokens in the crowdsale and rewards the caller, callable by anyone.
116   function claim_bounty(){
117     // Short circuit to save gas if the contract has already bought tokens.
118     if (bought_tokens) return;
119     // Short circuit to save gas if the earliest buy time hasn't been reached.
120     if (block.number < earliest_buy_block) return;
121     // Short circuit to save gas if kill switch is active.
122     if (kill_switch) return;
123     // Record that the contract has bought the tokens.
124     bought_tokens = true;
125     // Record the time the contract bought the tokens.
126     time_bought = now;
127     // Store the claimed bounty in a temporary variable.
128     uint256 claimed_bounty = bounty;
129     // Update bounty prior to sending to prevent recursive call.
130     bounty = 0;
131     // Record the amount of ETH sent as the contract's current value.
132     contract_eth_value = this.balance - claimed_bounty;
133     // Transfer all the funds (less the bounty) to the crowdsale address
134     // to buy tokens.  Throws if the crowdsale hasn't started yet or has
135     // already completed, preventing loss of funds.
136     if(!sale.call.value(contract_eth_value)()) throw;
137     // Send the caller their bounty for buying tokens for the contract.
138     msg.sender.transfer(claimed_bounty);
139   }
140   
141   // A helper function for the default function, allowing contracts to interact.
142   function default_helper() payable {
143     // Treat near-zero ETH transactions as withdrawal requests.
144     if (msg.value <= 1 finney) {
145       // No fee on manual withdrawals.
146       withdraw(msg.sender, false);
147     }
148     // Deposit the user's funds for use in purchasing tokens.
149     else {
150       // Disallow deposits if kill switch is active.
151       if (kill_switch) throw;
152       // Only allow deposits if the contract hasn't already purchased the tokens.
153       if (bought_tokens) throw;
154       // Update records of deposited ETH to include the received amount.
155       balances[msg.sender] += msg.value;
156     }
157   }
158   
159   // Default function.  Called when a user sends ETH to the contract.
160   function () payable {
161     // Prevent sale contract from refunding ETH to avoid partial fulfillment.
162     if (msg.sender == address(sale)) throw;
163     // Delegate to the helper function.
164     default_helper();
165   }
166 }