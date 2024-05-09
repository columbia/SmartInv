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
30   // In this special case, the minimum has already been met, hence a 1 ETH minimum.
31   uint256 constant public min_required_amount = 1 ether;
32   
33   // The maximum amount of ETH that can be deposited into the contract.
34   // The owner in question was allowed 1000 ETH, but 300 has already been
35   // contributed, leaving open another 700 ETH for this contract to take.
36   uint256 constant public max_raised_amount = 700 ether;
37   
38   // The first block after which buy-in is allowed. Set in the contract constructor.
39   uint256 public min_buy_block;
40   
41   // The first block after which a refund is allowed. Set in the contract constructor.
42   uint256 public min_refund_block;
43   
44   // The crowdsale address. Address can be verified at: https://link.smartcontract.com/presales/39eb2b34-2dbf-4104-807d-12b9e3179cba
45   address constant public sale = 0x7093128612a02e32F1C1aa44cCD7411d84EE09Ac;
46   
47   // The contract creator. Used to finalize the buying.
48   address constant public creator = 0x0b11C7acb647eCa11d510eEc4fb0c17Bfccd6498;
49   
50   // Constructor. 
51   function LINKFund() {
52     // Buy-in allowed 3456 blocks (approx. 24 hours) after the contract is deployed.
53     min_buy_block = block.number + 3456;
54     
55     // ETH refund allowed 864000 blocks (approx. 24 days) after the contract is deployed.
56     min_refund_block = block.number + 864000;
57   }
58   
59   // Allows any user to withdraw his tokens.
60   // Takes the token's ERC20 address as argument as it is unknown at the time of contract deployment.
61   function perform_withdraw(address tokenAddress) {
62     // Disallow withdraw if tokens haven't been bought yet.
63     if (!bought_tokens) throw;
64     
65     // Retrieve current token balance of contract.
66     ERC20 token = ERC20(tokenAddress);
67     uint256 contract_token_balance = token.balanceOf(address(this));
68       
69     // Disallow token withdrawals if there are no tokens to withdraw.
70     if (contract_token_balance == 0) throw;
71       
72     // Store the user's token balance in a temporary variable.
73     uint256 tokens_to_withdraw = (balances[msg.sender] * contract_token_balance) / contract_eth_value;
74       
75     // Update the value of tokens currently held by the contract.
76     contract_eth_value -= balances[msg.sender];
77       
78     // Update the user's balance prior to sending to prevent recursive call.
79     balances[msg.sender] = 0;
80 
81     // Send the funds.  Throws on failure to prevent loss of funds.
82     if(!token.transfer(msg.sender, tokens_to_withdraw)) throw;
83   }
84   
85   // Allows any user to get his eth refunded before the purchase is made or after approx. 20 days in case the devs refund the eth.
86   function refund_me() {
87     if (!bought_tokens) {
88       // Only allow refunds when the tokens have been bought if the minimum refund block has been reached.
89       if (block.number < min_refund_block) throw;
90     }
91     
92     // Store the user's balance prior to withdrawal in a temporary variable.
93     uint256 eth_to_withdraw = balances[msg.sender];
94       
95     // Update the user's balance prior to sending ETH to prevent recursive call.
96     balances[msg.sender] = 0;
97       
98     // Return the user's funds.  Throws on failure to prevent loss of funds.
99     msg.sender.transfer(eth_to_withdraw);
100   }
101   
102   // Buy the tokens. Sends ETH to the presale wallet and records the ETH amount held in the contract.
103   function buy_the_tokens() {
104     // Verify it's the creator calling.
105 	if (msg.sender != creator) throw;
106 	
107     // Short circuit to save gas if the contract has already bought tokens.
108     if (bought_tokens) return;
109     
110     // Throw if the contract balance is less than the minimum required amount
111     if (this.balance < min_required_amount) throw;
112     
113     // Throw if the minimum buy-in block hasn't been reached
114     if (block.number < min_buy_block) throw;
115     
116     // Record that the contract has bought the tokens.
117     bought_tokens = true;
118     
119     // Record the amount of ETH sent as the contract's current value.
120     contract_eth_value = this.balance;
121 
122     // Transfer all the funds to the crowdsale address.
123     creator.transfer(contract_eth_value);
124   }
125   
126   // A helper function for the default function, allowing contracts to interact.
127   function default_helper() payable {
128     // Throw if the balance is larger than the maximum allowed amount.
129     if (this.balance > max_raised_amount) throw;
130     
131     // Update records of deposited ETH to include the received amount but only if the buy-in hasn't been done yet.
132     // This will handle an eventual refund from the devs while disallowing buy-ins after the deadline.
133     if (!bought_tokens) {
134       balances[msg.sender] += msg.value;
135     }
136   }
137   
138   // Default function.  Called when a user sends ETH to the contract.
139   function () payable {
140     // Delegate to the helper function.
141     default_helper();
142   }
143 }