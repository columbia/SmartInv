1 pragma solidity 0.4.25;
2 
3 contract SmartMinFin {
4 
5     using SafeMath for uint;
6     mapping(address => uint) public balance;
7     mapping(address => uint) public time;
8     mapping(address => uint) public timeFirstDeposit;
9     mapping(address => uint) public allPercentWithdraw;
10     mapping(address => uint) public reservedBalance;
11     uint public stepTime = 24 hours;
12     uint public firstStep = stepTime;
13     uint public secondStep = stepTime * 2;
14     uint public thirdStep = stepTime * 3;
15     uint public countOfInvestors = 0;
16     uint public maxWithdrawal = 3 ether;
17     address public ownerAddress = 0x166a9749e261186511B1174F955224d850Cf8af7;
18     uint projectPercent = 10;
19     uint public minDeposit = 1 ether / 10;
20 
21     event Invest(address investor, uint256 amount);
22     event Withdraw(address investor, uint256 amount);
23 
24     modifier userExist() {
25         require(balance[msg.sender] > 0, "Address not found");
26         _;
27     }
28 
29     modifier checkTime() {
30         require(now >= timeFirstDeposit[msg.sender].add(thirdStep), "Too fast for first withdrawal");
31         require(now >= time[msg.sender].add(stepTime), "Too fast payout request");
32         _;
33     }
34 
35     function collectPercent() userExist checkTime internal {
36         if (balance[msg.sender].mul(2) <= allPercentWithdraw[msg.sender]) {
37             balance[msg.sender] = 0;
38             time[msg.sender] = 0;
39         } else {
40             uint payout = payoutAmount();
41             allPercentWithdraw[msg.sender] = allPercentWithdraw[msg.sender].add(payout);
42             msg.sender.transfer(payout);
43             time[msg.sender] = now;
44             emit Withdraw(msg.sender, payout);
45         }
46     }
47 
48     function percentRate() public view returns (uint) {
49         if (now > time[msg.sender].add(thirdStep)) {
50             return (80);
51         }
52         if (now > time[msg.sender].add(secondStep)) {
53             return (50);
54         }
55         if (now > time[msg.sender].add(firstStep)) {
56             return (30);
57         }
58     }
59 
60     function payoutAmount() public view returns (uint256) {
61         uint256 percent = percentRate();
62         uint256 different = now.sub(time[msg.sender]).div(stepTime);
63         uint256 rate = balance[msg.sender].mul(percent).div(1000);
64         uint256 withdrawalAmount = rate.mul(different);
65 
66         if(reservedBalance[msg.sender] > 0) {
67             withdrawalAmount = withdrawalAmount.add(reservedBalance[msg.sender]);
68             reservedBalance[msg.sender] = 0;
69         }
70         if (withdrawalAmount > maxWithdrawal) {
71             reservedBalance[msg.sender] = withdrawalAmount.sub(maxWithdrawal);
72             withdrawalAmount = maxWithdrawal;
73         }
74 
75         return withdrawalAmount;
76     }
77 
78     function deposit() private {
79         if (msg.value > 0) {
80             require(msg.value >= minDeposit, "Wrong deposit value");
81 
82             if (balance[msg.sender] == 0) {
83                 countOfInvestors += 1;
84                 timeFirstDeposit[msg.sender] = now;
85             }
86             if (balance[msg.sender] > 0 && now > time[msg.sender].add(stepTime) && now >= timeFirstDeposit[msg.sender].add(thirdStep)) {
87                 collectPercent();
88             }
89             balance[msg.sender] = balance[msg.sender].add(msg.value);
90             time[msg.sender] = now;
91 
92             ownerAddress.transfer(msg.value.mul(projectPercent).div(100));
93             emit Invest(msg.sender, msg.value);
94         } else {
95             collectPercent();
96         }
97     }
98 
99     function() external payable {
100         deposit();
101     }
102 }
103 
104 /**
105  * @title SafeMath
106  * @dev Math operations with safety checks that throw on error
107  */
108 library SafeMath {
109     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
110         if (a == 0) {
111             return 0;
112         }
113         uint256 c = a * b;
114         assert(c / a == b);
115         return c;
116     }
117 
118     function div(uint256 a, uint256 b) internal pure returns (uint256) {
119         require(b > 0);
120         uint256 c = a / b;
121         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
122         return c;
123     }
124 
125     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
126         assert(b <= a);
127         return a - b;
128     }
129 
130     function add(uint256 a, uint256 b) internal pure returns (uint256) {
131         uint256 c = a + b;
132         assert(c >= a);
133         return c;
134     }
135 }