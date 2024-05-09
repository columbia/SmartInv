1 pragma solidity ^0.4.6;
2 
3 contract Presale {
4     mapping (address => uint) public balances;
5     uint public transfered_total = 0;
6     
7     uint public constant min_goal_amount = 5 ether;
8     uint public constant max_goal_amount = 10 ether;
9     
10     // Vega Fund Round A Address
11     address public project_wallet;
12 
13     uint public presale_start_block;
14     uint public presale_end_block;
15     
16     // est. of blocks count in 1 month
17     // Based on 1 block every 17 seconds, 30 days would produce ~152,471
18     // Just for allowing for some additional time round to 153,000
19     uint constant blocks_in_one_months = 100;
20     
21     // block number of the end of refund window, 
22     // which will occur in the end of 1 month after presale
23     uint public refund_window_end_block;
24     
25     function Presale(uint _start_block, uint _end_block, address _project_wallet) {
26         if (_start_block <= block.number) throw;
27         if (_end_block <= _start_block) throw;
28         if (_project_wallet == 0) throw;
29         
30         presale_start_block = _start_block;
31         presale_end_block = _end_block;
32         project_wallet = _project_wallet;
33 	refund_window_end_block = presale_end_block + blocks_in_one_months;
34     }
35 	
36     function has_presale_started() private constant returns (bool) {
37 	return block.number >= presale_start_block;
38     }
39     
40     function has_presale_time_ended() private constant returns (bool) {
41         return block.number > presale_end_block;
42     }
43     
44     function is_min_goal_reached() private constant returns (bool) {
45         return transfered_total >= min_goal_amount;
46     }
47     
48     function is_max_goal_reached() private constant returns (bool) {
49         return transfered_total >= max_goal_amount;
50     }
51     
52     // Accept ETH while presale is active or until maximum goal is reached.
53     function () payable {
54 	// check if presale has started
55         if (!has_presale_started()) throw;
56 	    
57 	// check if presale date is not over
58 	if (has_presale_time_ended()) throw;
59 	    
60 	// don`t accept transactions with zero value
61 	if (msg.value == 0) throw;
62 
63         // check if max goal is not reached
64 	if (is_max_goal_reached()) throw;
65         
66         if (transfered_total + msg.value > max_goal_amount) {
67             // return change
68 	    var change_to_return = transfered_total + msg.value - max_goal_amount;
69 	    if (!msg.sender.send(change_to_return)) throw;
70             
71             var to_add = max_goal_amount - transfered_total;
72             balances[msg.sender] += to_add;
73 	    transfered_total += to_add;
74         } else {
75             // set data
76 	    balances[msg.sender] += msg.value;
77 	    transfered_total += msg.value;
78         }
79     }
80     
81     // Transfer ETH to Vega Round A address, as soon as minimum goal is reached.
82     function transfer_funds_to_project() {
83         if (!is_min_goal_reached()) throw;
84         if (this.balance == 0) throw;
85         
86         // transfer ethers to Vega Round A address
87         if (!project_wallet.send(this.balance)) throw;
88     }
89     
90     // Refund ETH in case minimum goal was not reached during presale.
91     // Refund will be available for one month window after presale.
92     function refund() {
93         if (!has_presale_time_ended()) throw;
94         if (is_min_goal_reached()) throw;
95         if (block.number > refund_window_end_block) throw;
96         
97         var amount = balances[msg.sender];
98         // check if sender has balance
99         if (amount == 0) throw;
100         
101         // reset balance
102         balances[msg.sender] = 0;
103         
104         // actual refund
105         if (!msg.sender.send(amount)) throw;
106     }
107     
108     // In case any ETH has left unclaimed after one month window, send them to Vega Round A address.
109     function transfer_left_funds_to_project() {
110         if (!has_presale_time_ended()) throw;
111         if (is_min_goal_reached()) throw;
112         if (block.number <= refund_window_end_block) throw;
113         
114         if (this.balance == 0) throw;
115         // transfer left ETH to Vega Round A address
116         if (!project_wallet.send(this.balance)) throw;
117     }
118 }