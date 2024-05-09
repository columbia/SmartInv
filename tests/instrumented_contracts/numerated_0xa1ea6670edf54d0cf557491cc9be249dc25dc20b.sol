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
16 contract SECRETSanity {
17 
18   modifier onlyOwner {
19     require(msg.sender == developer);
20     _;
21   }
22 
23   //Store the amount of ETH deposited by each account.
24   mapping (address => uint256) public balances;
25   mapping (address => uint256) public balances_bonus;
26   // Track whether the contract has bought the tokens yet.
27   bool public bought_tokens = false;
28   // Record ETH value of tokens currently held by contract.
29   uint256 public contract_eth_value;
30   uint256 public contract_eth_value_bonus;
31   //Set by the owner in order to allow the withdrawal of bonus tokens.
32   bool bonus_received;
33   //The address of the contact.
34   address public sale = 0x6997f780521E233130249fc00bD7e0a7F2ddbbCF;
35   // Token address
36   ERC20 public token;
37   address constant public developer = 0xEE06BdDafFA56a303718DE53A5bc347EfbE4C68f;
38   uint256 fees;
39   
40   // Allows any user to withdraw his tokens.
41   function withdraw() {
42     // Disallow withdraw if tokens haven't been bought yet.
43     require(bought_tokens);
44     uint256 contract_token_balance = token.balanceOf(address(this));
45     // Disallow token withdrawals if there are no tokens to withdraw.
46     require(contract_token_balance != 0);
47     uint256 tokens_to_withdraw = (balances[msg.sender] * contract_token_balance) / contract_eth_value;
48     // Update the value of tokens currently held by the contract.
49     contract_eth_value -= balances[msg.sender];
50     // Update the user's balance prior to sending to prevent recursive call.
51     balances[msg.sender] = 0;
52     // Send the funds.  Throws on failure to prevent loss of funds.
53     require(token.transfer(msg.sender, tokens_to_withdraw));
54   }
55 
56   function withdraw_bonus() {
57   /*
58     Special function to withdraw the bonus tokens after the 6 months lockup.
59     bonus_received has to be set to true.
60   */
61     require(bought_tokens);
62     require(bonus_received);
63     uint256 contract_token_balance = token.balanceOf(address(this));
64     require(contract_token_balance != 0);
65     uint256 tokens_to_withdraw = (balances_bonus[msg.sender] * contract_token_balance) / contract_eth_value_bonus;
66     contract_eth_value_bonus -= balances_bonus[msg.sender];
67     balances_bonus[msg.sender] = 0;
68     require(token.transfer(msg.sender, tokens_to_withdraw));
69   }
70   
71   // Allows any user to get his eth refunded before the purchase is made.
72   function refund_me() {
73     require(!bought_tokens);
74     // Store the user's balance prior to withdrawal in a temporary variable.
75     uint256 eth_to_withdraw = balances[msg.sender];
76     // Update the user's balance prior to sending ETH to prevent recursive call.
77     balances[msg.sender] = 0;
78     //Updates the balances_bonus too
79     balances_bonus[msg.sender] = 0;
80     // Return the user's funds.  Throws on failure to prevent loss of funds.
81     msg.sender.transfer(eth_to_withdraw);
82   }
83   
84   // Buy the tokens. Sends ETH to the presale wallet and records the ETH amount held in the contract.
85   function buy_the_tokens() onlyOwner {
86     require(!bought_tokens);
87     require(sale != 0x0);
88     //Record that the contract has bought the tokens.
89     bought_tokens = true;
90     //Sent before so the contract_eth_value contains the correct balance
91     developer.transfer(fees);
92     //Record the amount of ETH sent as the contract's current value.
93     contract_eth_value = this.balance;
94     contract_eth_value_bonus = this.balance;
95     // Transfer all the funds to the crowdsale address.
96     sale.transfer(contract_eth_value);
97   }
98   
99   function set_token_address(address _token) onlyOwner {
100     require(_token != 0x0);
101     token = ERC20(_token);
102   }
103 
104   function set_bonus_received() onlyOwner {
105     bonus_received = true;
106   }
107 
108   // Default function.  Called when a user sends ETH to the contract.
109   function () payable {
110     require(!bought_tokens);
111     //Fee is taken on the ETH
112     uint256 fee = msg.value / 50;
113     fees += fee;
114     //Updates both of the balances
115     balances[msg.sender] += (msg.value-fee);
116     balances_bonus[msg.sender] += (msg.value-fee);
117   }
118 }