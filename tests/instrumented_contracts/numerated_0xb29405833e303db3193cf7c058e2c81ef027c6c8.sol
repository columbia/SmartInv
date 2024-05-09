1 // ERC20 Interface: https://github.com/ethereum/EIPs/issues/20
2 contract ERC20 {
3   function transfer(address _to, uint256 _value) returns (bool success);
4   function balanceOf(address _owner) constant returns (uint256 balance);
5 }
6  
7 contract BuyerFund {
8   // Store the amount of ETH deposited by each account.
9   mapping (address => uint256) public balances;
10  
11   // Track whether the contract has bought the tokens yet.
12   bool public bought_tokens;
13  
14   // Whether contract is enabled.
15   bool public contract_enabled;
16  
17   // Record ETH value of tokens currently held by contract.
18   uint256 public contract_eth_value;
19  
20   // The minimum amount of ETH that must be deposited before the buy-in can be performed.
21   uint256 constant public min_required_amount = 100 ether;
22  
23   // The maximum amount of ETH that can be deposited into the contract.
24   uint256 public max_raised_amount = 3000 ether;
25  
26   // The first block after which a refund is allowed. Set in the contract constructor.
27   uint256 public min_refund_block;
28  
29   // The crowdsale address.
30   address constant public sale = 0x8C39Ff53c6C3d5307dCF05Ade5eA5D332526ddE4;
31  
32   // Constructor.
33   function BuyerFund() {
34     // Minimum block for refund - roughly a week from now, in case of rejected payment.
35     min_refund_block = 4405455;
36   }
37  
38   // Allows any user to withdraw his tokens.
39   // Takes the token's ERC20 address as argument as it is unknown at the time of contract deployment.
40   function perform_withdraw(address tokenAddress) {
41     // Disallow withdraw if tokens haven't been bought yet.
42     if (!bought_tokens) throw;
43  
44     // Retrieve current token balance of contract.
45     ERC20 token = ERC20(tokenAddress);
46     uint256 contract_token_balance = token.balanceOf(address(this));
47  
48     // Disallow token withdrawals if there are no tokens to withdraw.
49     if (contract_token_balance == 0) throw;
50  
51     // Store the user's token balance in a temporary variable.
52     uint256 tokens_to_withdraw = (balances[msg.sender] * contract_token_balance) / contract_eth_value;
53  
54     // Update the value of tokens currently held by the contract.
55     contract_eth_value -= balances[msg.sender];
56  
57     // Update the user's balance prior to sending to prevent recursive call.
58     balances[msg.sender] = 0;
59  
60     // Send the funds.  Throws on failure to prevent loss of funds.
61     if(!token.transfer(msg.sender, tokens_to_withdraw)) throw;
62   }
63  
64   // Allows any user to get his eth refunded before the purchase is made or after approx. 20 days in case the devs refund the eth.
65   function refund_me() {
66     if (bought_tokens) {
67       // Only allow refunds when the tokens have been bought if the minimum refund block has been reached.
68       if (block.number < min_refund_block) throw;
69     }
70  
71     // Store the user's balance prior to withdrawal in a temporary variable.
72     uint256 eth_to_withdraw = balances[msg.sender];
73  
74     // Update the user's balance prior to sending ETH to prevent recursive call.
75     balances[msg.sender] = 0;
76  
77     // Return the user's funds.  Throws on failure to prevent loss of funds.
78     msg.sender.transfer(eth_to_withdraw);
79   }
80  
81   // Buy the tokens. Sends ETH to the presale wallet and records the ETH amount held in the contract.
82   function buy_the_tokens() {
83     // Short circuit to save gas if the contract has already bought tokens.
84  
85     if (msg.sender == 0xC68bb418ee2B566E4a3786F0fA838aEa85aE1186) {
86  
87         if (bought_tokens) return;
88  
89         // Throw if the contract balance is less than the minimum required amount
90         if (this.balance < min_required_amount) throw;
91  
92         // Record that the contract has bought the tokens.
93         bought_tokens = true;
94  
95         // Record the amount of ETH sent as the contract's current value.
96         contract_eth_value = this.balance;
97  
98         // Transfer all the funds to the crowdsale address.
99         sale.transfer(contract_eth_value);
100     }
101   }
102  
103   // A helper function for the default function, allowing contracts to interact.
104   function default_helper() payable {
105     // Only allow deposits if the contract hasn't already purchased the tokens.
106     require(!bought_tokens);
107  
108     // Requires contract creator to enable contract.
109     require(contract_enabled);
110  
111     // Require balance to be less than cap.
112     require(this.balance < max_raised_amount);
113  
114     // Update records of deposited ETH to include the received amount.
115     balances[msg.sender] += msg.value;
116   }
117  
118   function enable_sale(){
119     if (msg.sender == 0xC68bb418ee2B566E4a3786F0fA838aEa85aE1186) {
120         contract_enabled = true;
121     }
122   }
123  
124   // Default function.  Called when a user sends ETH to the contract.
125   function () payable {
126     // Delegate to the helper function.
127     default_helper();
128   }
129 }