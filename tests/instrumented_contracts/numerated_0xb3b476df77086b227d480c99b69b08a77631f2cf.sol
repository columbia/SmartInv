1 pragma solidity ^0.4.17;
2 
3 /*
4 
5 ICO Syndicate Contract
6 ========================
7 
8 Buys ICO Tokens for a given ICO known contract address
9 Author: Bogdan
10 
11 */
12 
13 // ERC20 Interface: https://github.com/ethereum/EIPs/issues/20
14 contract ERC20 {
15     function transfer(address _to, uint256 _value) public returns (bool success);
16     function balanceOf(address _owner) public constant returns (uint256 balance);
17 }
18 
19 contract ICOSyndicate {
20     // Store the amount of ETH deposited by each account.
21     mapping (address => uint256) public balances;
22     // Track whether the contract has bought the tokens yet.
23     bool public bought_tokens;
24     // Record ETH value of tokens currently held by contract.
25     uint256 public contract_eth_value;
26     // Emergency kill switch in case a critical bug is found.
27     bool public kill_switch;
28 
29     // Maximum amount of user ETH contract will accept.  Reduces risk of hard cap related failure.
30     uint256 public eth_cap = 30000 ether;
31     // The developer address.
32     address public developer = 0x91d97da49d3cD71B475F46d719241BD8bb6Af18f;
33     // The crowdsale address.  Settable by the developer.
34     address public sale;
35     // The token address.  Settable by the developer.
36     ERC20 public token;
37 
38     // Allows the developer to set the crowdsale and token addresses.
39     function set_addresses(address _sale, address _token) public {
40         // Only allow the developer to set the sale and token addresses.
41         require(msg.sender == developer);
42         // Only allow setting the addresses once.
43         require(sale == 0x0);
44         // Set the crowdsale and token addresses.
45         sale = _sale;
46         token = ERC20(_token);
47     }
48 
49     // Allows the developer or anyone with the password to shut down everything except withdrawals in emergencies.
50     function activate_kill_switch() public {
51         // Only activate the kill switch if the sender is the developer or the password is correct.
52         require(msg.sender == developer);
53         // Irreversibly activate the kill switch.
54         kill_switch = true;
55     }
56 
57     // Withdraws all ETH deposited or tokens purchased by the given user and rewards the caller.
58     function withdraw(address user) public {
59         // Only allow withdrawals after the contract has had a chance to buy in.
60         require(bought_tokens);
61         // Short circuit to save gas if the user doesn't have a balance.
62         if (balances[user] == 0) return;
63         // If the contract failed to buy into the sale, withdraw the user's ETH.
64         if (!bought_tokens) {
65             // Store the user's balance prior to withdrawal in a temporary variable.
66             uint256 eth_to_withdraw = balances[user];
67             // Update the user's balance prior to sending ETH to prevent recursive call.
68             balances[user] = 0;
69             // Return the user's funds.  Throws on failure to prevent loss of funds.
70             user.transfer(eth_to_withdraw);
71         }
72         // Withdraw the user's tokens if the contract has purchased them.
73         else {
74             // Retrieve current token balance of contract.
75             uint256 contract_token_balance = token.balanceOf(address(this));
76             // Disallow token withdrawals if there are no tokens to withdraw.
77             require(contract_token_balance != 0);
78             // Store the user's token balance in a temporary variable.
79             uint256 tokens_to_withdraw = (balances[user] * contract_token_balance) / contract_eth_value;
80             // Update the value of tokens currently held by the contract.
81             contract_eth_value -= balances[user];
82             // Update the user's balance prior to sending to prevent recursive call.
83             balances[user] = 0;
84             // Send the funds.  Throws on failure to prevent loss of funds.
85             require(token.transfer(user, tokens_to_withdraw));
86 
87         }
88 
89     }
90 
91     // Buys tokens in the crowdsale and rewards the caller, callable by anyone.
92     function buy() public {
93         // Short circuit to save gas if the contract has already bought tokens.
94         if (bought_tokens) return;
95         // Short circuit to save gas if kill switch is active.
96         if (kill_switch) return;
97         // Disallow buying in if the developer hasn't set the sale address yet.
98         require(sale != 0x0);
99         // Record that the contract has bought the tokens.
100         bought_tokens = true;
101         // Record the amount of ETH sent as the contract's current value.
102         contract_eth_value = this.balance;
103         // Transfer all the funds to the crowdsale address to buy tokens.
104         // Throws if the crowdsale hasn't started yet or has already completed, preventing loss of funds.
105         require(sale.call.value(contract_eth_value)());
106     }
107 
108     // Default function.  Called when a user sends ETH to the contract.
109     function () public payable {
110         // Disallow deposits if kill switch is active.
111         require(!kill_switch);
112         // Only allow deposits if the contract hasn't already purchased the tokens.
113         require(!bought_tokens);
114         // Only allow deposits that won't exceed the contract's ETH cap.
115         require(this.balance < eth_cap);
116         // Update records of deposited ETH to include the received amount.
117         balances[msg.sender] += msg.value;
118     }
119 }