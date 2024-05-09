1 // VIURE Founders Token Sale Smart Contract for VR Arcades
2 
3 pragma solidity ^0.4.6;
4 
5 contract VIUREFoundersTokenSale {
6   // Maps addresses to balances in ETH
7   mapping (address => uint) public balances;
8 
9   uint public transferred_total = 0;
10 
11   // Minimum and Maximum Goals for Token Sale
12   uint public constant min_goal_amount = 4000 ether;
13   uint public constant max_goal_amount = 6000 ether;
14 
15   // loftVR Offline Project Wallet
16   address public project_wallet;
17 
18   // Token Sale Schedule
19   uint public token_sale_start_block;
20   uint public token_sale_end_block;
21 
22   // Approximate blocks created in 2 months - 351,558 blocks
23   uint constant blocks_in_two_months = 360000;
24 
25   // Block number at the end of the refund window
26   uint public refund_window_end_block;
27 
28   function VIUREFoundersTokenSale(uint _start_block, uint _end_block, address _project_wallet) {
29     if (_start_block <= block.number) throw;
30     if (_end_block <= _start_block) throw;
31     if (_project_wallet == 0) throw;
32 
33     // Initializing parameters for Token Sale
34     token_sale_start_block = _start_block;
35     token_sale_end_block = _end_block;
36     project_wallet = _project_wallet;
37     refund_window_end_block = token_sale_end_block + blocks_in_two_months;
38   }
39 
40   // Checks if the Token Sale has started
41   function has_token_sale_started() private constant returns (bool) {
42     return block.number >= token_sale_start_block;
43   }
44 
45   // Checks if the Token Sale has ended
46   function has_token_sale_time_ended() private constant returns (bool) {
47     return block.number > token_sale_end_block;
48   }
49 
50   // Checks if the minimum goal was reached
51   function is_min_goal_reached() private constant returns (bool) {
52     return transferred_total >= min_goal_amount;
53   }
54 
55   // Checks if the maximum goal was reached
56   function is_max_goal_reached() private constant returns (bool) {
57     return transferred_total >= max_goal_amount;
58   }
59 
60   // Accepts ETH while Token Sale is active or until the maximum goal is reached
61   function() payable {
62     // Check if Token Sale has started
63     if (!has_token_sale_started()) throw;
64 
65     // Check if Token Sale is over
66     if (has_token_sale_time_ended()) throw;
67 
68     // Don't accept transactions with zero value
69     if (msg.value == 0) throw;
70 
71     // Check if the maximum goal was reached
72     if (is_max_goal_reached()) throw;
73 
74     // Check if senders transaction ends up going over the maximum goal amount
75     if (transferred_total + msg.value > max_goal_amount) {
76       // Return as change the amount that goes over the maximum goal amount
77       var change_to_return = transferred_total + msg.value - max_goal_amount;
78       if (!msg.sender.send(change_to_return)) throw;
79 
80       // Records what the sender was able to send to reach the maximum goal amount
81       // Adds this value to the senders balance and to transferred_total to finish the Token Sale
82       var to_add = max_goal_amount - transferred_total;
83       balances[msg.sender] += to_add;
84       transferred_total += to_add;
85 
86     } else {
87       // Records the value of the senders transaction with the Token Sale Smart Contract
88       // Records the amount the sender sent to the Token Sale Smart Contract
89       balances[msg.sender] += msg.value;
90       transferred_total += msg.value;
91     }
92   }
93 
94   // Transfer ETH to loftVR Offline Project wallet
95   function transfer_funds_to_project() {
96     // Check if the minimum goal amount was reached
97     if (!is_min_goal_reached()) throw;
98     // Check if the funds have already been transferred to the project wallet
99     if (this.balance == 0) throw;
100 
101     // Transfer ETH to loftVR Offline Project wallet
102     if (!project_wallet.send(this.balance)) throw;
103   }
104 
105   // Refund ETH in case the minimum goal was not reached during the Token Sale
106   // Refund will be available during a two month window after the Token Sale
107   function refund() {
108     // Check if the Token Sale has ended
109     if (!has_token_sale_time_ended()) throw;
110     // Check if the minimum goal amount was reached and throws if it has been reached
111     if (is_min_goal_reached()) throw;
112     // Check if the refund window has passed
113     if (block.number > refund_window_end_block) throw;
114 
115     // Records the balance of the sender
116     var refund_amount = balances[msg.sender];
117     // Check if the sender has a balance
118     if (refund_amount == 0) throw;
119 
120     // Reset balance
121     balances[msg.sender] = 0;
122 
123     // Actual refund
124     if (!msg.sender.send(refund_amount)) {
125          if (!msg.sender.send(refund_amount)) throw;
126     }
127   }
128 
129   // In the case that there is any ETH left unclaimed after the two month refund window,
130   // Send the ETH to the loftVR Offline Project Wallet
131   function transfer_remaining_funds_to_project() {
132     if (!has_token_sale_time_ended()) throw;
133     if (is_min_goal_reached()) throw;
134     if (block.number <= refund_window_end_block) throw;
135 
136     if (this.balance == 0) throw;
137     // Transfer remaining ETH to loftVR Offline Project Wallet
138     if (!project_wallet.send(this.balance)) throw;
139   }
140 }