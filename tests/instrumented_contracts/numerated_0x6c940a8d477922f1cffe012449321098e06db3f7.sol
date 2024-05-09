1 pragma solidity ^0.4.16;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal returns (uint256) {
9     uint256 c = a * b;
10     require(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function sub(uint256 a, uint256 b) internal returns (uint256) {
15     require(b <= a);
16     return a - b;
17   }
18 
19   function add(uint256 a, uint256 b) internal returns (uint256) {
20     uint256 c = a + b;
21     require(c >= a);
22     return c;
23   }
24 }
25 
26 
27 contract CryptoGain {
28     using SafeMath for uint256;
29     
30     struct Bid {
31         address player;
32         uint8 slot_from;
33         uint8 slot_to;
34     }
35 
36     Bid[] public bids;
37     mapping (address => uint256) balances;
38 
39     address public admin;
40     bool public is_alive = true;
41     uint8 constant max_slots = 100;
42     uint256 constant price_ticket = 10 finney;
43     uint256 constant win_reward = 40 finney;
44     uint256 constant house_edge = 2 finney;
45     uint8 constant winners_count = 20; //ripemd160 length
46     uint8 public last_slot = 0;
47     uint public start_ts = 0;
48     uint constant week_seconds = 60*60*24*7;
49     
50     modifier onlyOwner() {
51         require(msg.sender == admin);
52         _;
53     }
54     
55     modifier onlyAlive() {
56         require(is_alive);
57         _;
58     }
59 
60     function CryptoGain() {
61         admin = msg.sender;
62     }
63 
64     function set_admin(address newAdmin) public onlyOwner {
65         admin = newAdmin;
66     }
67     
68     // Fully destruct contract. Use ONLY if you want to fully close lottery.
69     // This action can't be revert. Use carefully if you know what you do!
70     function destruct() public onlyOwner {
71         admin.transfer(this.balance);
72         is_alive = false; // <- this action is fully destroy contract
73     }
74     
75     function reset() public onlyOwner {
76         require(block.timestamp > start_ts + week_seconds); //only after week of inactivity
77         admin.transfer(price_ticket.mul(last_slot));
78         restart();
79 
80     }
81     
82     function restart() internal {
83         start_ts = block.timestamp;
84         last_slot = 0;
85         delete bids;
86     }
87     
88     function bid(address player, uint8 bid_slots_count) internal {
89         uint8 new_last_slot = last_slot + bid_slots_count;
90         bids.push(Bid(player, last_slot, new_last_slot));
91         remove_exceed(house_edge.mul(bid_slots_count));
92         last_slot = new_last_slot;
93     }
94     
95     function is_slot_in_bid(uint8 slot_from, uint8 slot_to, uint8 slot) returns (bool) {
96         return (slot >= slot_from && slot < slot_to) ? true : false;
97     }
98     
99     function search_winner_bid_address(uint8 slot) returns (address) {
100         uint8 i;
101         
102         if (slot < 128) {
103             for (i=0; i<bids.length; i++) {
104                 if (is_slot_in_bid(bids[i].slot_from, bids[i].slot_to, slot)) {
105                     return bids[i].player;
106                 }
107             }
108             
109         } else {
110             for (i=uint8(bids.length)-1; i>=0; i--) {
111                 if (is_slot_in_bid(bids[i].slot_from, bids[i].slot_to, slot)) {
112                     return bids[i].player;
113                 }
114             }
115         }
116         
117         assert (false);
118 
119     }
120     
121     function playout() internal {
122         
123         bytes20 hash = ripemd160(block.timestamp, block.number, msg.sender);
124         
125         uint8 current_winner_slot = 0;
126         for (uint8 i=0; i<winners_count; i++) {
127             current_winner_slot = ( current_winner_slot + uint8(hash[i]) ) % max_slots;
128             address current_winner_address = search_winner_bid_address(current_winner_slot);
129             balances[current_winner_address] = balances[current_winner_address].add(win_reward);
130         }
131         restart();
132     
133     }
134     
135     function remove_exceed(uint256 amount) internal {
136         balances[admin] = balances[admin].add(amount);
137     }
138     
139     function get_balance() public returns (uint256) {
140         return balances[msg.sender];
141     }
142     
143     function get_foreign_balance(address _address) public returns (uint256) {
144         return balances[_address];
145     }
146   
147     function withdraw() public onlyAlive {
148         require(balances[msg.sender] > 0);
149         var amount = balances[msg.sender];
150         balances[msg.sender] = 0;
151         msg.sender.transfer(amount);
152     }
153     
154     function run(address player, uint256 deposit_eth) internal onlyAlive {
155         require(deposit_eth >= price_ticket);
156         uint256 exceed_mod_eth = deposit_eth % price_ticket;
157         
158         if (exceed_mod_eth > 0) {
159             remove_exceed(exceed_mod_eth);
160             deposit_eth = deposit_eth.sub(exceed_mod_eth);
161         }
162         
163         uint8 deposit_bids = uint8(deposit_eth / price_ticket);
164         
165         //how much slots is avaliable for bid
166         uint8 avaliable_session_slots = max_slots - last_slot;
167         
168 
169         if (deposit_bids < avaliable_session_slots) {
170             bid(player, deposit_bids);
171         } else {
172             uint8 max_avaliable_slots = (avaliable_session_slots + max_slots - 1);
173             if (deposit_bids > max_avaliable_slots) { //overflow
174                 uint256 max_bid_eth = price_ticket.mul(max_avaliable_slots);
175                 uint256 exceed_over_eth = deposit_eth.sub(max_bid_eth);
176                 remove_exceed(exceed_over_eth);
177                 deposit_bids = max_avaliable_slots;
178             }
179             uint8 second_session_bids_count = deposit_bids - avaliable_session_slots;
180             
181             bid(player, avaliable_session_slots);
182             playout();
183             if (second_session_bids_count > 0) {
184                 bid(player, second_session_bids_count);
185             }
186         }
187     }
188     
189     function() payable public {
190         run(msg.sender, msg.value);
191         
192     }
193 
194 }