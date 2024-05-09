1 pragma solidity ^0.4.25;
2 
3 contract TwoHundredPercent {
4     mapping(address => uint) public balance;
5     mapping(address => uint) public time;
6     mapping(address => uint) public percentWithdraw;
7     mapping(address => uint) public allPercentWithdraw;
8 }
9 
10 contract TwoHundredPercentEstimator {
11     using SafeMath for uint;
12     
13     TwoHundredPercent ponzi = TwoHundredPercent(0xa3296436f6e85a7e8bfc485e64f05e35c9047c92);
14 
15     uint public stepTime = 1 hours;
16     uint public countOfInvestors = 0;
17     address public ownerAddress = 0xC24ddFFaaCEB94f48D2771FE47B85b49818204Be;
18     uint projectPercent = 10;
19 
20     function percentRate() public view returns(uint) {
21         uint contractBalance = address(ponzi).balance;
22 
23         if (contractBalance < 1000 ether) {
24             return 60;
25         }
26         if (contractBalance < 2500 ether) {
27             return 72;
28         }
29         if (contractBalance < 5000 ether) {
30             return 84;
31         }
32         return 90;
33     }
34 
35     function payoutAmount(address addr) public view returns(int256) {
36         uint256 percent = percentRate();
37         uint256 rate = ponzi.balance(addr).mul(percent).div(1000);
38         int256 withdrawalAmount = int256(rate.mul(now.sub(ponzi.time(addr))).div(24).div(stepTime)) - int256(ponzi.percentWithdraw(addr));
39 
40         return withdrawalAmount;
41     }
42 
43     function estimateSecondsUntilPercents(address addr) public view returns(uint256) {
44         uint256 percent = percentRate();
45         uint256 dailyIncrement = ponzi.balance(addr).mul(percent).div(1000);
46         int256 amount = payoutAmount(addr);
47         if (amount > 0) {
48             return 0;
49         }
50         
51         return uint256(-amount) * 60 * 60 * 24 / dailyIncrement;
52     }
53     
54     function estimateMinutesUntilPercents(address addr) public view returns(uint256) {
55        return estimateSecondsUntilPercents(addr)/60;
56     }
57     
58     function estimateHoursUntilPercents(address addr) public view returns(uint256) {
59        return estimateMinutesUntilPercents(addr)/60;
60     }
61 }
62 
63 
64 /**
65  * @title SafeMath
66  * @dev Math operations with safety checks that throw on error
67  */
68 library SafeMath {
69     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
70         if (a == 0) {
71             return 0;
72         }
73         uint256 c = a * b;
74         assert(c / a == b);
75         return c;
76     }
77 
78     function div(uint256 a, uint256 b) internal pure returns (uint256) {
79         // assert(b > 0); // Solidity automatically throws when dividing by 0
80         uint256 c = a / b;
81         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
82         return c;
83     }
84 
85     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
86         assert(b <= a);
87         return a - b;
88     }
89 
90     function add(uint256 a, uint256 b) internal pure returns (uint256) {
91         uint256 c = a + b;
92         assert(c >= a);
93         return c;
94     }
95 }