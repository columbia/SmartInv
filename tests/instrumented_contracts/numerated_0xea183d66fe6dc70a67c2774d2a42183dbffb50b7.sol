1 pragma solidity ^0.4.18;
2 
3 contract HOLDx3 {
4     using SafeMath for uint;
5     
6     mapping(address => uint[64]) public invest_amount;
7     mapping(address => uint[64]) public invest_time;
8     mapping(address => uint) public invest_count;
9 
10     mapping(address => uint[64]) public withdraw_amount;
11     mapping(address => uint[64]) public withdraw_time;
12     mapping(address => uint) public withdraw_count;
13 
14     mapping(address => uint) total_invest_amount;
15     mapping(address => uint) total_paid_amount;
16     mapping(address => uint) public last_withdraw_time;
17 
18     uint public investors = 0;
19 
20     uint stepTime = 1 hours;
21     address dev_addr = 0x703826fc8D2a5506EAAe7808ab3B090521B04eDc;
22     uint dev_fee= 10;
23 
24     modifier userExist() {
25         require(total_invest_amount[msg.sender] > 0, "Address not found");
26         _;
27     }
28 
29     modifier checkTime() {
30         require(now >= last_withdraw_time[msg.sender].add(stepTime), "Too fast payout request");
31         _;
32     }
33 
34     function deposit() private {
35         // invest
36         if (msg.value > 0) {
37             if (last_withdraw_time[msg.sender] == 0) last_withdraw_time[msg.sender] = now;
38             if (total_invest_amount[msg.sender] == 0) {
39                 invest_count[msg.sender] = 0;
40                 withdraw_count[msg.sender] = 0;
41                 total_paid_amount[msg.sender] = 0;
42                 investors++;
43             }
44             invest_amount[msg.sender][invest_count[msg.sender]] = msg.value;
45             invest_time[msg.sender][invest_count[msg.sender]] = now;
46             invest_count[msg.sender] = invest_count[msg.sender]+1;
47             total_invest_amount[msg.sender] = total_invest_amount[msg.sender].add(msg.value);
48             dev_addr.transfer(msg.value.mul(dev_fee).div(100));
49         }
50         // claim percents
51         else {
52             CalculateAllPayoutAmount();
53         }
54     }
55 
56     function CalculateAllPayoutAmount() checkTime userExist internal {
57         uint payout_amount = CalculatePayoutAmount();
58         uint hold_payout_amount = CalculateHoldPayoutAmount();
59         payout_amount = payout_amount.add(hold_payout_amount);
60         SendPercent(payout_amount); 
61     }
62 
63     function SendPercent(uint _payout_amount) internal {
64         // checking that contract balance have an ether to pay dividents
65         if (_payout_amount > address(this).balance) _payout_amount = address(this).balance;
66         if (address(this).balance >= _payout_amount && _payout_amount > 0) {
67             //checking that user claimed not more then x3 of his total investitions
68             if ((_payout_amount.add(total_paid_amount[msg.sender])) > total_invest_amount[msg.sender].mul(3)) {
69                 _payout_amount = total_invest_amount[msg.sender].mul(3).sub(total_paid_amount[msg.sender]);
70                 for (uint16 i = 0; i < invest_count[msg.sender]; i++) {
71                     invest_amount[msg.sender][i] = 0;
72                 }
73                 invest_count[msg.sender] = 0;
74                 total_invest_amount[msg.sender] = 0;
75                 total_paid_amount[msg.sender] = 0;
76                 last_withdraw_time[msg.sender] = 0;
77             }
78             else {
79                 total_paid_amount[msg.sender] = total_paid_amount[msg.sender].add(_payout_amount);
80                 last_withdraw_time[msg.sender] = now;
81             }
82             withdraw_amount[msg.sender][withdraw_count[msg.sender]] = _payout_amount;
83             withdraw_time[msg.sender][withdraw_count[msg.sender]] = now;
84             withdraw_count[msg.sender] = withdraw_count[msg.sender]+1;
85             msg.sender.transfer(_payout_amount);
86         }
87     }
88  
89     function CalculatePayoutAmount() internal view returns (uint){
90         uint percent = DayliPercentRate();
91         uint _payout_amount = 0;
92         uint time_spent = 0;
93         // calculating all dividents for the current day percent rate
94         for (uint16 i = 0; i < invest_count[msg.sender]; i++) {
95             if (last_withdraw_time[msg.sender] > invest_time[msg.sender][i]) {
96                 time_spent = (now.sub(last_withdraw_time[msg.sender])).div(stepTime);
97             }
98             else {
99                 time_spent = (now.sub(invest_time[msg.sender][i])).div(stepTime);
100             }
101             if (time_spent > 30) time_spent = 30;
102             uint current_payout_amount = invest_amount[msg.sender][i].mul(time_spent).mul(percent).div(100);
103             _payout_amount = _payout_amount.add(current_payout_amount);
104         }
105         return _payout_amount;
106     }
107 
108     function CalculateHoldPayoutAmount() internal view returns (uint){
109         uint hold_payout_amount = 0;
110         uint time_spent = 0;
111         for (uint16 i = 0; i < invest_count[msg.sender]; i++) {
112             if (last_withdraw_time[msg.sender] > invest_time[msg.sender][i]) 
113                 time_spent = (now.sub(last_withdraw_time[msg.sender])).div(stepTime.mul(24));
114             else 
115                 time_spent = (now.sub(invest_time[msg.sender][i])).div(stepTime.mul(24));
116 
117             if (time_spent > 30) time_spent = 30;
118             
119             if (time_spent > 0) {
120                 uint hold_percent = 117**time_spent;
121                 uint devider = 100**time_spent;
122                 uint current_payout_amount = invest_amount[msg.sender][i].mul(hold_percent).div(devider).div(100);
123                 hold_payout_amount = hold_payout_amount.add(current_payout_amount);
124             }
125         }
126         return hold_payout_amount;
127     }
128 
129     function DayliPercentRate() internal view returns(uint) {
130         uint contractBalance = address(this).balance;
131         if (contractBalance >= 0 ether && contractBalance < 100 ether) {
132             return (3);
133         }
134         if (contractBalance >= 100 ether && contractBalance < 200 ether) {
135             return (4);
136         }
137         if (contractBalance >= 200 ether && contractBalance < 500 ether) {
138             return (5);
139         }
140         if (contractBalance >= 500 ether && contractBalance < 1000 ether) {
141             return (6);
142         }
143         if (contractBalance >= 1000 ether) {
144             return (7); 
145         }
146     }
147 
148     function() external payable {
149         deposit();
150     }
151 }
152 
153 /**
154  * @title SafeMath
155  * @dev Math operations with safety checks that throw on error
156  */
157 library SafeMath {
158     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
159         if (a == 0) {
160             return 0;
161         }
162         uint256 c = a * b;
163         assert(c / a == b);
164         return c;
165     }
166 
167     function div(uint256 a, uint256 b) internal pure returns (uint256) {
168         // assert(b > 0); // Solidity automatically throws when dividing by 0
169         uint256 c = a / b;
170         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
171         return c;
172     }
173 
174     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
175         assert(b <= a);
176         return a - b;
177     }
178 
179     function add(uint256 a, uint256 b) internal pure returns (uint256) {
180         uint256 c = a + b;
181         assert(c >= a);
182         return c;
183     }
184 }