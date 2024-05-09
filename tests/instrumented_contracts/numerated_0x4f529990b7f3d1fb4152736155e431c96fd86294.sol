1 // Mysterium Network Presale Smart Contract
2 
3 pragma solidity ^0.4.6;
4 
5 contract Presale {
6     mapping (address => uint) public balances;
7     uint public transfered_total = 0;
8     
9     uint public constant min_goal_amount = 2000 ether;
10     uint public constant max_goal_amount = 6000 ether;
11     
12     // Mysterium project wallet
13     address public project_wallet;
14 
15     uint public presale_start_block;
16     uint public presale_end_block;
17     
18     // approximate blocks count in 2 months 
19     uint constant blocks_in_two_months = 351558;
20     
21     // block number of the end of refund window, 
22     // which will occur in the end of 2 months after presale
23     uint public refund_window_end_block;
24     
25     function Presale(/*uint _start_block, uint _end_block, address _project_wallet*/) {
26         
27         uint _start_block = 2818600;
28         uint _end_block = 3191000;
29         address _project_wallet = 0x002515a2fd5C9DDa1d4109aE8BBF9f73A707B72f;
30         
31         if (_start_block <= block.number) throw;
32         if (_end_block <= _start_block) throw;
33         if (_project_wallet == 0) throw;
34         
35         presale_start_block = _start_block;
36         presale_end_block = _end_block;
37         project_wallet = _project_wallet;
38 		refund_window_end_block = presale_end_block + blocks_in_two_months;
39 	}
40 	
41 	function has_presale_started() private constant returns (bool) {
42 	    return block.number >= presale_start_block;
43 	}
44     
45     function has_presale_time_ended() private constant returns (bool) {
46         return block.number > presale_end_block;
47     }
48     
49     function is_min_goal_reached() private constant returns (bool) {
50         return transfered_total >= min_goal_amount;
51     }
52     
53     function is_max_goal_reached() private constant returns (bool) {
54         return transfered_total >= max_goal_amount;
55     }
56     
57     // Accept ETH while presale is active or until maximum goal is reached.
58 	function () payable {
59 	    // check if presale has started
60         if (!has_presale_started()) throw;
61 	    
62 	    // check if presale date is not over
63 	    if (has_presale_time_ended()) throw;
64 	    
65 	    // don`t accept transactions with zero value
66 	    if (msg.value == 0) throw;
67 
68         // check if max goal is not reached
69 	    if (is_max_goal_reached()) throw;
70         
71         if (transfered_total + msg.value > max_goal_amount) {
72             // return change
73 	        var change_to_return = transfered_total + msg.value - max_goal_amount;
74 	        if (!msg.sender.send(change_to_return)) throw;
75             
76             var to_add = max_goal_amount - transfered_total;
77             balances[msg.sender] += to_add;
78 	        transfered_total += to_add;
79         } else {
80             // set data
81 	        balances[msg.sender] += msg.value;
82 	        transfered_total += msg.value;
83         }
84     }
85     
86     // Transfer ETH to Mysterium project wallet, as soon as minimum goal is reached.
87     function transfer_funds_to_project() {
88         if (!is_min_goal_reached()) throw;
89         if (this.balance == 0) throw;
90         
91         // transfer ethers to Mysterium project wallet
92         if (!project_wallet.send(this.balance)) throw;
93     }
94     
95     // Refund ETH in case minimum goal was not reached during presale.
96     // Refund will be available for two months window after presale.
97     function refund() {
98         if (!has_presale_time_ended()) throw;
99         if (is_min_goal_reached()) throw;
100         if (block.number > refund_window_end_block) throw;
101         
102         var amount = balances[msg.sender];
103         // check if sender has balance
104         if (amount == 0) throw;
105         
106         // reset balance
107         balances[msg.sender] = 0;
108         
109         // actual refund
110         if (!msg.sender.send(amount)) throw;
111     }
112     
113     // In case any ETH has left unclaimed after two months window, send them to Mysterium project wallet.
114     function transfer_left_funds_to_project() {
115         if (!has_presale_time_ended()) throw;
116         if (is_min_goal_reached()) throw;
117         if (block.number <= refund_window_end_block) throw;
118         
119         if (this.balance == 0) throw;
120         // transfer left ETH to Mysterium project wallet
121         if (!project_wallet.send(this.balance)) throw;
122     }
123 }