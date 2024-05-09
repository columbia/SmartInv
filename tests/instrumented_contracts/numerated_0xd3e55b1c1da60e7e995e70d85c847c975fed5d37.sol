1 pragma solidity ^0.4.11;
2 
3 /*
4 
5 BET Buyer
6 ========================
7 
8 Buys BET tokens from the DAO.Casino crowdsale on your behalf.
9 Author: /u/Cintix
10 
11 */
12 
13 // Interface to BET ICO Contract
14 contract DaoCasinoToken {
15   uint256 public CAP;
16   uint256 public totalEthers;
17   function proxyPayment(address participant) payable;
18   function transfer(address _to, uint _amount) returns (bool success);
19 }
20 
21 contract BetBuyer {
22   // Store the amount of ETH deposited by each account.
23   mapping (address => uint256) public balances;
24   // Store whether or not each account would have made it into the crowdsale.
25   mapping (address => bool) public checked_in;
26   // Bounty for executing buy.
27   uint256 public bounty;
28   // Track whether the contract has bought the tokens yet.
29   bool public bought_tokens;
30   // Record the time the contract bought the tokens.
31   uint256 public time_bought;
32   // Emergency kill switch in case a critical bug is found.
33   bool public kill_switch;
34   
35   // Ratio of BET tokens received to ETH contributed
36   uint256 bet_per_eth = 2000;
37   
38   // The BET Token address and sale address are the same.
39   DaoCasinoToken public token = DaoCasinoToken(0x2B09b52d42DfB4e0cBA43F607dD272ea3FE1FB9F);
40   // The developer address.
41   address developer = 0x000Fb8369677b3065dE5821a86Bc9551d5e5EAb9;
42   
43   // Allows the developer to shut down everything except withdrawals in emergencies.
44   function activate_kill_switch() {
45     // Only allow the developer to activate the kill switch.
46     if (msg.sender != developer) throw;
47     // Irreversibly activate the kill switch.
48     kill_switch = true;
49   }
50   
51   // Withdraws all ETH deposited or BET purchased by the sender.
52   function withdraw(){
53     // If called before the ICO, cancel caller's participation in the sale.
54     if (!bought_tokens) {
55       // Store the user's balance prior to withdrawal in a temporary variable.
56       uint256 eth_amount = balances[msg.sender];
57       // Update the user's balance prior to sending ETH to prevent recursive call.
58       balances[msg.sender] = 0;
59       // Return the user's funds.  Throws on failure to prevent loss of funds.
60       msg.sender.transfer(eth_amount);
61     }
62     // Withdraw the sender's tokens if the contract has already purchased them.
63     else {
64       // Store the user's BET balance in a temporary variable (1 ETHWei -> 2000 BETWei).
65       uint256 bet_amount = balances[msg.sender] * bet_per_eth;
66       // Update the user's balance prior to sending BET to prevent recursive call.
67       balances[msg.sender] = 0;
68       // No fee for withdrawing if the user would have made it into the crowdsale alone.
69       uint256 fee = 0;
70       // 1% fee if the user didn't check in during the crowdsale.
71       if (!checked_in[msg.sender]) {
72         fee = bet_amount / 100;
73         // Send any non-zero fees to developer.
74         if(!token.transfer(developer, fee)) throw;
75       }
76       // Send the user their tokens.  Throws if the crowdsale isn't over.
77       if(!token.transfer(msg.sender, bet_amount - fee)) throw;
78     }
79   }
80   
81   // Allow developer to add ETH to the buy execution bounty.
82   function add_to_bounty() payable {
83     // Only allow the developer to contribute to the buy execution bounty.
84     if (msg.sender != developer) throw;
85     // Disallow adding to bounty if kill switch is active.
86     if (kill_switch) throw;
87     // Disallow adding to the bounty if contract has already bought the tokens.
88     if (bought_tokens) throw;
89     // Update bounty to include received amount.
90     bounty += msg.value;
91   }
92   
93   // Buys tokens in the crowdsale and rewards the caller, callable by anyone.
94   function claim_bounty(){
95     // Short circuit to save gas if the contract has already bought tokens.
96     if (bought_tokens) return;
97     // Disallow buying into the crowdsale if kill switch is active.
98     if (kill_switch) throw;
99     // Record that the contract has bought the tokens.
100     bought_tokens = true;
101     // Record the time the contract bought the tokens.
102     time_bought = now;
103     // Transfer all the funds (less the bounty) to the BET crowdsale contract
104     // to buy tokens.  Throws if the crowdsale hasn't started yet or has
105     // already completed, preventing loss of funds.
106     token.proxyPayment.value(this.balance - bounty)(address(this));
107     // Send the caller their bounty for buying tokens for the contract.
108     msg.sender.transfer(bounty);
109   }
110   
111   // A helper function for the default function, allowing contracts to interact.
112   function default_helper() payable {
113     // Treat near-zero ETH transactions as check ins and withdrawal requests.
114     if (msg.value <= 1 finney) {
115       // Check in during the crowdsale.
116       if (bought_tokens) {
117         // Only allow checking in before the crowdsale has reached the cap.
118         if (token.totalEthers() >= token.CAP()) throw;
119         // Mark user as checked in, meaning they would have been able to enter alone.
120         checked_in[msg.sender] = true;
121       }
122       // Withdraw funds if the crowdsale hasn't begun yet or is already over.
123       else {
124         withdraw();
125       }
126     }
127     // Deposit the user's funds for use in purchasing tokens.
128     else {
129       // Disallow deposits if kill switch is active.
130       if (kill_switch) throw;
131       // Only allow deposits if the contract hasn't already purchased the tokens.
132       if (bought_tokens) throw;
133       // Update records of deposited ETH to include the received amount.
134       balances[msg.sender] += msg.value;
135     }
136   }
137   
138   // Default function.  Called when a user sends ETH to the contract.
139   function () payable {
140     // Delegate to the helper function.
141     default_helper();
142   }
143 }