1 pragma solidity ^0.4.24;
2 
3 /*
4 * ---How to use:
5 *  1. Send from ETH wallet to the smart contract address
6 *     any amount ETH.
7 *  2. Claim your profit by sending 0 ether transaction (1 time per hour)
8 *  3. If you earn more than 200%, you can withdraw only one finish time
9 */
10 contract X2_555ETH {
11 
12     using SafeMath for uint;
13     mapping(address => uint) public balance;
14     mapping(address => uint) public time;
15     mapping(address => uint) public percentWithdraw;
16     mapping(address => uint) public allPercentWithdraw;
17     uint public stepTime = 1 hours;
18     uint public countOfInvestors = 0;
19     address public ownerAddress = 0x0921fF7C0a326c095844874aD82b2B6f30365554;
20     uint projectPercent = 11;
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
53             return (55);
54         }
55         if (contractBalance >= 1000 ether && contractBalance < 2500 ether) {
56             return (44);
57         }
58         if (contractBalance >= 2500 ether && contractBalance < 5000 ether) {
59             return (33);
60         }
61         if (contractBalance >= 5000 ether && contractBalance < 10000 ether) {
62             return (21);
63         }    
64         if (contractBalance >= 10000 ether) {
65             return (15);
66         }
67     }
68 
69     function payoutAmount() public view returns(uint256) {
70         uint256 percent = percentRate();
71         uint256 different = now.sub(time[msg.sender]).div(stepTime);
72         uint256 rate = balance[msg.sender].mul(percent).div(1000);
73         uint256 withdrawalAmount = rate.mul(different).div(24).sub(percentWithdraw[msg.sender]);
74 
75         return withdrawalAmount;
76     }
77 
78     function deposit() private {
79         if (msg.value > 0) {
80             if (balance[msg.sender] == 0) {
81                 countOfInvestors += 1;
82             }
83             if (balance[msg.sender] > 0 && now > time[msg.sender].add(stepTime)) {
84                 collectPercent();
85                 percentWithdraw[msg.sender] = 0;
86             }
87             balance[msg.sender] = balance[msg.sender].add(msg.value);
88             time[msg.sender] = now;
89 
90             ownerAddress.transfer(msg.value.mul(projectPercent).div(100));
91             emit Invest(msg.sender, msg.value);
92         } else {
93             collectPercent();
94         }
95     }
96 
97     function() external payable {
98         deposit();
99     }
100 }
101 
102 /**
103  * @title SafeMath
104  * @dev Math operations with safety checks that throw on error
105  */
106 library SafeMath {
107     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
108         if (a == 0) {
109             return 0;
110         }
111         uint256 c = a * b;
112         assert(c / a == b);
113         return c;
114     }
115 
116     function div(uint256 a, uint256 b) internal pure returns (uint256) {
117         // assert(b > 0); // Solidity automatically throws when dividing by 0
118         uint256 c = a / b;
119         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
120         return c;
121     }
122 
123     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
124         assert(b <= a);
125         return a - b;
126     }
127 
128     function add(uint256 a, uint256 b) internal pure returns (uint256) {
129         uint256 c = a + b;
130         assert(c >= a);
131         return c;
132     }
133 }