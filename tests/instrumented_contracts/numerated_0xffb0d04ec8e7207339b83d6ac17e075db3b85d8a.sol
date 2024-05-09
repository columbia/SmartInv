1 // Author : shift
2 
3 pragma solidity ^0.4.13;
4 
5 // ERC20 Interface: https://github.com/ethereum/EIPs/issues/20
6 contract ERC20 {
7   function transfer(address _to, uint256 _value) returns (bool success);
8   function balanceOf(address _owner) constant returns (uint256 balance);
9 }
10 
11 /*
12   This contract stores twice every key value in order to be able to redistribute funds
13   when the bonus tokens are received (which is typically X months after the initial buy).
14 */
15 
16 contract SuperbContract {
17 
18   modifier onlyOwner {
19     require(msg.sender == owner);
20     _;
21   }
22 
23   //Constants of the contract
24   uint256 FEE = 100;    //1% fee
25   uint256 FEE_DEV = 10; //10% on the 1% fee
26   address public owner;
27   address constant public developer = 0xEE06BdDafFA56a303718DE53A5bc347EfbE4C68f;
28 
29   //Variables subject to changes
30   uint256 public max_amount = 0 ether;  //0 means there is no limit
31   uint256 public min_amount = 0 ether;
32 
33   //Store the amount of ETH deposited by each account.
34   mapping (address => uint256) public balances;
35   mapping (address => uint256) public balances_bonus;
36   // Track whether the contract has bought the tokens yet.
37   bool public bought_tokens = false;
38   // Record ETH value of tokens currently held by contract.
39   uint256 public contract_eth_value;
40   uint256 public contract_eth_value_bonus;
41   //Set by the owner in order to allow the withdrawal of bonus tokens.
42   bool bonus_received;
43   //The address of the contact.
44   address public sale = 0x98Ba698Fc04e79DCE066873106424252e6aabc31;
45   //Token address
46   ERC20 public token;
47   //Records the fees that have to be sent
48   uint256 fees;
49   //Set by the owner if the ETH got refunded by the project
50   bool got_refunded;
51   
52   function SuperbContract() {
53     /*
54     Constructor
55     */
56     owner = msg.sender;
57   }
58 
59   //Functions for the owner
60 
61   // Buy the tokens. Sends ETH to the presale wallet and records the ETH amount held in the contract.
62   function buy_the_tokens() onlyOwner {
63     require(!bought_tokens);
64     //Avoids burning the funds
65     require(sale != 0x0);
66     //Minimum has to be reached
67     require(this.balance >= min_amount);
68     //Record that the contract has bought the tokens.
69     bought_tokens = true;
70     //Sends before so the contract_eth_value contains the correct balance
71     uint256 dev_fee = fees/FEE_DEV;
72     owner.transfer(fees-dev_fee);
73     developer.transfer(dev_fee);
74     //Record the amount of ETH sent as the contract's current value.
75     contract_eth_value = this.balance;
76     contract_eth_value_bonus = this.balance;
77     // Transfer all the funds to the crowdsale address.
78     sale.transfer(contract_eth_value);
79   }
80 
81   function set_token_address(address _token) onlyOwner {
82     require(_token != 0x0);
83     token = ERC20(_token);
84   }
85 
86   function set_bonus_received() onlyOwner {
87     bonus_received = true;
88   }
89 
90   function set_got_refunded() onlyOwner {
91     /*
92     In case, for some reasons, the project refunds the money
93     */
94     got_refunded = true;
95   }
96 
97   function changeOwner(address new_owner) onlyOwner {
98     require(new_owner != 0x0);
99     owner = new_owner;
100   }
101 
102   //Public functions
103 
104   // Allows any user to withdraw his tokens.
105   function withdraw() {
106     // Disallow withdraw if tokens haven't been bought yet.
107     require(bought_tokens);
108     uint256 contract_token_balance = token.balanceOf(address(this));
109     // Disallow token withdrawals if there are no tokens to withdraw.
110     require(contract_token_balance != 0);
111     uint256 tokens_to_withdraw = (balances[msg.sender] * contract_token_balance) / contract_eth_value;
112     // Update the value of tokens currently held by the contract.
113     contract_eth_value -= balances[msg.sender];
114     // Update the user's balance prior to sending to prevent recursive call.
115     balances[msg.sender] = 0;
116     // Send the funds.  Throws on failure to prevent loss of funds.
117     require(token.transfer(msg.sender, tokens_to_withdraw));
118   }
119 
120   function withdraw_bonus() {
121   /*
122     Special function to withdraw the bonus tokens after the 6 months lockup.
123     bonus_received has to be set to true.
124   */
125     require(bought_tokens);
126     require(bonus_received);
127     uint256 contract_token_balance = token.balanceOf(address(this));
128     require(contract_token_balance != 0);
129     uint256 tokens_to_withdraw = (balances_bonus[msg.sender] * contract_token_balance) / contract_eth_value_bonus;
130     contract_eth_value_bonus -= balances_bonus[msg.sender];
131     balances_bonus[msg.sender] = 0;
132     require(token.transfer(msg.sender, tokens_to_withdraw));
133   }
134   
135   // Allows any user to get his eth refunded before the purchase is made.
136   function refund_me() {
137     require(!bought_tokens || got_refunded);
138     // Store the user's balance prior to withdrawal in a temporary variable.
139     uint256 eth_to_withdraw = balances[msg.sender];
140     // Update the user's balance prior to sending ETH to prevent recursive call.
141     balances[msg.sender] = 0;
142     //Updates the balances_bonus too
143     balances_bonus[msg.sender] = 0;
144     // Return the user's funds.  Throws on failure to prevent loss of funds.
145     msg.sender.transfer(eth_to_withdraw);
146   }
147 
148   // Default function.  Called when a user sends ETH to the contract.
149   function () payable {
150     require(!bought_tokens);
151     //Check if the max amount has been reached, if there is one
152     require(max_amount == 0 || this.balance <= max_amount);
153     //1% fee is taken on the ETH
154     uint256 fee = msg.value / FEE;
155     fees += fee;
156     //Updates both of the balances
157     balances[msg.sender] += (msg.value-fee);
158     balances_bonus[msg.sender] += (msg.value-fee);
159   }
160 }