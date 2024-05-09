1 pragma solidity ^0.5.0;
2 
3 interface IERC20 {
4     function transfer(address to, uint256 value) external returns (bool);
5 
6     function approve(address spender, uint256 value) external returns (bool);
7 
8     function transferFrom(address from, address to, uint256 value) external returns (bool);
9 
10     function totalSupply() external view returns (uint256);
11 
12     function balanceOf(address who) external view returns (uint256);
13 
14     function allowance(address owner, address spender) external view returns (uint256);
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 contract TokenDistribution {
22 
23     mapping (address => Investor) private _investors;
24     address[] investorAddresses;
25 
26     struct Investor {
27         uint256 total;
28         uint256 released;
29     }
30 
31     uint256 public initTimestamp;
32     uint256 public totalAmount;
33     IERC20 token;
34 
35     // fraction of tokens to be distributed every month.
36     // we use 140 as denominator of a fraction.
37     // if monthlyFraction[0] = 5 this means that 5/140 of total is to be distributed 
38     // in "month 1".
39     // note that numbers in this array sum up to 140, which means that after 17 months
40     // 140/140 of total will be distributed.
41     uint16[17] monthlyFraction = [
42         5,   // 1
43         15,  // 2
44         20,  // 3
45         5,   // 4
46         5,   // 5
47         5,   // 6
48         5,   // 7
49         5,   // 8
50         5,   // 9
51         5,   // 10
52         5,   // 11
53         5,   // 12
54         5,   // 13
55         5,   // 14
56         5,   // 15
57         20,  // 16
58         20  // 17
59     ];
60 
61     constructor(address _token, address[] memory investors, uint256[] memory tokenAmounts) public {
62         token = IERC20(_token);
63         initTimestamp = block.timestamp;
64         require(investors.length == tokenAmounts.length);
65     
66         for (uint i = 0; i < investors.length; i++) {
67             address investor_address = investors[i];
68             investorAddresses.push(investor_address);
69             require(_investors[investor_address].total == 0); // prevent duplicate addresses
70             _investors[investor_address].total = tokenAmounts[i] * 1000000;
71             _investors[investor_address].released = 0;
72             totalAmount += tokenAmounts[i];
73         }
74     }
75 
76     function fractionToAmount(uint256 total, uint256 numerator) internal pure returns (uint256) {
77         return (total * numerator) / 140;
78     }
79 
80     function computeUnlockedAmount(Investor storage inv) internal view returns (uint256) {
81         uint256 total = inv.total;
82         // first month is immediately unlocked
83         uint256 unlocked = fractionToAmount(total, monthlyFraction[0]);
84         uint256 daysPassed = getDaysPassed();
85         if (daysPassed > 510) {
86             return total; // after 17 months we unlock all tokens
87         }
88 
89         uint256 monthsPassed = daysPassed / 30;
90         if (monthsPassed >= 17) {
91             return total;
92         }
93 
94         // unlock up until the current month.
95         // E.g. monthsPassed == 1 then this loop is not executed
96         // if monthsPassed == 2 then this loop is executed once with m=1 and so on.
97         for (uint m = 1; m < monthsPassed; m++) {
98             unlocked += fractionToAmount(total, monthlyFraction[m]);
99         }
100     
101         // do daily unlock starting from second month
102         if (monthsPassed > 0) {
103             uint256 daysSinceStartOfAMonth = daysPassed - monthsPassed * 30;
104             if (daysSinceStartOfAMonth > 30)
105             daysSinceStartOfAMonth = 30;
106             uint256 unlockedThisMonths = fractionToAmount(total, monthlyFraction[monthsPassed]);
107             unlocked += (unlockedThisMonths * daysSinceStartOfAMonth) / 30;
108         }
109         
110         if (unlocked > total) {
111             return total;
112         } 
113         else return unlocked;
114     }
115 
116     function distributedTokensFor(address account) public {
117         Investor storage inv = _investors[account];
118         uint256 unlocked = computeUnlockedAmount(inv);
119         if (unlocked > inv.released) {
120             uint256 delta = unlocked - inv.released;
121             inv.released = unlocked;
122             token.transfer(account, delta);
123         }
124     }
125     
126     function distributedTokens() public {
127         for (uint i = 0; i < investorAddresses.length; i++) {
128             distributedTokensFor(investorAddresses[i]);
129         }
130     }
131 
132     function amountOfTokensToUnlock(address account) external view returns (uint256) {
133         Investor storage inv = _investors[account];
134         uint256 unlocked = computeUnlockedAmount(inv);
135         return (unlocked - inv.released);
136     }
137     
138     function getDaysPassed() public view returns (uint) {
139         return (block.timestamp - initTimestamp) / 86400;
140     }
141 
142 }