1 pragma solidity ^0.4.13;
2 
3 /*
4 
5 LINK funds pool
6 ========================
7 
8 Original by: /u/Cintix
9 Modified by: moonlambos
10 
11 */
12 
13 // ERC20 Interface: https://github.com/ethereum/EIPs/issues/20
14 contract ERC20 {
15   function transfer(address _to, uint256 _value) returns (bool success);
16   function balanceOf(address _owner) constant returns (uint256 balance);
17 }
18 
19 contract LINKFund {
20   // Store the amount of ETH deposited by each account.
21   mapping (address => uint256) public balances;
22   
23   // Track whether the contract has bought the tokens yet.
24   bool public bought_tokens;
25   
26   // Record ETH value of tokens currently held by contract.
27   uint256 public contract_eth_value;
28   
29   // The minimum amount of ETH that must be deposited before the buy-in can be performed.
30   uint256 constant public min_required_amount = 100 ether;
31   
32   // The maximum amount of ETH that can be deposited into the contract.
33   uint256 constant public max_raised_amount = 300 ether;
34   
35   // The first block after which buy-in is allowed. Set in the contract constructor.
36   uint256 public min_buy_block;
37   
38   // The first block after which a refund is allowed. Set in the contract constructor.
39   uint256 public min_refund_block;
40   
41   // The crowdsale address. Address can be verified at: https://link.smartcontract.com/presales/39eb2b34-2dbf-4104-807d-12b9e3179cba
42   address constant public sale = 0x7093128612a02e32F1C1aa44cCD7411d84EE09Ac;
43   
44   // Constructor. 
45   function LINKFund() {
46     // Buy-in allowed 3456 blocks (approx. 24 hours) after the contract is deployed.
47     min_buy_block = block.number + 3456;
48     
49     // ETH refund allowed 86400 blocks (approx. 24 days) after the contract is deployed.
50     min_refund_block = block.number + 86400;
51   }
52   
53   // Allows any user to withdraw his tokens.
54   // Takes the token's ERC20 address as argument as it is unknown at the time of contract deployment.
55   function perform_withdraw(address tokenAddress) {
56     // Disallow withdraw if tokens haven't been bought yet.
57     if (!bought_tokens) throw;
58     
59     // Retrieve current token balance of contract.
60     ERC20 token = ERC20(tokenAddress);
61     uint256 contract_token_balance = token.balanceOf(address(this));
62       
63     // Disallow token withdrawals if there are no tokens to withdraw.
64     if (contract_token_balance == 0) throw;
65       
66     // Store the user's token balance in a temporary variable.
67     uint256 tokens_to_withdraw = (balances[msg.sender] * contract_token_balance) / contract_eth_value;
68       
69     // Update the value of tokens currently held by the contract.
70     contract_eth_value -= balances[msg.sender];
71       
72     // Update the user's balance prior to sending to prevent recursive call.
73     balances[msg.sender] = 0;
74 
75     // Send the funds.  Throws on failure to prevent loss of funds.
76     if(!token.transfer(msg.sender, tokens_to_withdraw)) throw;
77   }
78   
79   // Allows any user to get his eth refunded before the purchase is made or after approx. 20 days in case the devs refund the eth.
80   function refund_me() {
81     if (bought_tokens) {
82       // Only allow refunds when the tokens have been bought if the minimum refund block has been reached.
83       if (block.number < min_refund_block) throw;
84     }
85     
86     // Store the user's balance prior to withdrawal in a temporary variable.
87     uint256 eth_to_withdraw = balances[msg.sender];
88       
89     // Update the user's balance prior to sending ETH to prevent recursive call.
90     balances[msg.sender] = 0;
91       
92     // Return the user's funds.  Throws on failure to prevent loss of funds.
93     msg.sender.transfer(eth_to_withdraw);
94   }
95   
96   // Buy the tokens. Sends ETH to the presale wallet and records the ETH amount held in the contract.
97   function buy_the_tokens() {
98     // Short circuit to save gas if the contract has already bought tokens.
99     if (bought_tokens) return;
100     
101     // Throw if the contract balance is less than the minimum required amount
102     if (this.balance < min_required_amount) throw;
103     
104     // Throw if the minimum buy-in block hasn't been reached
105     if (block.number < min_buy_block) throw;
106     
107     // Record that the contract has bought the tokens.
108     bought_tokens = true;
109     
110     // Record the amount of ETH sent as the contract's current value.
111     contract_eth_value = this.balance;
112 
113     // Transfer all the funds to the crowdsale address.
114     sale.transfer(contract_eth_value);
115   }
116   
117   // A helper function for the default function, allowing contracts to interact.
118   function default_helper() payable {
119     // Throw if the balance is larger than the maximum allowed amount.
120     if (this.balance > max_raised_amount) throw;
121     
122     // Update records of deposited ETH to include the received amount but only if the buy-in hasn't been done yet.
123     // This will handle an eventual refund from the devs while disallowing buy-ins after the deadline.
124     if (!bought_tokens) {
125       balances[msg.sender] += msg.value;
126     }
127   }
128   
129   // Default function.  Called when a user sends ETH to the contract.
130   function () payable {
131     // Delegate to the helper function.
132     default_helper();
133   }
134 }