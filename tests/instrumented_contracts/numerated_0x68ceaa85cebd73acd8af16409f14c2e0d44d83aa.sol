1 pragma solidity 0.4.25;
2 
3 contract Game20A {
4     using SafeMath for uint;
5     uint public betFirstMin = 5 ether / 100;
6     uint public betFirstMax = 1 ether / 10;
7     uint public bet = betFirstMin;
8     uint public currentMinBet = betFirstMin;
9     uint public percentRaise = 20;
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
41         player.transfer(profit.mul(10).div(20).add(bet));
42         emit Withdrawal(player, now, profit.mul(10).div(20).add(bet), bet);
43         admin.transfer(profit.mul(1).div(20));
44         compensation = compensation.add(profit.mul(9).div(20));
45 
46         player = msg.sender;
47         time = now;
48         bet = msg.value;
49         currentMinBet = bet.mul(percentRaise).div(100).add(bet);
50 
51         emit Bet(player, time, bet);
52     }
53 
54     function lastBet() private {
55         emit newCircle(player, time, bet);
56 
57         if (msg.value >= betFirstMin && msg.value <= betFirstMax) {
58             player.transfer(address(this).balance.sub(msg.value));
59             emit Withdrawal(player, now, address(this).balance.sub(msg.value), bet);
60 
61             compensation = 0;
62 
63             firstBet();
64         } else {
65             msg.sender.transfer(msg.value);
66             player.transfer(address(this).balance);
67             emit Withdrawal(player, now, address(this).balance, bet);
68 
69             compensation = 0;
70             player = admin;
71             bet = betFirstMin;
72             currentMinBet = bet;
73             time = 0;
74             first = true;
75         }
76 
77     }
78 
79     function() external payable {
80         if (first == true) {
81             firstBet();
82         } else {
83             now >= time + waitTime ? lastBet() : usualBet();
84         }
85     }
86 }
87 
88 /**
89  * @title SafeMath
90  * @dev Math operations with safety checks that throw on error
91  */
92 library SafeMath {
93     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
94         if (a == 0) {
95             return 0;
96         }
97         uint256 c = a * b;
98         assert(c / a == b);
99         return c;
100     }
101 
102     function div(uint256 a, uint256 b) internal pure returns (uint256) {
103         require(b > 0);
104         uint256 c = a / b;
105         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
106         return c;
107     }
108 
109     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
110         assert(b <= a);
111         return a - b;
112     }
113 
114     function add(uint256 a, uint256 b) internal pure returns (uint256) {
115         uint256 c = a + b;
116         assert(c >= a);
117         return c;
118     }
119 }