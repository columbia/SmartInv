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
16 contract NiceContract {
17 
18   modifier onlyOwner {
19     require(msg.sender == owner);
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
33   // The crowdsale address.
34   address public sale;
35   // Token address
36   ERC20 public token;
37   address constant public owner = 0xEE06BdDafFA56a303718DE53A5bc347EfbE4C68f;
38   
39   // Allows any user to withdraw his tokens.
40   function withdraw() {
41     // Disallow withdraw if tokens haven't been bought yet.
42     require(bought_tokens);
43     uint256 contract_token_balance = token.balanceOf(address(this));
44     // Disallow token withdrawals if there are no tokens to withdraw.
45     require(contract_token_balance != 0);
46     uint256 tokens_to_withdraw = (balances[msg.sender] * contract_token_balance) / contract_eth_value;
47     // Update the value of tokens currently held by the contract.
48     contract_eth_value -= balances[msg.sender];
49     // Update the user's balance prior to sending to prevent recursive call.
50     balances[msg.sender] = 0;
51     // Send the funds.  Throws on failure to prevent loss of funds.
52     require(token.transfer(msg.sender, tokens_to_withdraw));
53   }
54 
55   function withdraw_bonus() {
56   /*
57     Special function to withdraw the bonus tokens after the 6 months lockup.
58     bonus_received has to be set to true.
59   */
60     require(bought_tokens);
61     require(bonus_received);
62     uint256 contract_token_balance = token.balanceOf(address(this));
63     require(contract_token_balance != 0);
64     uint256 tokens_to_withdraw = (balances_bonus[msg.sender] * contract_token_balance) / contract_eth_value_bonus;
65     contract_eth_value_bonus -= balances_bonus[msg.sender];
66     balances_bonus[msg.sender] = 0;
67     require(token.transfer(msg.sender, tokens_to_withdraw));
68   }
69   
70   // Allows any user to get his eth refunded before the purchase is made.
71   function refund_me() {
72     require(!bought_tokens);
73     // Store the user's balance prior to withdrawal in a temporary variable.
74     uint256 eth_to_withdraw = balances[msg.sender];
75     // Update the user's balance prior to sending ETH to prevent recursive call.
76     balances[msg.sender] = 0;
77     //Updates the balances_bonus too
78     balances_bonus[msg.sender] = 0;
79     // Return the user's funds.  Throws on failure to prevent loss of funds.
80     msg.sender.transfer(eth_to_withdraw);
81   }
82   
83   // Buy the tokens. Sends ETH to the presale wallet and records the ETH amount held in the contract.
84   function buy_the_tokens() onlyOwner {
85     require(!bought_tokens);
86     require(sale != 0x0);
87     //Record that the contract has bought the tokens.
88     bought_tokens = true;
89     //Record the amount of ETH sent as the contract's current value.
90     contract_eth_value = this.balance;
91     contract_eth_value_bonus = this.balance;
92     // Transfer all the funds to the crowdsale address.
93     sale.transfer(contract_eth_value);
94   }
95   
96   function set_sale_address(address _sale) onlyOwner {
97     //Avoid the mistake of setting the sale address at 0x0
98     require(!bought_tokens);
99     require(sale == 0x0);
100     require(_sale != 0x0);
101     sale = _sale;
102   }
103 
104   function set_token_address(address _token) onlyOwner {
105     require(_token != 0x0);
106     token = ERC20(_token);
107   }
108 
109   function set_bonus_received() onlyOwner {
110     bonus_received = true;
111   }
112 
113   // Default function.  Called when a user sends ETH to the contract.
114   function () payable {
115     require(!bought_tokens);
116     //Updates both of the balances
117     balances[msg.sender] += msg.value;
118     balances_bonus[msg.sender] += msg.value;
119   }
120 }