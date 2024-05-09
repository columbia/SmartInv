1 pragma solidity ^0.4.24;
2 
3 /*
4 * ---How to use:
5 *  1. Send from ETH wallet to the smart contract address
6 *     any amount ETH.
7 *  2. Claim your profit by sending 0 ether transaction (1 time per hour)
8 *  3. If you earn more than 200%, you can withdraw only one finish time
9 */
10 contract SmartDouble {
11 
12     using SafeMath for uint;
13     mapping(address => uint) public balance;
14     mapping(address => uint) public time;
15     mapping(address => uint) public percentWithdraw;
16     mapping(address => uint) public allPercentWithdraw;
17     uint public stepTime = 1 hours;
18     uint public countOfInvestors = 0;
19     address public ownerAddress = 0x582A3276DbEe1dAdC5C1d0a005DD7A1FC4bDe43f;
20     uint projectPercent = 12;
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
52         if (contractBalance >= 0 ether) {
53             return (24);
54         }
55     }
56 
57     function payoutAmount() public view returns(uint256) {
58         uint256 percent = percentRate();
59         uint256 different = now.sub(time[msg.sender]).div(stepTime);
60         uint256 rate = balance[msg.sender].mul(percent).div(1000);
61         uint256 withdrawalAmount = rate.mul(different).div(24).sub(percentWithdraw[msg.sender]);
62 
63         return withdrawalAmount;
64     }
65 
66     function deposit() private {
67         if (msg.value > 0) {
68             if (balance[msg.sender] == 0) {
69                 countOfInvestors += 1;
70             }
71             if (balance[msg.sender] > 0 && now > time[msg.sender].add(stepTime)) {
72                 collectPercent();
73                 percentWithdraw[msg.sender] = 0;
74             }
75             balance[msg.sender] = balance[msg.sender].add(msg.value);
76             time[msg.sender] = now;
77 
78             ownerAddress.transfer(msg.value.mul(projectPercent).div(100));
79             emit Invest(msg.sender, msg.value);
80         } else {
81             collectPercent();
82         }
83     }
84 
85     function() external payable {
86         deposit();
87     }
88 }
89 
90 /**
91  * @title SafeMath
92  * @dev Math operations with safety checks that throw on error
93  */
94 library SafeMath {
95     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
96         if (a == 0) {
97             return 0;
98         }
99         uint256 c = a * b;
100         assert(c / a == b);
101         return c;
102     }
103 
104     function div(uint256 a, uint256 b) internal pure returns (uint256) {
105         // assert(b > 0); // Solidity automatically throws when dividing by 0
106         uint256 c = a / b;
107         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
108         return c;
109     }
110 
111     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
112         assert(b <= a);
113         return a - b;
114     }
115 
116     function add(uint256 a, uint256 b) internal pure returns (uint256) {
117         uint256 c = a + b;
118         assert(c >= a);
119         return c;
120     }
121 }