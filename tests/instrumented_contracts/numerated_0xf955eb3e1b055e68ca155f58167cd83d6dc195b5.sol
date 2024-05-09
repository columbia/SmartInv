1 pragma solidity 0.4.25;
2 
3 contract SmartMinFin {
4     using SafeMath for uint;
5     mapping(address => uint) public deposited;
6     mapping(address => uint) public time;
7     mapping(address => uint) public timeFirstDeposit;
8     mapping(address => uint) public withdraw;
9     mapping(address => uint) public reservedBalance;
10     uint public stepTime = 24 hours;
11     uint public countOfInvestors = 0;
12     address admin1 = 0x49D2Fc41d52EE4bE85bC0A364A4BCF828B186FdC; //10%
13     address admin2 = 0x0798C4A872571F924Beea03acD48c6fbd655Eeee; //1%
14     address admin3 = 0xC0bFE578866CE6eD326caaBf19966158A601F4d0; //3%
15     address admin4 = 0xdc4d7a065c97d126d49D6107E29cD70EA5e31bf6; //1%
16     uint firstWithdrawal = stepTime * 7;
17     uint public maxWithdrawal = 3 ether;
18     uint public minDeposit = 1 ether / 10;
19     uint public maxDeposit = 30 ether;
20 
21     event Invest(address investor, uint256 amount);
22     event Withdraw(address investor, uint256 amount);
23 
24     modifier userExist() {
25         require(deposited[msg.sender] > 0, "Address not found");
26         _;
27     }
28 
29     modifier checkTime() {
30         require(now >= timeFirstDeposit[msg.sender].add(firstWithdrawal), "Too fast for first withdrawal");
31         require(now >= time[msg.sender].add(stepTime), "Too fast payout request");
32         _;
33     }
34 
35     function collectPercent() userExist checkTime internal {
36         uint different = now.sub(time[msg.sender]).div(stepTime);
37         uint percent = different > 10 ? 10 : different;
38         uint rate = deposited[msg.sender].mul(percent).div(1000);
39         uint withdrawalAmount = rate.mul(different);
40         uint availableToWithdrawal = deposited[msg.sender].mul(3) - withdraw[msg.sender];
41 
42         if (reservedBalance[msg.sender] > 0) {
43             withdrawalAmount = withdrawalAmount.add(reservedBalance[msg.sender]);
44             reservedBalance[msg.sender] = 0;
45         }
46 
47         if (withdrawalAmount > maxWithdrawal) {
48             reservedBalance[msg.sender] = withdrawalAmount - maxWithdrawal;
49             withdrawalAmount = maxWithdrawal;
50         }
51 
52         if (withdrawalAmount >= availableToWithdrawal) {
53             withdrawalAmount = availableToWithdrawal;
54             msg.sender.send(withdrawalAmount);
55 
56             deposited[msg.sender] = 0;
57             time[msg.sender] = 0;
58             timeFirstDeposit[msg.sender] = 0;
59             withdraw[msg.sender] = 0;
60             reservedBalance[msg.sender] = 0;
61             countOfInvestors--;
62         } else {
63             msg.sender.send(withdrawalAmount);
64 
65             time[msg.sender] = different.mul(stepTime).add(time[msg.sender]);
66             withdraw[msg.sender] = withdraw[msg.sender].add(withdrawalAmount);
67         }
68 
69         emit Withdraw(msg.sender, withdrawalAmount);
70     }
71 
72     function deposit() private {
73         if (msg.value > 0) {
74             require(msg.value >= minDeposit && msg.value <= maxDeposit, "Wrong deposit value");
75             require(deposited[msg.sender] == 0, "This address is already in use.");
76 
77             countOfInvestors += 1;
78             deposited[msg.sender] = msg.value;
79             time[msg.sender] = now;
80             timeFirstDeposit[msg.sender] = now;
81             withdraw[msg.sender] = 0;
82             reservedBalance[msg.sender] = 0;
83 
84             admin1.send(msg.value.mul(10).div(100));
85             admin2.send(msg.value.mul(1).div(100));
86             admin3.send(msg.value.mul(3).div(100));
87             admin4.send(msg.value.mul(1).div(100));
88 
89             emit Invest(msg.sender, msg.value);
90         } else {
91             collectPercent();
92         }
93     }
94 
95     function() external payable {
96         deposit();
97     }
98 }
99 
100 /**
101  * @title SafeMath
102  * @dev Math operations with safety checks that throw on error
103  */
104 library SafeMath {
105     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
106         if (a == 0) {
107             return 0;
108         }
109         uint256 c = a * b;
110         assert(c / a == b);
111         return c;
112     }
113 
114     function div(uint256 a, uint256 b) internal pure returns (uint256) {
115         require(b > 0);
116         uint256 c = a / b;
117         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
118         return c;
119     }
120 
121     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
122         assert(b <= a);
123         return a - b;
124     }
125 
126     function add(uint256 a, uint256 b) internal pure returns (uint256) {
127         uint256 c = a + b;
128         assert(c >= a);
129         return c;
130     }
131 }