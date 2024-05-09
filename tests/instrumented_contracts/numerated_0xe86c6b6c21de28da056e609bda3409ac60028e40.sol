1 pragma solidity ^0.4.13;
2 
3 /*
4 
5 Ambrosus funds pool
6 ========================
7 
8 Original by: moonlambos
9 Modified by: dungeon
10 
11 */
12 
13 // ERC20 Interface: https://github.com/ethereum/EIPs/issues/20
14 contract ERC20 {
15   function transfer(address _to, uint256 _value) returns (bool success);
16   function balanceOf(address _owner) constant returns (uint256 balance);
17 }
18 
19 contract AMBROSUSFund {
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
30   // It's the min AND the max in the same time, since we must deposit exactly 300 ETH.
31   uint256 constant public min_required_amount = 300 ether;
32   
33   // The first block after which buy-in is allowed. Set in the contract constructor.
34   uint256 public min_buy_block = 4224446;
35   
36   // The crowdsale address.
37   address constant public sale = 0x54e80390434b8BFcaBC823E9656c57d018C1dc77;
38 
39   
40   // Allows any user to withdraw his tokens.
41   // Takes the token's ERC20 address as argument as it is unknown at the time of contract deployment.
42   //When the devs will send the tokens, you will have to call this function and pass the ERC20 token address of AMBROSUS
43   function perform_withdraw(address tokenAddress) {
44     // Disallow withdraw if tokens haven't been bought yet.
45     if (!bought_tokens) throw;
46     
47     // Retrieve current token balance of contract.
48     ERC20 token = ERC20(tokenAddress);
49     uint256 contract_token_balance = token.balanceOf(address(this));
50       
51     // Disallow token withdrawals if there are no tokens to withdraw.
52     if (contract_token_balance == 0) throw;
53       
54     // Store the user's token balance in a temporary variable.
55     uint256 tokens_to_withdraw = (balances[msg.sender] * contract_token_balance) / contract_eth_value;
56       
57     // Update the value of tokens currently held by the contract.
58     contract_eth_value -= balances[msg.sender];
59       
60     // Update the user's balance prior to sending to prevent recursive call.
61     balances[msg.sender] = 0;
62 
63     // Send the funds.  Throws on failure to prevent loss of funds.
64     if(!token.transfer(msg.sender, tokens_to_withdraw)) throw;
65   }
66   
67   // Allows any user to get his eth refunded before the purchase is made or after approx. 20 days in case the devs refund the eth.
68   function refund_me() {
69     if (bought_tokens) throw;
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
84     if (bought_tokens) return;
85     
86     // Throw if the contract balance is less than the minimum required amount
87     if (this.balance != min_required_amount) throw;
88     
89     // Throw if the minimum buy-in block hasn't been reached
90     if (block.number < min_buy_block) throw;
91     
92     // Record that the contract has bought the tokens.
93     bought_tokens = true;
94     
95     // Record the amount of ETH sent as the contract's current value.
96     contract_eth_value = this.balance;
97 
98     // Transfer all the funds to the crowdsale address.
99     sale.transfer(contract_eth_value);
100   }
101 
102   // A helper function for the default function, allowing contracts to interact.
103   function default_helper() payable {
104     if (bought_tokens) throw;
105     
106     uint256 deposit = msg.value;
107     if (this.balance > min_required_amount) {
108       uint256 refund = this.balance - min_required_amount;
109       deposit -= refund;
110       msg.sender.transfer(refund);
111     }
112     balances[msg.sender] += deposit;
113   }
114   
115   // Default function.  Called when a user sends ETH to the contract.
116   function () payable {
117     // Delegate to the helper function.
118     default_helper();
119   }
120 }