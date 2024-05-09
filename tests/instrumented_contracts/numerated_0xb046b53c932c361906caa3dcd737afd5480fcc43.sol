1 pragma solidity ^0.4.24;
2 
3 /*
4 * ---How to use:
5 *  1. Send from ETH wallet to the smart contract address
6 *     any amount ETH.
7 *  2. Claim your profit by sending 0 ether transaction (1 time per hour)
8 *  3. If you earn more than 200%, you can withdraw only one finish time
9 */
10 contract x2invest {
11 
12     using SafeMath for uint;
13     mapping(address => uint) public balance;
14     mapping(address => uint) public time;
15     mapping(address => uint) public percentWithdraw;
16     mapping(address => uint) public allPercentWithdraw;
17     uint public stepTime = 1 hours;
18     uint public countOfInvestors = 0;
19     address public ownerAddress = 0x618f9d4E035dE96a9121d221163B6542Dc4d3bFC;
20     uint projectPercent = 10;
21 
22     event Invest(address investor, uint256 amount);
23     event Withdraw(address investor, uint256 amount);
24 
25     modifier userExist() {
26         require(balance[msg.sender] > 0, "Address not found");
27         _;
28     }
29 
30     modifier checkTime() {
31         require(now >= time[msg.sender].add(stepTime), "Too fast payout request");
32         _;
33     }
34 
35     function collectPercent() userExist checkTime internal {
36         if ((balance[msg.sender].mul(2)) <= allPercentWithdraw[msg.sender]) {
37             balance[msg.sender] = 0;
38             time[msg.sender] = 0;
39             percentWithdraw[msg.sender] = 0;
40         } else {
41             uint payout = payoutAmount();
42             percentWithdraw[msg.sender] = percentWithdraw[msg.sender].add(payout);
43             allPercentWithdraw[msg.sender] = allPercentWithdraw[msg.sender].add(payout);
44             msg.sender.transfer(payout);
45             emit Withdraw(msg.sender, payout);
46         }
47     }
48 
49     function percentRate() public view returns(uint) {
50         uint contractBalance = address(this).balance;
51 
52         if (contractBalance < 1000 ether) {
53             return (60);
54         }
55         if (contractBalance >= 1000 ether && contractBalance < 2500 ether) {
56             return (72);
57         }
58         if (contractBalance >= 2500 ether && contractBalance < 5000 ether) {
59             return (84);
60         }
61         if (contractBalance >= 5000 ether) {
62             return (90);
63         }
64     }
65 
66     function payoutAmount() public view returns(uint256) {
67         uint256 percent = percentRate();
68         uint256 different = now.sub(time[msg.sender]).div(stepTime);
69         uint256 rate = balance[msg.sender].mul(percent).div(1000);
70         uint256 withdrawalAmount = rate.mul(different).div(24).sub(percentWithdraw[msg.sender]);
71 
72         return withdrawalAmount;
73     }
74 
75     function deposit() private {
76         if (msg.value > 0) {
77             if (balance[msg.sender] == 0) {
78                 countOfInvestors += 1;
79             }
80             if (balance[msg.sender] > 0 && now > time[msg.sender].add(stepTime)) {
81                 collectPercent();
82                 percentWithdraw[msg.sender] = 0;
83             }
84             balance[msg.sender] = balance[msg.sender].add(msg.value);
85             time[msg.sender] = now;
86 
87             ownerAddress.transfer(msg.value.mul(projectPercent).div(100));
88             emit Invest(msg.sender, msg.value);
89         } else {
90             collectPercent();
91         }
92     }
93 
94     function() external payable {
95         deposit();
96     }
97 }
98 
99 /**
100  * @title SafeMath
101  * @dev Math operations with safety checks that throw on error
102  */
103 library SafeMath {
104     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
105         if (a == 0) {
106             return 0;
107         }
108         uint256 c = a * b;
109         assert(c / a == b);
110         return c;
111     }
112 
113     function div(uint256 a, uint256 b) internal pure returns (uint256) {
114         // assert(b > 0); // Solidity automatically throws when dividing by 0
115         uint256 c = a / b;
116         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
117         return c;
118     }
119 
120     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
121         assert(b <= a);
122         return a - b;
123     }
124 
125     function add(uint256 a, uint256 b) internal pure returns (uint256) {
126         uint256 c = a + b;
127         assert(c >= a);
128         return c;
129     }
130 }