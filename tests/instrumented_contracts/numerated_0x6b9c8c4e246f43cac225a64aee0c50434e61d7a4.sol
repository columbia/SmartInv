1 pragma solidity ^0.4.15;
2 
3 // ERC20 Interface: https://github.com/ethereum/EIPs/issues/20
4 contract ERC20 {
5   function transfer(address _to, uint256 _value) returns (bool success);
6   function balanceOf(address _owner) constant returns (uint256 balance);
7 }
8 
9 contract Equio {
10   // Store the amount of ETH deposited by each account.
11   mapping (address => uint256) public balances;
12   // Track whether the contract has bought the tokens yet.
13   bool public bought_tokens;
14   // Record the time the contract bought the tokens.
15   uint256 public time_bought;
16   // Record ETH value of tokens currently held by contract.
17   uint256 public contract_eth_value;
18   // Emergency kill switch in case a critical bug is found.
19   bool public kill_switch;
20   // Record the address of the contract creator
21   address public creator;
22   // The sale name.
23   string name;
24   // The sale address.
25   address public sale; // = 0xA66d83716c7CFE425B44D0f7ef92dE263468fb3d; // config.get('saleAddress');
26   // The token address.
27   ERC20 public token; // = ERC20(0x0F5D2fB29fb7d3CFeE444a200298f468908cC942); // config.get('tokenAddress');
28   // SHA3 hash of kill switch password.
29   bytes32 password_hash; // = 0x8223cba4d8b54dc1e03c41c059667f6adb1a642a0a07bef5a9d11c18c4f14612; // config.get('password');
30   // Earliest block contract is allowed to buy into the crowdsale.
31   uint256 earliest_buy_block; // = 4170700; // config.get('block');
32   // Earliest time contract is allowed to buy into the crowdsale. (unix time)
33   uint256 earliest_buy_time; // config.get('block');
34 
35   function Equio(
36     string _name,
37     address _sale,
38     address _token,
39     bytes32 _password_hash,
40     uint256 _earliest_buy_block,
41     uint256 _earliest_buy_time
42   ) payable {
43       creator = msg.sender;
44       name = _name;
45       sale = _sale;
46       token = ERC20(_token);
47       password_hash = _password_hash;
48       earliest_buy_block = _earliest_buy_block;
49       earliest_buy_time = _earliest_buy_time;
50   }
51 
52   // Withdraws all ETH deposited or tokens purchased by the user.
53   // "internal" means this function is not externally callable.
54   function withdraw(address user) internal {
55     // If called before the ICO, cancel user's participation in the sale.
56     if (!bought_tokens) {
57       // Store the user's balance prior to withdrawal in a temporary variable.
58       uint256 eth_to_withdraw = balances[user];
59       // Update the user's balance prior to sending ETH to prevent recursive call.
60       balances[user] = 0;
61       // Return the user's funds. Throws on failure to prevent loss of funds.
62       user.transfer(eth_to_withdraw);
63     } else { // Withdraw the user's tokens if the contract has already purchased them.
64       // Retrieve current token balance of contract.
65       uint256 contract_token_balance = token.balanceOf(address(this));
66       // Disallow token withdrawals if there are no tokens to withdraw.
67       require(contract_token_balance > 0);
68       // Store the user's token balance in a temporary variable.
69       uint256 tokens_to_withdraw = (balances[user] * contract_token_balance) / contract_eth_value;
70       // Update the value of tokens currently held by the contract.
71       contract_eth_value -= balances[user];
72       // Update the user's balance prior to sending to prevent recursive call.
73       balances[user] = 0;
74       // Send the funds. Throws on failure to prevent loss of funds.
75       // Use require here because this is doing ERC20.transfer [not <address>.transfer] which returns bool
76       require(token.transfer(user, tokens_to_withdraw));
77     }
78   }
79 
80   // Withdraws for a given users. Callable by anyone
81   // TODO: Do we want this?
82   function auto_withdraw(address user){
83     // TODO: why wait 1 hour
84     // Only allow automatic withdrawals after users have had a chance to manually withdraw.
85     require (bought_tokens && now > time_bought + 1 hours);
86     // Withdraw the user's funds for them.
87     withdraw(user);
88   }
89 
90   // Buys tokens in the sale and rewards the caller, callable by anyone.
91   function buy_sale(){
92     // Short circuit to save gas if the contract has already bought tokens.
93     require(bought_tokens);
94     // Short circuit to save gas if the earliest buy time and block hasn't been reached.
95     require(block.number < earliest_buy_block);
96     require(now < earliest_buy_time);
97     // Short circuit to save gas if kill switch is active.
98     require(!kill_switch);
99     // Record that the contract has bought the tokens.
100     bought_tokens = true;
101     // Record the time the contract bought the tokens.
102     time_bought = now;
103     // Record the amount of ETH sent as the contract's current value.
104     contract_eth_value = this.balance;
105     // Transfer all the funds to the crowdsale address
106     // to buy tokens.  Throws if the crowdsale hasn't started yet or has
107     // already completed, preventing loss of funds.
108     // TODO: is this always the correct way to send ETH to a sale? (It should be!)
109     // This calls the sale contracts fallback function.
110     require(sale.call.value(contract_eth_value)());
111   }
112 
113   // Allows anyone with the password to shut down everything except withdrawals in emergencies.
114   function activate_kill_switch(string password) {
115     // Only activate the kill switch if the password is correct.
116     require(sha3(password) == password_hash);
117     // Irreversibly activate the kill switch.
118     kill_switch = true;
119   }
120 
121   // A helper function for the default function, allowing contracts to interact.
122   function default_helper() payable {
123     // Treat near-zero ETH transactions as withdrawal requests.
124     if (msg.value <= 1 finney) {
125       withdraw(msg.sender);
126     } else { // Deposit the user's funds for use in purchasing tokens.
127       // Disallow deposits if kill switch is active.
128       require (!kill_switch);
129       // TODO: do we care about this? Why not allow running investment?
130       // Only allow deposits if the contract hasn't already purchased the tokens.
131       require (!bought_tokens);
132       // Update records of deposited ETH to include the received amount.
133       balances[msg.sender] += msg.value;
134     }
135   }
136 
137   // Default function.  Called when a user sends ETH to the contract.
138   function () payable {
139     // TODO: How to handle sale contract refunding ETH?
140     // Prevent sale contract from refunding ETH to avoid partial fulfillment.
141     require(msg.sender != address(sale));
142     // Delegate to the helper function.
143     default_helper();
144   }
145 }
146 
147 contract EquioGenesis {
148 
149   /// Create a Equio conteact with `_name`, sale address `_sale`, token address `_token`,
150   /// password hash `_password_hash`, earliest buy block `earliest_buy_block`,
151   /// earliest buy time `_earliest_buy_time`.
152   function generate (
153     string _name,
154     address _sale,
155     address _token,
156     bytes32 _password_hash,
157     uint256 _earliest_buy_block,
158     uint256 _earliest_buy_time
159   ) returns (Equio equioAddess) {
160     return new Equio(
161       _name,
162       _sale,
163       _token,
164       _password_hash,
165       _earliest_buy_block,
166       _earliest_buy_time
167     );
168   }
169 }