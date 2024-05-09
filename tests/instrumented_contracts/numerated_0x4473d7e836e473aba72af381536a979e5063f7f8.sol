1 pragma solidity ^0.4.13;
2 
3 /*
4 
5 Cobinhood Presale Buyer
6 ========================
7 
8 Buys Cobinhood tokens from the crowdsale on your behalf.
9 Author: /u/troythus, @troyth
10 Forked from: /u/Cintix
11 
12 */
13 
14 // ERC20 Interface: https://github.com/ethereum/EIPs/issues/20
15 contract ERC20 {
16   function transfer(address _to, uint256 _value) returns (bool success);
17   function balanceOf(address _owner) constant returns (uint256 balance);
18 }
19 
20 contract CobinhoodBuyer {
21   // Store the amount of ETH deposited by each account.
22   mapping (address => uint256) public balances;
23   // Track whether the contract has received the tokens yet.
24   bool public received_tokens;
25   // Track whether the contract has sent ETH to the presale contract yet.
26   bool public purchased_tokens;
27   // Record ETH value of tokens currently held by contract.
28   uint256 public contract_eth_value;
29   // Emergency kill switch in case a critical bug is found.
30   bool public kill_switch;
31 
32   // SHA3 hash of kill switch password.
33   bytes32 password_hash = 0xe3ce8892378c33f21165c3fa9b1c106524b2352e16ea561d943008f11f0ecce0;
34   // Latest time contract is allowed to buy into the crowdsale.
35   uint256 public latest_buy_time = 1505109600;
36   // Maximum amount of user ETH contract will accept.  Reduces risk of hard cap related failure.
37   uint256 public eth_cap = 299 ether;
38   // Minimum amount of user ETH contract will accept.  Reduces risk of hard cap related failure.
39   uint256 public eth_min = 149 ether;
40   // The developer address.
41   address public developer = 0x0575C223f5b87Be4812926037912D45B31270d3B;
42   // The fee claimer's address.
43   address public fee_claimer = 0x9793661F48b61D0b8B6D39D53CAe694b101ff028;
44   // The crowdsale address.
45   address public sale = 0x0bb9fc3ba7bcf6e5d6f6fc15123ff8d5f96cee00;
46   // The token address.  Settable by the developer once Cobinhood announces it.
47   ERC20 public token;
48 
49   // Allows the developer to set the token address because we don't know it yet.
50   function set_address(address _token) {
51     // Only allow the developer to set the token addresses.
52     require(msg.sender == developer);
53     // Set the token addresse.
54     token = ERC20(_token);
55   }
56 
57   // Developer override of received_tokens to make sure tokens aren't stuck.
58   function force_received() {
59       require(msg.sender == developer);
60       received_tokens = true;
61   }
62 
63   // Anyone can call to see if tokens have been received, and then set the flag to let withdrawls happen.
64   function received_tokens() {
65       if( token.balanceOf(address(this)) > 0){
66           received_tokens = true;
67       }
68   }
69 
70   // Allows the developer or anyone with the password to shut down everything except withdrawals in emergencies.
71   function activate_kill_switch(string password) {
72     // Only activate the kill switch if the sender is the developer or the password is correct.
73     require(msg.sender == developer || sha3(password) == password_hash);
74 
75     // Irreversibly activate the kill switch.
76     kill_switch = true;
77   }
78 
79   // Withdraws all ETH deposited or tokens purchased by the given user.
80   function withdraw(address user){
81     // Only allow withdrawals after the contract has had a chance to buy in.
82     require(received_tokens || now > latest_buy_time);
83     // Short circuit to save gas if the user doesn't have a balance.
84     if (balances[user] == 0) return;
85     // If the contract failed to buy into the sale, withdraw the user's ETH.
86     if (!received_tokens || kill_switch) {
87       // Store the user's balance prior to withdrawal in a temporary variable.
88       uint256 eth_to_withdraw = balances[user];
89       // Update the user's balance prior to sending ETH to prevent recursive call.
90       balances[user] = 0;
91       // Return the user's funds.  Throws on failure to prevent loss of funds.
92       user.transfer(eth_to_withdraw);
93     }
94     // Withdraw the user's tokens if the contract has purchased them.
95     else {
96       // Retrieve current token balance of contract.
97       uint256 contract_token_balance = token.balanceOf(address(this));
98       // Disallow token withdrawals if there are no tokens to withdraw.
99       require(contract_token_balance != 0);
100       // Store the user's token balance in a temporary variable.
101       uint256 tokens_to_withdraw = (balances[user] * contract_token_balance) / contract_eth_value;
102       // Update the value of tokens currently held by the contract.
103       contract_eth_value -= balances[user];
104       // Update the user's balance prior to sending to prevent recursive call.
105       balances[user] = 0;
106       // 1% fee if contract successfully bought tokens.
107       uint256 fee = tokens_to_withdraw / 100;
108       // Send the fee to the developer.
109       require(token.transfer(fee_claimer, fee));
110       // Send the funds.  Throws on failure to prevent loss of funds.
111       require(token.transfer(user, tokens_to_withdraw - fee));
112     }
113   }
114 
115   // Send all ETH to the presale contract once total is between [149,299], callable by anyone.
116   function purchase(){
117     // Short circuit to save gas if the contract has already bought tokens.
118     if (purchased_tokens) return;
119     // Short circuit to save gas if the earliest buy time hasn't been reached.
120     if (now > latest_buy_time) return;
121     // Short circuit to save gas if kill switch is active.
122     if (kill_switch) return;
123     // Short circuit to save gas if the minimum buy in hasn't been achieved.
124     if (this.balance < eth_min) return;
125     // Record that the contract has bought the tokens.
126     purchased_tokens = true;
127     // Transfer all the funds to the crowdsale address
128     // to buy tokens.  Throws if the crowdsale hasn't started yet or has
129     // already completed, preventing loss of funds.
130     require(sale.call.value(this.balance)());
131   }
132 
133   // Default function.  Called when a user sends ETH to the contract.
134   function () payable {
135     // Disallow deposits if kill switch is active.
136     require(!kill_switch);
137     // Only allow deposits if the contract hasn't already purchased the tokens.
138     require(!purchased_tokens);
139     // Only allow deposits that won't exceed the contract's ETH cap.
140     require(this.balance < eth_cap);
141     // Update records of deposited ETH to include the received amount.
142     balances[msg.sender] += msg.value;
143   }
144 }