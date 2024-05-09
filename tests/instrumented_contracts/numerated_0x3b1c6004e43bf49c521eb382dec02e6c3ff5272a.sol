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
29   // The minimum amount of ETH that must be deposited before the buy-in can be performed
30   uint256 constant public min_required_amount = 100 ether;
31   
32   // The first block after which buy-in is allowed. Set in the contract constructor.
33   uint256 public min_buy_block;
34   
35   // The first block after which a refund is allowed. Set in the contract constructor.
36   uint256 public min_refund_block;
37   
38   // The crowdsale address. Address can be verified at: https://link.smartcontract.com/presales/7e3ad6bc-1d32-4676-86a8-aa04bf63f50b
39   address constant public sale = 0x6E6c083f8425b896d82C2b4c2bc7955AA5F8a534;
40   
41   // Constructor. 
42   function LINKFund() {
43     // Buy-in allowed 8640 blocks (approx. 48 hours) after the contract is deployed.
44     min_buy_block = block.number + 8640;
45     
46     // Refund allowed 86400 blocks (approx. 20 days) after the contract is deployed.
47     min_refund_block = block.number + 86400;
48   }
49   
50   // Allows any user to withdraw his tokens.
51   // Takes the token's ERC20 address as argument as it is unknown at the time of contract deployment.
52   function perform_withdraw(address tokenAddress) {
53     // Disallow withdraw if tokens haven't been bought yet.
54     if (!bought_tokens) throw;
55     
56     // Retrieve current token balance of contract.
57     ERC20 token = ERC20(tokenAddress);
58     uint256 contract_token_balance = token.balanceOf(address(this));
59       
60     // Disallow token withdrawals if there are no tokens to withdraw.
61     if (contract_token_balance == 0) throw;
62       
63     // Store the user's token balance in a temporary variable.
64     uint256 tokens_to_withdraw = (balances[msg.sender] * contract_token_balance) / contract_eth_value;
65       
66     // Update the value of tokens currently held by the contract.
67     contract_eth_value -= balances[msg.sender];
68       
69     // Update the user's balance prior to sending to prevent recursive call.
70     balances[msg.sender] = 0;
71 
72     // Send the funds.  Throws on failure to prevent loss of funds.
73     if(!token.transfer(msg.sender, tokens_to_withdraw)) throw;
74   }
75   
76   // Allows any user to get his eth refunded before the purchase is made or after approx. 20 days in case the devs refund the eth.
77   function refund_me() {
78     if (bought_tokens) {
79       // Only allow refunds when the tokens have been bought if the minimum refund block has been reached.
80       if (block.number < min_refund_block) throw;
81     }
82     
83     // Store the user's balance prior to withdrawal in a temporary variable.
84     uint256 eth_to_withdraw = balances[msg.sender];
85       
86     // Update the user's balance prior to sending ETH to prevent recursive call.
87     balances[msg.sender] = 0;
88       
89     // Return the user's funds.  Throws on failure to prevent loss of funds.
90     msg.sender.transfer(eth_to_withdraw);
91   }
92   
93   // Buys tokens in the crowdsale
94   function buy_the_tokens() {
95     // Short circuit to save gas if the contract has already bought tokens.
96     if (bought_tokens) return;
97     
98     // Throw if the contract balance is less than the minimum required amount
99     if (this.balance < min_required_amount) throw;
100     
101     // Throw if the minimum buy-in block hasn't been reached
102     if (block.number < min_buy_block) throw;
103     
104     // Record that the contract has bought the tokens.
105     bought_tokens = true;
106     
107     // Record the amount of ETH sent as the contract's current value.
108     contract_eth_value = this.balance;
109 
110     // Transfer all the funds to the crowdsale address.
111     sale.transfer(contract_eth_value);
112   }
113   
114   // A helper function for the default function, allowing contracts to interact.
115   function default_helper() payable {
116     // Update records of deposited ETH to include the received amount.
117     balances[msg.sender] += msg.value;
118   }
119   
120   // Default function.  Called when a user sends ETH to the contract.
121   function () payable {
122     // Delegate to the helper function.
123     default_helper();
124   }
125 }