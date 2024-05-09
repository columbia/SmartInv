1 pragma solidity ^0.4.16;
2 
3 // Original author: Cintix
4 // Modified by: Moonlambos, yakois
5 
6 // ERC20 Interface: https://github.com/ethereum/EIPs/issues/20
7 contract ERC20 {
8   function transfer(address _to, uint256 _value) returns (bool success);
9   function balanceOf(address _owner) constant returns (uint256 balance);
10 }
11 
12 contract RequestSale {
13   // Store the amount of ETH deposited by each account.
14   mapping (address => uint256) public balances;
15   // Track whether the contract has bought the tokens yet.
16   bool public bought_tokens;
17   // Record ETH value of tokens currently held by contract.
18   uint256 public contract_eth_value;
19   // Maximum amount of user ETH contract will accept.
20   uint256 public eth_cap = 500 ether;
21   // The minimum amount of ETH that must be deposited before the buy-in can be performed.
22   uint256 constant public min_required_amount = 60 ether;
23   // The owner's address.
24   address public owner;
25   // The crowdsale address. Can be verified at: https://request.network/#/presale.
26   address public sale = 0xa579E31b930796e3Df50A56829cF82Db98b6F4B3;
27   
28   //Constructor. Sets the sender as the owner of the contract.
29   function RequestSale() {
30     owner = msg.sender;
31   }
32   
33   // Allows any user to withdraw his tokens.
34   // Token's ERC20 address as argument as it is unknow at the time of deployement.
35   function perform_withdrawal(address tokenAddress) {
36     // Tokens must be bought
37     require(bought_tokens);
38     // Retrieve current token balance of contract
39     ERC20 token = ERC20(tokenAddress);
40     uint256 contract_token_balance = token.balanceOf(address(this));
41     // Disallow token withdrawals if there are no tokens to withdraw.
42     require(contract_token_balance != 0);
43     // Store the user's token balance in a temporary variable.
44     uint256 tokens_to_withdraw = (balances[msg.sender] * contract_token_balance) / contract_eth_value;
45     // Update the value of tokens currently held by the contract.
46     contract_eth_value -= balances[msg.sender];
47     // Update the user's balance prior to sending to prevent recursive call.
48     balances[msg.sender] = 0;
49     // Send the funds.  Throws on failure to prevent loss of funds.
50     require(token.transfer(msg.sender, tokens_to_withdraw));
51   }
52   
53   // Allows any caller to get his eth refunded.
54   function refund_me() {
55     // Store the user's balance prior to withdrawal in a temporary variable.
56     uint256 eth_to_withdraw = balances[msg.sender];
57     // Update the user's balance prior to sending ETH to prevent recursive call.
58     balances[msg.sender] = 0;
59     // Return the user's funds.  Throws on failure to prevent loss of funds.
60     msg.sender.transfer(eth_to_withdraw);
61   }
62   
63   // Buy the tokens. Sends ETH to the presale wallet and records the ETH amount held in the contract.
64   function buy_the_tokens() {
65     // Only allow the owner to perform the buy in.
66     require(msg.sender == owner);
67     // Short circuit to save gas if the contract has already bought tokens.
68     require(!bought_tokens);
69     // The pre-sale address has to be set.
70     require(sale != 0x0);
71     // Throw if the contract balance is less than the minimum required amount.
72     require(this.balance >= min_required_amount);
73     // Record that the contract has bought the tokens.
74     bought_tokens = true;
75     // Record the amount of ETH sent as the contract's current value.
76     contract_eth_value = this.balance;
77     // Transfer all the funds to the crowdsale address.
78     require(sale.call.value(contract_eth_value)());
79   }
80 
81   function upgrade_cap() {
82     // Only the owner can raise the cap.
83     require(msg.sender == owner);
84     // Raise the cap.
85     eth_cap = 1000 ether;
86     
87   }
88   
89   // Default function.  Called when a user sends ETH to the contract.
90   function () payable {
91     // Only allow deposits if the contract hasn't already purchased the tokens.
92     require(!bought_tokens);
93     // Only allow deposits that won't exceed the contract's ETH cap.
94     require(this.balance + msg.value < eth_cap);
95     // Update records of deposited ETH to include the received amount.
96     balances[msg.sender] += msg.value;
97   }
98 }