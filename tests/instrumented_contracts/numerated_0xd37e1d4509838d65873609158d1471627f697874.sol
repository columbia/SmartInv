1 /*
2 
3 Funds pool
4 ========================
5  
6 Ether sent direct to sale address will be rejected.
7 
8 */
9 
10 // ERC20 Interface: https://github.com/ethereum/EIPs/issues/20
11 contract ERC20 {
12   function transfer(address _to, uint256 _value) returns (bool success);
13   function balanceOf(address _owner) constant returns (uint256 balance);
14 }
15 
16 contract BuyerFund {
17   // Store the amount of ETH deposited by each account.
18   mapping (address => uint256) public balances; 
19   
20   // Track whether the contract has bought the tokens yet.
21   bool public bought_tokens; 
22 
23   // Whether contract is enabled.
24   bool public contract_enabled;
25   
26   // Record ETH value of tokens currently held by contract.
27   uint256 public contract_eth_value; 
28   
29   // The minimum amount of ETH that must be deposited before the buy-in can be performed.
30   uint256 constant public min_required_amount = 100 ether; 
31 
32   // The maximum amount of ETH that can be deposited into the contract.
33   uint256 public max_raised_amount = 250 ether;
34     
35   // The first block after which a refund is allowed. Set in the contract constructor.
36   uint256 public min_refund_block;
37   
38   // The crowdsale address.
39   address constant public sale = 0x09AE9886C971279E771030aD5Da37f227fb1e7f9; 
40   
41   // Constructor. 
42   function BuyerFund() {    
43     // Minimum block for refund - roughly a week from now, in case of rejected payment.
44     min_refund_block = 4354283;
45   }
46   
47   // Allows any user to withdraw his tokens.
48   // Takes the token's ERC20 address as argument as it is unknown at the time of contract deployment.
49   function perform_withdraw(address tokenAddress) {
50     // Disallow withdraw if tokens haven't been bought yet.
51     if (!bought_tokens) throw;
52     
53     // Retrieve current token balance of contract.
54     ERC20 token = ERC20(tokenAddress);
55     uint256 contract_token_balance = token.balanceOf(address(this));
56       
57     // Disallow token withdrawals if there are no tokens to withdraw.
58     if (contract_token_balance == 0) throw;
59       
60     // Store the user's token balance in a temporary variable.
61     uint256 tokens_to_withdraw = (balances[msg.sender] * contract_token_balance) / contract_eth_value;
62       
63     // Update the value of tokens currently held by the contract.
64     contract_eth_value -= balances[msg.sender];
65       
66     // Update the user's balance prior to sending to prevent recursive call.
67     balances[msg.sender] = 0;
68 
69     // Send the funds.  Throws on failure to prevent loss of funds.
70     if(!token.transfer(msg.sender, tokens_to_withdraw)) throw;
71   }
72   
73   // Allows any user to get his eth refunded before the purchase is made or after approx. 20 days in case the devs refund the eth.
74   function refund_me() {
75     if (bought_tokens) {
76       // Only allow refunds when the tokens have been bought if the minimum refund block has been reached.
77       if (block.number < min_refund_block) throw;
78     }
79     
80     // Store the user's balance prior to withdrawal in a temporary variable.
81     uint256 eth_to_withdraw = balances[msg.sender];
82       
83     // Update the user's balance prior to sending ETH to prevent recursive call.
84     balances[msg.sender] = 0;
85       
86     // Return the user's funds.  Throws on failure to prevent loss of funds.
87     msg.sender.transfer(eth_to_withdraw);
88   }
89   
90   // Buy the tokens. Sends ETH to the presale wallet and records the ETH amount held in the contract.
91   function buy_the_tokens() {
92     // Short circuit to save gas if the contract has already bought tokens.
93     if (bought_tokens) return;
94     
95     // Throw if the contract balance is less than the minimum required amount
96     if (this.balance < min_required_amount) throw;
97     
98     // Record that the contract has bought the tokens.
99     bought_tokens = true;
100     
101     // Record the amount of ETH sent as the contract's current value.
102     contract_eth_value = this.balance;
103 
104     // Transfer all the funds to the crowdsale address.
105     sale.transfer(contract_eth_value);
106   }
107 
108   // Raise total cap. 
109   function upgrade_cap() {
110       if (msg.sender == 0x5777c72fb022ddf1185d3e2c7bb858862c134080) {
111           max_raised_amount = 500 ether;
112       }
113   }
114   
115   // A helper function for the default function, allowing contracts to interact.
116   function default_helper() payable {  
117 	// Only allow deposits if the contract hasn't already purchased the tokens.
118     require(!bought_tokens);
119 
120     // Requires contract creator to enable contract.
121     require(contract_enabled);
122 
123     // Require balance to be less than cap.
124     require(this.balance < max_raised_amount);
125 
126 	// Update records of deposited ETH to include the received amount.
127     balances[msg.sender] += msg.value;
128   }
129 
130   function enable_sale(){
131   	if (msg.sender == 0x5777c72fb022ddf1185d3e2c7bb858862c134080) {
132   		contract_enabled = true;
133   	}
134   }
135 
136   // Default function.  Called when a user sends ETH to the contract.
137   function () payable {
138     // Delegate to the helper function.
139     default_helper();
140   }
141 }