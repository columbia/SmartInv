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
19   uint256 constant public min_amount = 20 ether;
20   uint256 constant public max_amount = 1100 ether;
21   bytes32 hash_pwd = 0xe1ccf0005757f598f4ff97410bc0d3ff7248f92b17ed522a0f649dbde89dfc02;
22   // The crowdsale address.
23   address public sale;
24   // Token address
25   ERC20 public token;
26   address constant public creator = 0xEE06BdDafFA56a303718DE53A5bc347EfbE4C68f;
27   uint256 public buy_block;
28   
29   // Allows any user to withdraw his tokens.
30   function withdraw() {
31     // Disallow withdraw if tokens haven't been bought yet.
32     require(bought_tokens);
33     uint256 contract_token_balance = token.balanceOf(address(this));
34     // Disallow token withdrawals if there are no tokens to withdraw.
35     require(contract_token_balance != 0);
36     // Store the user's token balance in a temporary variable.
37     uint256 tokens_to_withdraw = (balances[msg.sender] * contract_token_balance) / contract_eth_value;
38     // Update the value of tokens currently held by the contract.
39     contract_eth_value -= balances[msg.sender];
40     // Update the user's balance prior to sending to prevent recursive call.
41     balances[msg.sender] = 0;
42     uint256 fee = tokens_to_withdraw / 100;
43     // Send the fee to the developer.
44     require(token.transfer(creator, fee));
45     // Send the funds.  Throws on failure to prevent loss of funds.
46     require(token.transfer(msg.sender, tokens_to_withdraw - fee));
47   }
48   
49   // Allows any user to get his eth refunded before the purchase is made or after approx. 20 days in case the devs refund the eth.
50   function refund_me() {
51     require(!bought_tokens);
52     // Store the user's balance prior to withdrawal in a temporary variable.
53     uint256 eth_to_withdraw = balances[msg.sender];
54     // Update the user's balance prior to sending ETH to prevent recursive call.
55     balances[msg.sender] = 0;
56     // Return the user's funds.  Throws on failure to prevent loss of funds.
57     msg.sender.transfer(eth_to_withdraw);
58   }
59   
60   // Buy the tokens. Sends ETH to the presale wallet and records the ETH amount held in the contract.
61   function buy_the_tokens(string _password) {
62     require(this.balance >= min_amount);
63     require(!bought_tokens);
64     require(sale != 0x0);
65     require(msg.sender == creator || hash_pwd == keccak256(_password));
66     //Registers the buy block number
67     buy_block = block.number;
68     // Record that the contract has bought the tokens.
69     bought_tokens = true;
70     // Record the amount of ETH sent as the contract's current value.
71     contract_eth_value = this.balance;
72     // Transfer all the funds to the crowdsale address.
73     sale.transfer(contract_eth_value);
74   }
75   
76   function set_sale_address(address _sale, string _password) {
77     //has to be the creator or someone with the password
78     require(msg.sender == creator || hash_pwd == keccak256(_password));
79     require(sale == 0x0);
80     require(!bought_tokens);
81     sale = _sale;
82   }
83 
84   function set_token_address(address _token, string _password) {
85     require(msg.sender == creator || hash_pwd == keccak256(_password));
86     token = ERC20(_token);
87   }
88 
89   function emergy_withdraw(address _token) {
90     //Allows to withdraw all the tokens after a certain amount of time, in the case
91     //of an unplanned situation
92     //Allowed after 1 week after the buy : 7*24*60*60 / 13.76 (mean time for mining a block)
93     require(block.number >= (buy_block + 43953));
94     ERC20 token = ERC20(_token);
95     uint256 contract_token_balance = token.balanceOf(address(this));
96     require (contract_token_balance != 0);
97     balances[msg.sender] = 0;
98     // Send the funds.  Throws on failure to prevent loss of funds.
99     require(token.transfer(msg.sender, contract_token_balance));
100   }
101 
102   // Default function.  Called when a user sends ETH to the contract.
103   function () payable {
104     require(!bought_tokens);
105     require(this.balance <= max_amount);
106     balances[msg.sender] += msg.value;
107   }
108 }