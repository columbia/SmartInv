1 pragma solidity 0.4.25;
2 
3 contract Everest {
4     using SafeMath for uint;
5     mapping(address => uint) public balance;
6     mapping(address => uint) public time;
7     mapping(address => uint) public allPercentWithdraw;
8     uint public stepTime = 24 hours;
9     uint public countOfInvestors = 0;
10     address public ownerAddress = 0x524011386BCDFB614f7373Ee8aeb494199D812BE;
11     address public adminAddress = 0xc210F228dFdb2c7C3B9BC347032a507ee62dC95c;
12     uint ownerPercent = 5;
13     uint projectPercent = 15; //1.5%
14     uint public minDeposit = 1 ether / 100;
15 
16     event Invest(address investor, uint256 amount);
17     event Withdraw(address investor, uint256 amount, string eventType);
18 
19     modifier userExist() {
20         require(balance[msg.sender] > 0, "Address not found");
21         _;
22     }
23 
24     modifier checkTime() {
25         require(now >= time[msg.sender].add(stepTime), "Too fast payout request");
26         _;
27     }
28 
29     function collectPercent() userExist checkTime internal {
30         if (balance[msg.sender].mul(2) <= allPercentWithdraw[msg.sender]) {
31             balance[msg.sender] = 0;
32             time[msg.sender] = 0;
33             allPercentWithdraw[msg.sender] = 0;
34         } else {
35             uint payout = payoutAmount();
36             allPercentWithdraw[msg.sender] = allPercentWithdraw[msg.sender].add(payout);
37             msg.sender.transfer(payout);
38             time[msg.sender] = now;
39             emit Withdraw(msg.sender, payout, 'collectPercent');
40         }
41     }
42 
43     function payoutAmount() public view returns (uint256) {
44         uint256 different = now.sub(time[msg.sender]).div(stepTime);
45         uint256 rate = balance[msg.sender].mul(projectPercent).div(1000);
46         uint256 withdrawalAmount = rate.mul(different);
47 
48         return withdrawalAmount;
49     }
50 
51     function deposit() private {
52         if (msg.value > 0) {
53             require(msg.value >= minDeposit, "Wrong deposit value");
54 
55             if (balance[msg.sender] == 0) {
56                 countOfInvestors += 1;
57 
58                 address referrer = bytesToAddress(msg.data);
59                 if (balance[referrer] > 0 && referrer != msg.sender) {
60                     uint256 sum = msg.value.mul(projectPercent).div(1000);
61                     referrer.transfer(sum);
62                     emit Withdraw(referrer, sum, 'referral');
63 
64                     msg.sender.transfer(sum);
65                     emit Withdraw(msg.sender, sum, 'referral');
66                 }
67             }
68 
69             if (balance[msg.sender] > 0 && now > time[msg.sender].add(stepTime)) {
70                 collectPercent();
71             }
72 
73             balance[msg.sender] = balance[msg.sender].add(msg.value);
74             time[msg.sender] = now;
75 
76             ownerAddress.transfer(msg.value.mul(ownerPercent).div(100));
77             adminAddress.transfer(msg.value.mul(ownerPercent).div(100));
78             emit Invest(msg.sender, msg.value);
79         } else {
80             collectPercent();
81         }
82     }
83 
84     function() external payable {
85         deposit();
86     }
87 
88     function bytesToAddress(bytes bys) private pure returns (address addr) {
89         assembly {
90             addr := mload(add(bys, 20))
91         }
92     }
93 }
94 
95 /**
96  * @title SafeMath
97  * @dev Math operations with safety checks that throw on error
98  */
99 library SafeMath {
100     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
101         if (a == 0) {
102             return 0;
103         }
104         uint256 c = a * b;
105         assert(c / a == b);
106         return c;
107     }
108 
109     function div(uint256 a, uint256 b) internal pure returns (uint256) {
110         require(b > 0);
111         uint256 c = a / b;
112         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
113         return c;
114     }
115 
116     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
117         assert(b <= a);
118         return a - b;
119     }
120 
121     function add(uint256 a, uint256 b) internal pure returns (uint256) {
122         uint256 c = a + b;
123         assert(c >= a);
124         return c;
125     }
126 }