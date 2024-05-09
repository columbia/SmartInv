1 pragma solidity ^0.4.11;
2 
3 /*
4 
5 Status Buyer
6 ========================
7 
8 Buys Status tokens from the crowdsale on your behalf.
9 Author: /u/Cintix
10 
11 */
12 
13 // ERC20 Interface: https://github.com/ethereum/EIPs/issues/20
14 contract ERC20 {
15   function transfer(address _to, uint256 _value) returns (bool success);
16   function balanceOf(address _owner) constant returns (uint256 balance);
17 }
18 
19 // Interface to Status ICO Contract
20 contract StatusContribution {
21   uint256 public maxGasPrice;
22   uint256 public startBlock;
23   uint256 public totalNormalCollected;
24   uint256 public finalizedBlock;
25   function proxyPayment(address _th) payable returns (bool);
26 }
27 
28 // Interface to Status Cap Determination Contract
29 contract DynamicCeiling {
30   function curves(uint currentIndex) returns (bytes32 hash, 
31                                               uint256 limit, 
32                                               uint256 slopeFactor, 
33                                               uint256 collectMinimum);
34   uint256 public currentIndex;
35   uint256 public revealedCurves;
36 }
37 
38 contract StatusBuyer {
39   // Store the amount of ETH deposited by each account.
40   mapping (address => uint256) public deposits;
41   // Track how much SNT each account would have been able to purchase on their own.
42   mapping (address => uint256) public simulated_snt;
43   // Bounty for executing buy.
44   uint256 public bounty;
45   // Track whether the contract has bought tokens yet.
46   bool public bought_tokens;
47   
48   // The Status Token Sale address.
49   StatusContribution public sale = StatusContribution(0x55d34b686aa8C04921397c5807DB9ECEdba00a4c);
50   // The Status DynamicCeiling Contract address.
51   DynamicCeiling public dynamic = DynamicCeiling(0xc636e73Ff29fAEbCABA9E0C3f6833EaD179FFd5c);
52   // Status Network Token (SNT) Contract address.
53   ERC20 public token = ERC20(0x744d70FDBE2Ba4CF95131626614a1763DF805B9E);
54   // The developer address.
55   address developer = 0x4e6A1c57CdBfd97e8efe831f8f4418b1F2A09e6e;
56   
57   // Withdraws all ETH/SNT owned by the user in the ratio currently owned by the contract.
58   function withdraw() {
59     // Store the user's deposit prior to withdrawal in a temporary variable.
60     uint256 user_deposit = deposits[msg.sender];
61     // Update the user's deposit prior to sending ETH to prevent recursive call.
62     deposits[msg.sender] = 0;
63     // Retrieve current ETH balance of contract (less the bounty).
64     uint256 contract_eth_balance = this.balance - bounty;
65     // Retrieve current SNT balance of contract.
66     uint256 contract_snt_balance = token.balanceOf(address(this));
67     // Calculate total SNT value of ETH and SNT owned by the contract.
68     // 1 ETH Wei -> 10000 SNT Wei
69     uint256 contract_value = (contract_eth_balance * 10000) + contract_snt_balance;
70     // Calculate amount of ETH to withdraw.
71     uint256 eth_amount = (user_deposit * contract_eth_balance * 10000) / contract_value;
72     // Calculate amount of SNT to withdraw.
73     uint256 snt_amount = 10000 * ((user_deposit * contract_snt_balance) / contract_value);
74     // No fee for withdrawing if user would have made it into the crowdsale alone.
75     uint256 fee = 0;
76     // 1% fee on portion of tokens user would not have been able to buy alone.
77     if (simulated_snt[msg.sender] < snt_amount) {
78       fee = (snt_amount - simulated_snt[msg.sender]) / 100;
79     }
80     // Send the funds.  Throws on failure to prevent loss of funds.
81     if(!token.transfer(msg.sender, snt_amount - fee)) throw;
82     if(!token.transfer(developer, fee)) throw;
83     msg.sender.transfer(eth_amount);
84   }
85   
86   // Allow anyone to contribute to the buy execution bounty.
87   function add_to_bounty() payable {
88     // Disallow adding to the bounty if contract has already bought the tokens.
89     if (bought_tokens) throw;
90     // Update bounty to include received amount.
91     bounty += msg.value;
92   }
93   
94   // Allow users to simulate entering the crowdsale to avoid the fee.  Callable by anyone.
95   function simulate_ico() {
96     // Limit maximum gas price to the same value as the Status ICO (50 GWei).
97     if (tx.gasprice > sale.maxGasPrice()) throw;
98     // Restrict until after the ICO has started.
99     if (block.number < sale.startBlock()) throw;
100     if (dynamic.revealedCurves() == 0) throw;
101     // Extract the buy limit and rate-limiting slope factor of the current curve/cap.
102     uint256 limit;
103     uint256 slopeFactor;
104     (,limit,slopeFactor,) = dynamic.curves(dynamic.currentIndex());
105     // Retrieve amount of ETH the ICO has collected so far.
106     uint256 totalNormalCollected = sale.totalNormalCollected();
107     // Verify the ICO is not currently at a cap, waiting for a reveal.
108     if (limit <= totalNormalCollected) throw;
109     // Add the maximum contributable amount to the user's simulated SNT balance.
110     simulated_snt[msg.sender] += ((limit - totalNormalCollected) / slopeFactor);
111   }
112   
113   // Buys tokens in the crowdsale and rewards the sender.  Callable by anyone.
114   function buy() {
115     // Short circuit to save gas if the contract has already bought tokens.
116     if (bought_tokens) return;
117     // Record that the contract has bought tokens first to prevent recursive call.
118     bought_tokens = true;
119     // Transfer all the funds (less the bounty) to the Status ICO contract 
120     // to buy tokens.  Throws if the crowdsale hasn't started yet or has 
121     // already completed, preventing loss of funds.
122     sale.proxyPayment.value(this.balance - bounty)(address(this));
123     // Send the user their bounty for buying tokens for the contract.
124     msg.sender.transfer(bounty);
125   }
126   
127   // A helper function for the default function, allowing contracts to interact.
128   function default_helper() payable {
129     // Only allow deposits if the contract hasn't already purchased the tokens.
130     if (!bought_tokens) {
131       // Update records of deposited ETH to include the received amount.
132       deposits[msg.sender] += msg.value;
133       // Block each user from contributing more than 30 ETH.  No whales!  >:C
134       if (deposits[msg.sender] > 30 ether) throw;
135     }
136     else {
137       // Reject ETH sent after the contract has already purchased tokens.
138       if (msg.value != 0) throw;
139       // If the ICO isn't over yet, simulate entering the crowdsale.
140       if (sale.finalizedBlock() == 0) {
141         simulate_ico();
142       }
143       else {
144         // Withdraw user's funds if they sent 0 ETH to the contract after the ICO.
145         withdraw();
146       }
147     }
148   }
149   
150   // Default function.  Called when a user sends ETH to the contract.
151   function () payable {
152     // Avoid recursively buying tokens when the sale contract refunds ETH.
153     if (msg.sender == address(sale)) return;
154     // Delegate to the helper function.
155     default_helper();
156   }
157 }