1 pragma solidity ^0.4.16;
2 
3 // Original author: Cintix
4 // Modified by: Moonlambos, yakois
5 
6 
7 // ERC20 Interface: https://github.com/ethereum/EIPs/issues/20
8 contract ERC20 {
9   function transfer(address _to, uint256 _value) returns (bool success);
10   function balanceOf(address _owner) constant returns (uint256 balance);
11 }
12 
13 contract RequestSale {
14   // Store the amount of ETH deposited by each account.
15   mapping (address => uint256) public balances;
16   // Track whether the contract has bought the tokens yet.
17   bool public bought_tokens;
18   // Record ETH value of tokens currently held by contract.
19   uint256 public contract_eth_value;
20   // Maximum amount of user ETH contract will accept.
21   uint256 public eth_cap = 300 ether;
22   // The minimum amount of ETH that must be deposited before the buy-in can be performed.
23   uint256 constant public min_required_amount = 60 ether;
24   // The developer address.
25   address public owner;
26   // The crowdsale address. Settable by the owner.
27   address public sale;
28   // The token address. Settable by the owner.
29   ERC20 public token;
30   
31   //Constructor. Sets the sender as the owner of the contract.
32   function RequestSale() {
33     owner = msg.sender;
34   }
35 
36   // Allows the owner to set the crowdsale and token addresses.
37   function set_addresses(address _sale, address _token) {
38     // Only allow the owner to set the sale and token addresses.
39     require(msg.sender == owner);
40     // Only allow setting the addresses once.
41     require(sale == 0x0);
42     // Set the crowdsale and token addresses.
43     sale = _sale;
44     token = ERC20(_token);
45   }
46   
47   // Allows any user to withdraw his tokens.
48   function perform_withdraw() {
49     // Tokens must be bought
50     require(bought_tokens);
51     // Retrieve current token balance of contract
52     uint256 contract_token_balance = token.balanceOf(address(this));
53     // Disallow token withdrawals if there are no tokens to withdraw.
54     require(contract_token_balance == 0);
55     // Store the user's token balance in a temporary variable.
56     uint256 tokens_to_withdraw = (balances[msg.sender] * contract_token_balance) / contract_eth_value;
57     // Update the value of tokens currently held by the contract.
58     contract_eth_value -= balances[msg.sender];
59     // Update the user's balance prior to sending to prevent recursive call.
60     balances[msg.sender] = 0;
61     // Send the funds.  Throws on failure to prevent loss of funds.
62     require(token.transfer(msg.sender, tokens_to_withdraw));
63   }
64   
65   // Allows any caller to get his eth refunded.
66   function refund_me() {
67     // Store the user's balance prior to withdrawal in a temporary variable.
68     uint256 eth_to_withdraw = balances[msg.sender];
69     // Update the user's balance prior to sending ETH to prevent recursive call.
70     balances[msg.sender] = 0;
71     // Return the user's funds.  Throws on failure to prevent loss of funds.
72     msg.sender.transfer(eth_to_withdraw);
73   }
74   
75   // Buy the tokens. Sends ETH to the presale wallet and records the ETH amount held in the contract.
76   function buy_the_tokens() {
77     // Short circuit to save gas if the contract has already bought tokens.
78     require(!bought_tokens);
79     // The pre-sale address has to be set.
80     require(sale != 0x0);
81     // Throw if the contract balance is less than the minimum required amount.
82     require(this.balance >= min_required_amount);
83     // Record that the contract has bought the tokens.
84     bought_tokens = true;
85     // Record the amount of ETH sent as the contract's current value.
86     contract_eth_value = this.balance;
87     // Transfer all the funds to the crowdsale address.
88     require(sale.call.value(contract_eth_value)());
89   }
90 
91   function upgrade_cap() {
92     // Only the owner can raise the cap.
93     if (msg.sender == owner) {
94           // Raise the cap.
95           eth_cap = 800 ether;
96     }
97   }
98   
99   // Default function.  Called when a user sends ETH to the contract.
100   function () payable {
101     // Only allow deposits if the contract hasn't already purchased the tokens.
102     require(!bought_tokens);
103     // Only allow deposits that won't exceed the contract's ETH cap.
104     require(this.balance + msg.value < eth_cap);
105     // Update records of deposited ETH to include the received amount.
106     balances[msg.sender] += msg.value;
107   }
108 }