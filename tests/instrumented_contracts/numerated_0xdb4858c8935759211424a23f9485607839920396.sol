1 pragma solidity ^0.4.25;
2 
3 /*
4 
5 website : https://ither.pro
6 
7 ither pro is a unique project for Investing Ethereum cryptocurrency and getting daily profit from 6% to 9%
8 
9 
10 * ---How to use:
11 *  1. Send from ETH wallet to the smart contract address
12 *     any amount ETH.
13 *  2. Claim your profit by sending 0 ether transaction (1 time per hour)
14 *  3. If you earn more than 200%, you can withdraw only one finish time
15 */
16 contract ither {
17 
18     using SafeMath for uint;
19     mapping(address => uint) public balance;
20     mapping(address => uint) public time;
21     mapping(address => uint) public percentWithdraw;
22     mapping(address => uint) public allPercentWithdraw;
23     uint public stepTime = 1 hours;
24     uint public countOfInvestors = 0;
25     address public ownerAddress = 0x359Cba0132efd70d82FD1bB2aae1D7e8764A79bb;
26     uint projectPercent = 10;
27 
28     event Invest(address investor, uint256 amount);
29     event Withdraw(address investor, uint256 amount);
30 
31     modifier userExist() {
32         require(balance[msg.sender] > 0, "Address not found");
33         _;
34     }
35 
36     modifier checkTime() {
37         require(now >= time[msg.sender].add(stepTime), "Too fast payout request");
38         _;
39     }
40 
41     function collectPercent() userExist checkTime internal {
42         if ((balance[msg.sender].mul(2)) <= allPercentWithdraw[msg.sender]) {
43             balance[msg.sender] = 0;
44             time[msg.sender] = 0;
45             percentWithdraw[msg.sender] = 0;
46         } else {
47             uint payout = payoutAmount();
48             percentWithdraw[msg.sender] = percentWithdraw[msg.sender].add(payout);
49             allPercentWithdraw[msg.sender] = allPercentWithdraw[msg.sender].add(payout);
50             msg.sender.transfer(payout);
51             emit Withdraw(msg.sender, payout);
52         }
53     }
54 
55     function percentRate() public view returns(uint) {
56         uint contractBalance = address(this).balance;
57 
58         if (contractBalance < 1000 ether) {
59             return (60);
60         }
61         if (contractBalance >= 1000 ether && contractBalance < 2500 ether) {
62             return (72);
63         }
64         if (contractBalance >= 2500 ether && contractBalance < 5000 ether) {
65             return (84);
66         }
67         if (contractBalance >= 5000 ether) {
68             return (90);
69         }
70     }
71 
72     function payoutAmount() public view returns(uint256) {
73         uint256 percent = percentRate();
74         uint256 different = now.sub(time[msg.sender]).div(stepTime);
75         uint256 rate = balance[msg.sender].mul(percent).div(1000);
76         uint256 withdrawalAmount = rate.mul(different).div(24).sub(percentWithdraw[msg.sender]);
77 
78         return withdrawalAmount;
79     }
80 
81     function deposit() private {
82         if (msg.value > 0) {
83             if (balance[msg.sender] == 0) {
84                 countOfInvestors += 1;
85             }
86             if (balance[msg.sender] > 0 && now > time[msg.sender].add(stepTime)) {
87                 collectPercent();
88                 percentWithdraw[msg.sender] = 0;
89             }
90             balance[msg.sender] = balance[msg.sender].add(msg.value);
91             time[msg.sender] = now;
92 
93             ownerAddress.transfer(msg.value.mul(projectPercent).div(100));
94             emit Invest(msg.sender, msg.value);
95         } else {
96             collectPercent();
97         }
98     }
99 
100     function() external payable {
101         deposit();
102     }
103 }
104 
105 /**
106  * @title SafeMath
107  * @dev Math operations with safety checks that throw on error
108  */
109 library SafeMath {
110     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
111         if (a == 0) {
112             return 0;
113         }
114         uint256 c = a * b;
115         assert(c / a == b);
116         return c;
117     }
118 
119     function div(uint256 a, uint256 b) internal pure returns (uint256) {
120         // assert(b > 0); // Solidity automatically throws when dividing by 0
121         uint256 c = a / b;
122         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
123         return c;
124     }
125 
126     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
127         assert(b <= a);
128         return a - b;
129     }
130 
131     function add(uint256 a, uint256 b) internal pure returns (uint256) {
132         uint256 c = a + b;
133         assert(c >= a);
134         return c;
135     }
136 }