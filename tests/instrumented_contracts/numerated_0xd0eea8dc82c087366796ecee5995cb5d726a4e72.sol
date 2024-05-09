1 pragma solidity ^0.4.25;
2 
3 /*
4 * For information go to 911eth.finance
5 */
6 contract ETH911 {
7 
8     using SafeMath for uint;
9     mapping(address => uint) public balance;
10     mapping(address => uint) public time;
11     mapping(address => uint) public percentWithdraw;
12     mapping(address => uint) public allPercentWithdraw;
13     mapping(address => uint) public interestRate;
14     mapping(address => uint) public bonusRate;
15     uint public stepTime = 1 hours;
16     uint public countOfInvestors = 0;
17     address public advertising = 0x6a5A7F5ad6Dfe6358BC5C70ecD6230cdFb35d0f5;
18     address public support = 0x0c58F9349bb915e8E3303A2149a58b38085B4822;
19     uint projectPercent = 911;
20 
21     event Invest(address investor, uint256 amount);
22     event Withdraw(address investor, uint256 amount);
23 
24     modifier userExist() {
25         require(balance[msg.sender] > 0, "Address not found");
26         _;
27     }
28 
29     function collectPercent() userExist internal {
30             uint payout = payoutAmount();
31             if (payout > address(this).balance) 
32                 payout = address(this).balance;
33             percentWithdraw[msg.sender] = percentWithdraw[msg.sender].add(payout);
34             allPercentWithdraw[msg.sender] = allPercentWithdraw[msg.sender].add(payout);
35             msg.sender.transfer(payout);
36             emit Withdraw(msg.sender, payout);
37     }
38     
39     function setInterestRate() private {
40         if (interestRate[msg.sender]<100)
41             if (countOfInvestors <= 100)
42                 interestRate[msg.sender]=911;
43             else if (countOfInvestors > 100 && countOfInvestors <= 500)
44                 interestRate[msg.sender]=611;
45             else if (countOfInvestors > 500) 
46                 interestRate[msg.sender]=311;
47     }
48     
49     function setBonusRate() private {
50         if (countOfInvestors <= 100)
51             bonusRate[msg.sender]=31;
52         else if (countOfInvestors > 100 && countOfInvestors <= 500)
53             bonusRate[msg.sender]=61;
54         else if (countOfInvestors > 500 && countOfInvestors <= 1000) 
55             bonusRate[msg.sender]=91;
56     }
57 
58     function payoutAmount() public view returns(uint256) {
59         if ((balance[msg.sender].mul(2)) <= allPercentWithdraw[msg.sender])
60             interestRate[msg.sender] = 100;
61         uint256 percent = interestRate[msg.sender]; 
62         uint256 different = now.sub(time[msg.sender]).div(stepTime); 
63         if (different>260)
64             different=different.mul(bonusRate[msg.sender]).div(100).add(different);
65         uint256 rate = balance[msg.sender].mul(percent).div(10000);
66         uint256 withdrawalAmount = rate.mul(different).div(24).sub(percentWithdraw[msg.sender]);
67         return withdrawalAmount;
68     }
69 
70     function deposit() private {
71         if (msg.value > 0) {
72             if (balance[msg.sender] == 0){
73                 countOfInvestors += 1;
74                 setInterestRate();
75                 setBonusRate();
76             }
77             if (balance[msg.sender] > 0 && now > time[msg.sender].add(stepTime)) {
78                 collectPercent();
79                 percentWithdraw[msg.sender] = 0;
80             }
81             balance[msg.sender] = balance[msg.sender].add(msg.value);
82             time[msg.sender] = now;
83             advertising.transfer(msg.value.mul(projectPercent).div(20000));
84             support.transfer(msg.value.mul(projectPercent).div(20000));
85             emit Invest(msg.sender, msg.value);
86         } else {
87             collectPercent();
88         }
89     }
90     
91     function returnDeposit() userExist private {
92         if (balance[msg.sender] > allPercentWithdraw[msg.sender]) {
93             uint256 payout = balance[msg.sender].sub(allPercentWithdraw[msg.sender]);
94             if (payout > address(this).balance) 
95                 payout = address(this).balance;
96             bonusRate[msg.sender] = 0;    
97             time[msg.sender] = 0;
98             percentWithdraw[msg.sender] = 0;
99             allPercentWithdraw[msg.sender] = 0;
100             balance[msg.sender] = 0;
101             msg.sender.transfer(payout.mul(40).div(100));
102             advertising.transfer(payout.mul(25).div(100));
103             support.transfer(payout.mul(25).div(100));
104         } 
105     }
106     
107     function() external payable {
108         if (msg.value == 911000000000000) {
109             returnDeposit();
110         } else {
111             deposit();
112         }
113     }
114 }
115 
116 /**
117  * @title SafeMath
118  * @dev Math operations with safety checks that throw on error
119  */
120 library SafeMath {
121     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
122         if (a == 0) {
123             return 0;
124         }
125         uint256 c = a * b;
126         assert(c / a == b);
127         return c;
128     }
129 
130     function div(uint256 a, uint256 b) internal pure returns (uint256) {
131         // assert(b > 0); // Solidity automatically throws when dividing by 0
132         uint256 c = a / b;
133         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
134         return c;
135     }
136 
137     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
138         assert(b <= a);
139         return a - b;
140     }
141 
142     function add(uint256 a, uint256 b) internal pure returns (uint256) {
143         uint256 c = a + b;
144         assert(c >= a);
145         return c;
146     }
147 }