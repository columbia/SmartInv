1 pragma solidity ^0.4.24;
2 
3 /*
4 * ---How to use:
5 *  1. Send from ETH wallet to the smart contract address
6 *     any amount ETH.
7 *  2. Claim your profit by sending 0 ether transaction (1 time per hour)
8 *  3. If you earn more than 200%, you can withdraw only one finish time
9 */
10 contract TwoHundredPercent {
11 
12     using SafeMath for uint;
13     mapping(address => uint) public balance;
14     mapping(address => uint) public time;
15     mapping(address => uint) public percentWithdraw;
16     uint public stepTime = 1 hours;
17     uint public countOfInvestors = 0;
18     address public ownerAddress = 0x84B7EEB9b876fB522Ea39e6201652Da11298A5fF;
19     uint projectPercent = 20;
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
30         require(now >= time[msg.sender].add(stepTime), "Too fast payout request");
31         _;
32     }
33 
34     function collectPercent() userExist checkTime internal {
35         if ((balance[msg.sender].mul(2)) <= percentWithdraw[msg.sender]) {
36             balance[msg.sender] = 0;
37             time[msg.sender] = 0;
38             percentWithdraw[msg.sender] = 0;
39         } else {
40             uint payout = payoutAmount();
41             time[msg.sender] = now;
42             percentWithdraw[msg.sender] += payout;
43             msg.sender.transfer(payout);
44             emit Withdraw(msg.sender, payout);
45         }
46     }
47 
48     function percentRate() public view returns(uint) {
49         uint contractBalance = address(this).balance;
50 
51         if (contractBalance < 1000 ether) {
52             return (250);
53         }
54         if (contractBalance >= 1000 ether && contractBalance < 2500 ether) {
55             return (300);
56         }
57         if (contractBalance >= 2500 ether && contractBalance < 5000 ether) {
58             return (350);
59         }
60         if (contractBalance >= 5000 ether) {
61             return (375);
62         }
63     }
64 
65     function payoutAmount() public view returns(uint) {
66         uint percent = percentRate();
67         uint rate = balance[msg.sender].mul(percent).div(100000);
68         uint interestRate = now.sub(time[msg.sender]).div(stepTime);
69         uint withdrawalAmount = rate.mul(interestRate);
70         return (withdrawalAmount);
71     }
72 
73     function deposit() private {
74         if (msg.value > 0) {
75             if (balance[msg.sender] == 0) {
76                 countOfInvestors += 1;
77             }
78             if (balance[msg.sender] > 0 && now > time[msg.sender].add(stepTime)) {
79                 collectPercent();
80             }
81             balance[msg.sender] = balance[msg.sender].add(msg.value);
82             time[msg.sender] = now;
83 
84             ownerAddress.transfer(msg.value.mul(projectPercent).div(100));
85             emit Invest(msg.sender, msg.value);
86         } else {
87             collectPercent();
88         }
89     }
90 
91     function() external payable {
92         deposit();
93     }
94 }
95 
96 /**
97  * @title SafeMath
98  * @dev Math operations with safety checks that throw on error
99  */
100 library SafeMath {
101     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
102         if (a == 0) {
103             return 0;
104         }
105         uint256 c = a * b;
106         assert(c / a == b);
107         return c;
108     }
109 
110     function div(uint256 a, uint256 b) internal pure returns (uint256) {
111         // assert(b > 0); // Solidity automatically throws when dividing by 0
112         uint256 c = a / b;
113         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
114         return c;
115     }
116 
117     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
118         assert(b <= a);
119         return a - b;
120     }
121 
122     function add(uint256 a, uint256 b) internal pure returns (uint256) {
123         uint256 c = a + b;
124         assert(c >= a);
125         return c;
126     }
127 }