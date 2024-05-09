1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint a, uint b) internal pure returns (uint) {
10     if (a == 0) {
11       return 0;
12     }
13     uint c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint a, uint b) internal pure returns (uint) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint a, uint b) internal pure returns (uint) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint a, uint b) internal pure returns (uint) {
31     uint c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 contract Token {
38     
39     function balanceOf(address _owner) public constant returns (uint balance);
40     
41     function transfer(address _to, uint _value) public returns (bool success);
42 }
43 
44 
45 contract TimelockedSafe {
46 
47     using SafeMath for uint;
48 
49 	uint constant public decimals = 18;
50 
51 	uint constant public oneMonth = 30 days;
52 
53     address public adminAddress;
54 
55     address public withdrawAddress;
56 
57     uint public lockingPeriodInMonths; // all tokens are locked for a certain period
58 
59     uint public vestingPeriodInMonths; // after the locking period ends the vesting period starts, but each month
60                                        // there is a token withdraw limit as defined below
61 
62     uint public monthlyWithdrawLimitInWei; // monthly withdraw limit during the vesting period
63 
64     Token public token;
65 
66     uint public startTime;
67 
68     function TimelockedSafe(address _adminAddress, address _withdrawAddress,
69     	uint _lockingPeriodInMonths, uint _vestingPeriodInMonths,
70     	uint _monthlyWithdrawLimitInWei, address _token) public {
71         require(_adminAddress != 0);
72     	require(_withdrawAddress != 0);
73 
74     	// just to prevent mistakenly passing in a value with incorrect token unit
75     	require(_monthlyWithdrawLimitInWei > 100 * (10 ** decimals));
76 
77         adminAddress = _adminAddress;
78     	withdrawAddress = _withdrawAddress;
79     	lockingPeriodInMonths = _lockingPeriodInMonths;
80     	vestingPeriodInMonths = _vestingPeriodInMonths;
81     	monthlyWithdrawLimitInWei = _monthlyWithdrawLimitInWei;
82     	token = Token(_token);
83     	startTime = now;
84     }
85 
86     function withdraw(uint _withdrawAmountInWei) public returns (bool) {    	
87     	uint timeElapsed = now.sub(startTime);
88     	uint monthsElapsed = (timeElapsed.div(oneMonth)).add(1);
89     	require(monthsElapsed >= lockingPeriodInMonths);
90 
91     	uint fullyVestedTimeInMonths = lockingPeriodInMonths.add(vestingPeriodInMonths);
92     	uint remainingVestingPeriodInMonths = 0;
93     	if (monthsElapsed < fullyVestedTimeInMonths) {
94     		remainingVestingPeriodInMonths = fullyVestedTimeInMonths.sub(monthsElapsed);
95     	}
96 
97     	address timelockedSafeAddress = address(this);
98     	uint minimalBalanceInWei = remainingVestingPeriodInMonths.mul(monthlyWithdrawLimitInWei);
99     	uint currentTokenBalanceInWei = token.balanceOf(timelockedSafeAddress);
100     	require(currentTokenBalanceInWei.sub(_withdrawAmountInWei) >= minimalBalanceInWei);
101 
102     	require(token.transfer(withdrawAddress, _withdrawAmountInWei));
103 
104     	return true;
105     }
106 
107     function changeStartTime(uint _newStartTime) public only(adminAddress) {
108         startTime = _newStartTime;
109     }
110 
111     function changeTokenAddress(address _newTokenAddress) public only(adminAddress) {
112         token = Token(_newTokenAddress);
113     }
114 
115     function changeWithdrawAddress(address _newWithdrawAddress) public only(adminAddress) {
116         withdrawAddress = _newWithdrawAddress;
117     }
118 
119     function changeLockingPeriod(uint _newLockingPeriodInMonths) public only(adminAddress) {
120         lockingPeriodInMonths = _newLockingPeriodInMonths;
121     }
122 
123     function changeVestingPeriod(uint _newVestingPeriodInMonths) public only(adminAddress) {
124         vestingPeriodInMonths = _newVestingPeriodInMonths;
125     }
126 
127     function changeMonthlyWithdrawLimit(uint _newMonthlyWithdrawLimitInWei) public only(adminAddress) {
128         monthlyWithdrawLimitInWei = _newMonthlyWithdrawLimitInWei;
129     }
130 
131     function finalizeConfig() public only(adminAddress) {
132         adminAddress = 0x0; // config finalized, give up control 
133     }
134 
135     modifier only(address x) {
136         require(msg.sender == x);
137         _;
138     }
139 
140 }