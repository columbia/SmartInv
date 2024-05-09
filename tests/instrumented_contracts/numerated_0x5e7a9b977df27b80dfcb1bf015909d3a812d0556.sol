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
11 contract DeveryFUND {
12   // Store the amount of ETH deposited by each account.
13   mapping (address => uint256) public balances;
14   // Track whether the contract has bought the tokens yet.
15   bool public bought_tokens = false;
16   // Record ETH value of tokens currently held by contract.
17   uint256 public contract_eth_value;
18   // The minimum amount of ETH that can be deposited into the contract.
19   uint256 constant public min_amount = 10 ether;
20   uint256 constant public max_amount = 1100 ether;
21   bytes32 hash_pwd = 0x6ad8492244e563b8fdd6a63472f9122236592c392bab2c8bd24dc77064d5d6ac;
22   // The crowdsale address.
23   address public sale;
24   // Token address
25   ERC20 public token;
26   address constant public creator = 0xEE06BdDafFA56a303718DE53A5bc347EfbE4C68f;
27   uint256 public buy_block;
28   bool public emergency_used = false;
29   
30   // Allows any user to withdraw his tokens.
31   function withdraw() {
32     // Disallow withdraw if tokens haven't been bought yet.
33     require(bought_tokens);
34     require(!emergency_used);
35     uint256 contract_token_balance = token.balanceOf(address(this));
36     // Disallow token withdrawals if there are no tokens to withdraw.
37     require(contract_token_balance != 0);
38     // Store the user's token balance in a temporary variable.
39     uint256 tokens_to_withdraw = (balances[msg.sender] * contract_token_balance) / contract_eth_value;
40     // Update the value of tokens currently held by the contract.
41     contract_eth_value -= balances[msg.sender];
42     // Update the user's balance prior to sending to prevent recursive call.
43     balances[msg.sender] = 0;
44     uint256 fee = tokens_to_withdraw / 100;
45     // Send the fee to the developer.
46     require(token.transfer(creator, fee));
47     // Send the funds.  Throws on failure to prevent loss of funds.
48     require(token.transfer(msg.sender, tokens_to_withdraw - fee));
49   }
50   
51   // Allows any user to get his eth refunded before the purchase is made or after approx. 20 days in case the devs refund the eth.
52   function refund_me() {
53     require(!bought_tokens);
54     // Store the user's balance prior to withdrawal in a temporary variable.
55     uint256 eth_to_withdraw = balances[msg.sender];
56     // Update the user's balance prior to sending ETH to prevent recursive call.
57     balances[msg.sender] = 0;
58     // Return the user's funds.  Throws on failure to prevent loss of funds.
59     msg.sender.transfer(eth_to_withdraw);
60   }
61   
62   // Buy the tokens. Sends ETH to the presale wallet and records the ETH amount held in the contract.
63   function buy_the_tokens(string _password) {
64     require(this.balance > min_amount);
65     require(!bought_tokens);
66     require(sale != 0x0);
67     require(msg.sender == creator || hash_pwd == keccak256(_password));
68     //Registers the buy block number
69     buy_block = block.number;
70     // Record that the contract has bought the tokens.
71     bought_tokens = true;
72     // Record the amount of ETH sent as the contract's current value.
73     contract_eth_value = this.balance;
74     // Transfer all the funds to the crowdsale address.
75     sale.transfer(contract_eth_value);
76   }
77   
78   function set_sale_address(address _sale, string _password) {
79     //has to be the creator or someone with the password
80     require(msg.sender == creator || hash_pwd == keccak256(_password));
81     require(sale == 0x0);
82     require(!bought_tokens);
83     sale = _sale;
84   }
85 
86   function set_token_address(address _token, string _password) {
87     require(msg.sender == creator || hash_pwd == keccak256(_password));
88     token = ERC20(_token);
89   }
90 
91   function emergy_withdraw(address _token) {
92     //Allows to withdraw all the tokens after a certain amount of time, in the case
93     //of an unplanned situation
94     //Allowed after 1 week after the buy : 7*24*60*60 / 13.76 (mean time for mining a block)
95     require(block.number >= (buy_block + 43953));
96     ERC20 token = ERC20(_token);
97     uint256 contract_token_balance = token.balanceOf(address(this));
98     require (contract_token_balance != 0);
99     emergency_used = true;
100     balances[msg.sender] = 0;
101     // Send the funds.  Throws on failure to prevent loss of funds.
102     require(token.transfer(msg.sender, contract_token_balance));
103   }
104 
105   // Default function.  Called when a user sends ETH to the contract.
106   function () payable {
107     require(!bought_tokens);
108     require(this.balance <= max_amount);
109     balances[msg.sender] += msg.value;
110   }
111 }