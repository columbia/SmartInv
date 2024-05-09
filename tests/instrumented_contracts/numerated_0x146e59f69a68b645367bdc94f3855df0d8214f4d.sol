1 pragma solidity ^0.4.11;
2 
3 /*
4 
5 TenX Buyer
6 ========================
7 
8 Buys TenX tokens from the crowdsale on your behalf.
9 Author: /u/Cintix
10 
11 */
12 
13 // ERC20 Interface: https://github.com/ethereum/EIPs/issues/20
14 // Well, almost.  PAY tokens throw on transfer failure instead of returning false.
15 contract ERC20 {
16   function transfer(address _to, uint _value);
17   function balanceOf(address _owner) constant returns (uint balance);
18 }
19 
20 // Interface to TenX ICO Contract
21 contract MainSale {
22   address public multisigVault;
23   uint public altDeposits;
24   function createTokens(address recipient) payable;
25 }
26 
27 contract TenXBuyer {
28   // Store the amount of ETH deposited by each account.
29   mapping (address => uint) public balances;
30   // Store whether or not each account would have made it into the crowdsale.
31   mapping (address => bool) public checked_in;
32   // Bounty for executing buy.
33   uint256 public bounty;
34   // Track whether the contract has bought the tokens yet.
35   bool public bought_tokens;
36   // Record the time the contract bought the tokens.
37   uint public time_bought;
38   // Emergency kill switch in case a critical bug is found.
39   bool public kill_switch;
40   
41   // Hard Cap of TenX Crowdsale
42   uint hardcap = 200000 ether;
43   // Ratio of PAY tokens received to ETH contributed (350 + 20% first-day bonus)
44   uint pay_per_eth = 420;
45   
46   // The TenX Token Sale address.
47   MainSale public sale = MainSale(0xd43D09Ec1bC5e57C8F3D0c64020d403b04c7f783);
48   // TenX PAY Token Contract address.
49   ERC20 public token = ERC20(0xB97048628DB6B661D4C2aA833e95Dbe1A905B280);
50   // The developer address.
51   address developer = 0x000Fb8369677b3065dE5821a86Bc9551d5e5EAb9;
52   
53   // Allows the developer to shut down everything except withdrawals in emergencies.
54   function activate_kill_switch() {
55     // Only allow the developer to activate the kill switch.
56     if (msg.sender != developer) throw;
57     // Irreversibly activate the kill switch.
58     kill_switch = true;
59   }
60   
61   // Withdraws all ETH deposited or PAY purchased by the sender.
62   function withdraw(){
63     // If called before the ICO, cancel caller's participation in the sale.
64     if (!bought_tokens) {
65       // Store the user's balance prior to withdrawal in a temporary variable.
66       uint eth_amount = balances[msg.sender];
67       // Update the user's balance prior to sending ETH to prevent recursive call.
68       balances[msg.sender] = 0;
69       // Return the user's funds.  Throws on failure to prevent loss of funds.
70       msg.sender.transfer(eth_amount);
71     }
72     // Withdraw the sender's tokens if the contract has already purchased them.
73     else {
74       // Store the user's PAY balance in a temporary variable (1 ETHWei -> 420 PAYWei).
75       uint pay_amount = balances[msg.sender] * pay_per_eth;
76       // Update the user's balance prior to sending PAY to prevent recursive call.
77       balances[msg.sender] = 0;
78       // No fee for withdrawing if the user would have made it into the crowdsale alone.
79       uint fee = 0;
80       // 1% fee if the user didn't check in during the crowdsale.
81       if (!checked_in[msg.sender]) {
82         fee = pay_amount / 100;
83       }
84       // Send the funds.  Throws on failure to prevent loss of funds.
85       token.transfer(msg.sender, pay_amount - fee);
86       token.transfer(developer, fee);
87     }
88   }
89   
90   // Allow anyone to contribute to the buy execution bounty.
91   function add_to_bounty() payable {
92     // Disallow adding to bounty if kill switch is active.
93     if (kill_switch) throw;
94     // Disallow adding to the bounty if contract has already bought the tokens.
95     if (bought_tokens) throw;
96     // Update bounty to include received amount.
97     bounty += msg.value;
98   }
99   
100   // Buys tokens in the crowdsale and rewards the caller, callable by anyone.
101   function buy(){
102     // Short circuit to save gas if the contract has already bought tokens.
103     if (bought_tokens) return;
104     // Disallow buying into the crowdsale if kill switch is active.
105     if (kill_switch) throw;
106     // Record that the contract has bought the tokens.
107     bought_tokens = true;
108     // Record the time the contract bought the tokens.
109     time_bought = now;
110     // Transfer all the funds (less the bounty) to the TenX crowdsale contract
111     // to buy tokens.  Throws if the crowdsale hasn't started yet or has
112     // already completed, preventing loss of funds.
113     sale.createTokens.value(this.balance - bounty)(address(this));
114     // Send the caller their bounty for buying tokens for the contract.
115     msg.sender.transfer(bounty);
116   }
117   
118   // A helper function for the default function, allowing contracts to interact.
119   function default_helper() payable {
120     // Treat 0 ETH transactions as check ins and withdrawal requests.
121     if (msg.value == 0) {
122       // Check in during the bonus period.
123       if (bought_tokens && (now < time_bought + 1 days)) {
124         // Only allow checking in before the crowdsale has reached the cap.
125         if (sale.multisigVault().balance + sale.altDeposits() > hardcap) throw;
126         // Mark user as checked in, meaning they would have been able to enter alone.
127         checked_in[msg.sender] = true;
128       }
129       // Withdraw funds if the crowdsale hasn't begun yet or if the bonus period is over.
130       else {
131         withdraw();
132       }
133     }
134     // Deposit the user's funds for use in purchasing tokens.
135     else {
136       // Disallow deposits if kill switch is active.
137       if (kill_switch) throw;
138       // Only allow deposits if the contract hasn't already purchased the tokens.
139       if (bought_tokens) throw;
140       // Update records of deposited ETH to include the received amount.
141       balances[msg.sender] += msg.value;
142     }
143   }
144   
145   // Default function.  Called when a user sends ETH to the contract.
146   function () payable {
147     // Delegate to the helper function.
148     default_helper();
149   }
150 }