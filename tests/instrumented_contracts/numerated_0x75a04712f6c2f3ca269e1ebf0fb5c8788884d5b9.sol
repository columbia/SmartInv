1 pragma solidity ^0.4.6;
2 
3 contract VIUREFoundersTokenSale {
4   mapping (address => uint) public balances;
5 
6   uint public transferred_total = 0;
7 
8   uint public constant min_goal_amount = 4000 ether;
9   uint public constant max_goal_amount = 7000 ether;
10 
11   address public project_wallet;
12 
13   uint public token_sale_start_block;
14   uint public token_sale_end_block;
15 
16   uint constant blocks_in_two_months = 351558;
17 
18   uint public refund_window_end_block;
19 
20   function VIUREFoundersTokenSale(uint _start_block, uint _end_block, address _project_wallet) {
21     if (_start_block <= block.number) throw;
22     if (_end_block <= _start_block) throw;
23     if (_project_wallet == 0) throw;
24     
25     token_sale_start_block = _start_block;
26     token_sale_end_block = _end_block;
27     project_wallet = _project_wallet;
28     refund_window_end_block = token_sale_end_block + blocks_in_two_months;
29   }
30 
31   function has_token_sale_started() private constant returns (bool) {
32     return block.number >= token_sale_start_block;
33   }
34 
35   function has_token_sale_time_ended() private constant returns (bool) {
36     return block.number > token_sale_end_block;
37   }
38 
39   function is_min_goal_reached() private constant returns (bool) {
40     return transferred_total >= min_goal_amount;
41   }
42 
43   function is_max_goal_reached() private constant returns (bool) {
44     return transferred_total >= max_goal_amount;
45   }
46 
47   function() payable {
48     if (!has_token_sale_started()) throw;
49 
50     if (has_token_sale_time_ended()) throw;
51 
52     if (msg.value == 0) throw;
53 
54     if (is_max_goal_reached()) throw;
55 
56     if (transferred_total + msg.value > max_goal_amount) {
57      
58       var change_to_return = transferred_total + msg.value - max_goal_amount;
59       if (!msg.sender.send(change_to_return)) throw;
60 
61       var to_add = max_goal_amount - transferred_total;
62       balances[msg.sender] += to_add;
63       transferred_total += to_add;
64 
65     } else {
66       balances[msg.sender] += msg.value;
67       transferred_total += msg.value;
68     }
69   }
70 
71   function transfer_funds_to_project() {
72     if (!is_min_goal_reached()) throw;
73     
74     if (this.balance == 0) throw;
75 
76     if (!project_wallet.send(this.balance)) throw;
77   }
78 
79   function refund() {
80     if (!has_token_sale_time_ended()) throw;
81 
82     if (is_min_goal_reached()) throw;
83   
84     if (block.number > refund_window_end_block) throw;
85 
86     var refund_amount = balances[msg.sender];
87 
88     if (refund_amount == 0) throw;
89 
90     balances[msg.sender] = 0;
91 
92     if (!msg.sender.send(refund_amount)) {
93     if (!msg.sender.send(refund_amount)) throw;
94     }
95   }
96 
97   function transfer_remaining_funds_to_project() {
98     if (!has_token_sale_time_ended()) throw;
99     if (is_min_goal_reached()) throw;
100     if (block.number <= refund_window_end_block) throw;
101 
102     if (this.balance == 0) throw;
103     if (!project_wallet.send(this.balance)) throw;
104   }
105 }