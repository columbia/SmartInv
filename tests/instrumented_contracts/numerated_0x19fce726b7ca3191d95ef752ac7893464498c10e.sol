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
25         require(total_invest_amount[msg.sender] > 0);
26         _;
27     }
28 
29     modifier checkTime() {
30         require(now >= last_withdraw_time[msg.sender].add(stepTime));
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
51         else{
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
101             uint current_payout_amount = (invest_amount[msg.sender][i].mul(time_spent).mul(percent).div(100)).div(24);
102             _payout_amount = _payout_amount.add(current_payout_amount);
103         }
104         return _payout_amount;
105     }
106 
107     function CalculateHoldPayoutAmount() internal view returns (uint){
108         uint hold_payout_amount = 0;
109         uint time_spent = 0;
110         for (uint16 i = 0; i < invest_count[msg.sender]; i++) {
111             if (last_withdraw_time[msg.sender] > invest_time[msg.sender][i]) 
112                 time_spent = (now.sub(last_withdraw_time[msg.sender])).div(stepTime.mul(24));
113             else 
114                 time_spent = (now.sub(invest_time[msg.sender][i])).div(stepTime.mul(24));
115 
116             if (time_spent > 30) time_spent = 30;
117             
118             if (time_spent > 0) {
119                 uint hold_percent = 117**time_spent;
120                 uint devider = 100**time_spent;
121                 uint current_payout_amount = invest_amount[msg.sender][i].mul(hold_percent).div(devider).div(100);
122                 hold_payout_amount = hold_payout_amount.add(current_payout_amount);
123             }
124         }
125         return hold_payout_amount;
126     }
127 
128     function DayliPercentRate() internal view returns(uint) {
129         uint contractBalance = address(this).balance;
130         if (contractBalance >= 0 ether && contractBalance < 100 ether) {
131             return (3);
132         }
133         if (contractBalance >= 100 ether && contractBalance < 200 ether) {
134             return (4);
135         }
136         if (contractBalance >= 200 ether && contractBalance < 500 ether) {
137             return (5);
138         }
139         if (contractBalance >= 500 ether && contractBalance < 1000 ether) {
140             return (6);
141         }
142         if (contractBalance >= 1000 ether) {
143             return (7); 
144         }
145     }
146 
147     function() external payable {
148         deposit();
149     }
150 }
151 
152 /**
153  * @title SafeMath
154  * @dev Math operations with safety checks that throw on error
155  */
156 library SafeMath {
157     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
158         if (a == 0) {
159             return 0;
160         }
161         uint256 c = a * b;
162         assert(c / a == b);
163         return c;
164     }
165 
166     function div(uint256 a, uint256 b) internal pure returns (uint256) {
167         // assert(b > 0); // Solidity automatically throws when dividing by 0
168         uint256 c = a / b;
169         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
170         return c;
171     }
172 
173     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
174         assert(b <= a);
175         return a - b;
176     }
177 
178     function add(uint256 a, uint256 b) internal pure returns (uint256) {
179         uint256 c = a + b;
180         assert(c >= a);
181         return c;
182     }
183 }