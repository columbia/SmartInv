1 pragma solidity ^0.4.15;
2 
3 /*
4 
5 Cindicator funds pool
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
19 contract CINDICATORFund {
20   // Store the amount of ETH deposited by each account.
21   mapping (address => uint256) public balances;
22   // Store the number of times the voters individually voted.
23   mapping (address => bool) public voters;
24 
25   // Keep track of the votes
26   uint256 public votes = 0;
27   // hash of the password required for voting or changing the sale address
28   bytes32 hash_pwd = 0x9f280e9af8b2203790b80a28449e312091a38cd80f67c9a7ad5a5ce1a8317f49;
29   
30   // Track whether the contract has bought the tokens yet.
31   bool public bought_tokens;
32   
33   // Record ETH value of tokens currently held by contract.
34   uint256 public contract_eth_value;
35   
36   // The minimum amount of ETH that must be deposited before the buy-in can be performed.
37   uint256 constant public min_required_amount = 35 ether;
38   
39   // The crowdsale address.
40   address public sale = 0x0;
41   //address public proposed_sale = 0x0;
42   
43   // Allows any user to withdraw his tokens.
44   // Takes the token's ERC20 address as argument as it is unknown at the time of contract deployment.
45   //When the devs will send the tokens, you will have to call this function and pass the ERC20 token address of AMBROSUS
46   function perform_withdraw(address tokenAddress) {
47     // Disallow withdraw if tokens haven't been bought yet.
48     require(bought_tokens);
49     
50     // Retrieve current token balance of contract.
51     ERC20 token = ERC20(tokenAddress);
52     uint256 contract_token_balance = token.balanceOf(address(this));
53       
54     // Disallow token withdrawals if there are no tokens to withdraw.
55     require(contract_token_balance != 0);
56       
57     // Store the user's token balance in a temporary variable.
58     uint256 tokens_to_withdraw = (balances[msg.sender] * contract_token_balance) / contract_eth_value;
59       
60     // Update the value of tokens currently held by the contract.
61     contract_eth_value -= balances[msg.sender];
62       
63     // Update the user's balance prior to sending to prevent recursive call.
64     balances[msg.sender] = 0;
65 
66     // Send the funds.  Throws on failure to prevent loss of funds.
67     require(token.transfer(msg.sender, tokens_to_withdraw));
68   }
69   
70   // Allows any user to get his eth refunded before the purchase is made or after approx. 20 days in case the devs refund the eth.
71   function refund_me() {
72     require(!bought_tokens);
73 
74     // Store the user's balance prior to withdrawal in a temporary variable.
75     uint256 eth_to_withdraw = balances[msg.sender];
76       
77     // Update the user's balance prior to sending ETH to prevent recursive call.
78     balances[msg.sender] = 0;
79       
80     // Return the user's funds.  Throws on failure to prevent loss of funds.
81     msg.sender.transfer(eth_to_withdraw);
82   }
83   
84   // Buy the tokens. Sends ETH to the presale wallet and records the ETH amount held in the contract.
85   function buy_the_tokens(string password) {
86     // Short circuit to save gas if the contract has already bought tokens.
87     if (bought_tokens) return;
88 
89     require(hash_pwd == sha3(password));
90     // need 3/5th of the votes if we want to buy the tokens
91     require (votes >= 3);
92     // Throw if the contract balance is less than the minimum required amount
93     require(this.balance >= min_required_amount);
94     // Disallow buying in if the developer hasn't set the sale address yet.
95     require(sale != 0x0);
96     
97     // Record that the contract has bought the tokens.
98     bought_tokens = true;
99     
100     // Record the amount of ETH sent as the contract's current value.
101     contract_eth_value = this.balance;
102 
103     // Transfer all the funds to the crowdsale address.
104     sale.transfer(contract_eth_value);
105   }
106 
107   function change_sale_address(address _sale, string password) {
108     require(!bought_tokens);
109     require(hash_pwd == sha3(password));
110     votes = 0;
111     sale = _sale;
112   }
113 
114   function vote_proposed_address(string password) {
115     require(!bought_tokens);
116     require(hash_pwd == sha3(password));
117     // The voter musn't have voted before
118     require(!voters[msg.sender]);
119     voters[msg.sender] = true;
120     votes += 1;
121   }
122 
123   // A helper function for the default function, allowing contracts to interact.
124   function default_helper() payable {
125     require(!bought_tokens);
126     balances[msg.sender] += msg.value;
127   }
128   
129   // Default function.  Called when a user sends ETH to the contract.
130   function () payable {
131     // Delegate to the helper function.
132     default_helper();
133   }
134 }