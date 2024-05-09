1 pragma solidity 0.4.25;
2 
3 contract Game11A {
4     using SafeMath for uint;
5     uint public betFirstMin = 11 ether / 100;
6     uint public betFirstMax = 2 ether / 10;
7     uint public bet = betFirstMin;
8     uint public currentMinBet = betFirstMin;
9     uint public percentRaise = 11;
10     address private admin = 0xAF53747Ce9cd5132c52Ab9e9D11259875935C55A;
11     address public player = admin;
12     uint public compensation;
13     bool public first = true;
14     uint public time = 0;
15     uint public waitTime = 24 hours;
16 
17     event Withdrawal(address player, uint time, uint value, uint bet);
18     event Bet(address player, uint time, uint bet);
19     event newCircle(address player, uint time, uint compensation);
20 
21     function firstBet() private {
22         require(msg.value >= betFirstMin && msg.value <= betFirstMax, 'Wrong ETH value');
23 
24         compensation = compensation.add(msg.value);
25 
26         player = msg.sender;
27         time = now;
28         bet = msg.value;
29         currentMinBet = bet.mul(percentRaise).div(100).add(bet);
30 
31         first = false;
32 
33         emit Bet(player, time, bet);
34     }
35 
36     function usualBet() private {
37         require(msg.value >= currentMinBet, 'Wrong ETH value');
38 
39         uint profit = msg.value.sub(bet);
40 
41         player.transfer(profit.mul(10).div(11).add(bet));
42         emit Withdrawal(player, now, profit.mul(10).div(11).add(bet), bet);
43         admin.transfer(profit.mul(1).div(11));
44 
45         player = msg.sender;
46         time = now;
47         bet = msg.value;
48         currentMinBet = bet.mul(percentRaise).div(100).add(bet);
49 
50         emit Bet(player, time, bet);
51     }
52 
53     function lastBet() private {
54         emit newCircle(player, time, bet);
55 
56         if (msg.value >= betFirstMin && msg.value <= betFirstMax) {
57             player.transfer(address(this).balance.sub(msg.value));
58             emit Withdrawal(player, now, address(this).balance.sub(msg.value), bet);
59 
60             compensation = 0;
61 
62             firstBet();
63         } else {
64             msg.sender.transfer(msg.value);
65             player.transfer(address(this).balance);
66             emit Withdrawal(player, now, address(this).balance, bet);
67 
68             compensation = 0;
69             player = admin;
70             bet = betFirstMin;
71             currentMinBet = bet;
72             time = 0;
73             first = true;
74         }
75 
76     }
77 
78     function() external payable {
79         if (first == true) {
80             firstBet();
81         } else {
82             now >= time + waitTime ? lastBet() : usualBet();
83         }
84     }
85 }
86 
87 /**
88  * @title SafeMath
89  * @dev Math operations with safety checks that throw on error
90  */
91 library SafeMath {
92     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
93         if (a == 0) {
94             return 0;
95         }
96         uint256 c = a * b;
97         assert(c / a == b);
98         return c;
99     }
100 
101     function div(uint256 a, uint256 b) internal pure returns (uint256) {
102         require(b > 0);
103         uint256 c = a / b;
104         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
105         return c;
106     }
107 
108     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
109         assert(b <= a);
110         return a - b;
111     }
112 
113     function add(uint256 a, uint256 b) internal pure returns (uint256) {
114         uint256 c = a + b;
115         assert(c >= a);
116         return c;
117     }
118 }