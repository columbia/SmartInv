1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     uint256 c = a * b;
21     require(c / a == b);
22 
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     require(b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     require(b <= a);
42     uint256 c = a - b;
43 
44     return c;
45   }
46 
47   /**
48   * @dev Adds two numbers, reverts on overflow.
49   */
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     require(c >= a);
53 
54     return c;
55   }
56 
57   /**
58   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59   * reverts when dividing by zero.
60   */
61   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b != 0);
63     return a % b;
64   }
65 }
66 
67 contract Project424_2 {
68   using SafeMath for uint256;
69 
70   address constant MARKETING_ADDRESS = 0xcc1B012Dc66f51E6cE77122711A8F730eF5a97fa;
71   address constant TEAM_ADDRESS = 0x155a3c1Ab0Ac924cB3079804f3784d4d13cF3a45;
72   address constant REFUND_ADDRESS = 0x732445bfB4F9541ba4A295d31Fb830B2ffdA80F8;
73 
74   uint256 constant ONE_HUNDREDS_PERCENTS = 10000;      // 100%
75   uint256 constant INCOME_MAX_PERCENT = 5000;          // 50%
76   uint256 constant MARKETING_FEE = 1000;               // 10%
77   uint256 constant WITHDRAWAL_PERCENT = 1500;          // 15%
78   uint256 constant TEAM_FEE = 300;                     // 3%
79   uint256 constant REFUND_FEE = 200;                   // 2%
80   uint256 constant INCOME_PERCENT = 150;               // 1.5%
81   uint256 constant BALANCE_WITHDRAWAL_PERCENT = 10;    // 0.1%
82   uint256 constant BALANCE_INCOME_PERCENT = 1;         // 0.01%
83 
84   uint256 constant DAY = 86400;                        // 1 day
85 
86   uint256 constant SPECIAL_NUMBER = 4240 szabo;        // 0.00424 eth
87   
88   event AddInvestor(address indexed investor, uint256 amount);
89 
90   struct User {
91     uint256 firstTime;
92     uint256 deposit;
93   }
94   mapping(address => User) public users;
95 
96   function () payable external {
97     User storage user = users[msg.sender];
98 
99     // deposits
100     if ( msg.value != 0 && user.firstTime == 0 ) {
101       user.firstTime = now;
102       user.deposit = msg.value;
103       AddInvestor(msg.sender, msg.value);
104       
105       MARKETING_ADDRESS.send(msg.value.mul(MARKETING_FEE).div(ONE_HUNDREDS_PERCENTS));
106       TEAM_ADDRESS.send(msg.value.mul(TEAM_FEE).div(ONE_HUNDREDS_PERCENTS));
107       REFUND_ADDRESS.send(msg.value.mul(REFUND_FEE).div(ONE_HUNDREDS_PERCENTS));
108 
109     } else if ( msg.value == SPECIAL_NUMBER && user.firstTime != 0 ) { // withdrawal
110       uint256 withdrawalSum = userWithdrawalSum(msg.sender).add(SPECIAL_NUMBER);
111 
112       // check all funds
113       if (withdrawalSum >= address(this).balance) {
114         withdrawalSum = address(this).balance;
115       }
116 
117       // deleting
118       user.firstTime = 0;
119       user.deposit = 0;
120 
121       msg.sender.send(withdrawalSum);
122     } else {
123       revert();
124     }
125   }
126 
127   function userWithdrawalSum(address wallet) public view returns(uint256) {
128     User storage user = users[wallet];
129     uint256 daysDuration = getDays(wallet);
130     uint256 withdrawal = user.deposit;
131 
132 
133     (uint256 getBalanceWithdrawalPercent, uint256 getBalanceIncomePercent) = getBalancePercents();
134     uint currentDeposit = user.deposit;
135     
136     if (daysDuration == 0) {
137       return withdrawal.sub(withdrawal.mul(WITHDRAWAL_PERCENT.add(getBalanceWithdrawalPercent)).div(ONE_HUNDREDS_PERCENTS));
138     }
139 
140     for (uint256 i = 0; i < daysDuration; i++) {
141       currentDeposit = currentDeposit.add(currentDeposit.mul(INCOME_PERCENT.add(getBalanceIncomePercent)).div(ONE_HUNDREDS_PERCENTS));
142 
143       if (currentDeposit >= user.deposit.add(user.deposit.mul(INCOME_MAX_PERCENT).div(ONE_HUNDREDS_PERCENTS))) {
144         withdrawal = user.deposit.add(user.deposit.mul(INCOME_MAX_PERCENT).div(ONE_HUNDREDS_PERCENTS));
145 
146         break;
147       } else {
148         withdrawal = currentDeposit.sub(currentDeposit.mul(WITHDRAWAL_PERCENT.add(getBalanceWithdrawalPercent)).div(ONE_HUNDREDS_PERCENTS));
149       }
150     }
151     
152     return withdrawal;
153   }
154   
155   function getDays(address wallet) public view returns(uint256) {
156     User storage user = users[wallet];
157     if (user.firstTime == 0) {
158         return 0;
159     } else {
160         return (now.sub(user.firstTime)).div(DAY);
161     }
162   }
163 
164   function getBalancePercents() public view returns(uint256 withdrawalRate, uint256 incomeRate) {
165     if (address(this).balance >= 100 ether) {
166       if (address(this).balance >= 5000 ether) {
167         withdrawalRate = 500;
168         incomeRate = 50;
169       } else {
170         uint256 steps = (address(this).balance).div(100 ether);
171         uint256 withdrawalUtility = 0;
172         uint256 incomeUtility = 0;
173 
174         for (uint i = 0; i < steps; i++) {
175           withdrawalUtility = withdrawalUtility.add(BALANCE_WITHDRAWAL_PERCENT);
176           incomeUtility = incomeUtility.add(BALANCE_INCOME_PERCENT);
177         }
178         
179         withdrawalRate = withdrawalUtility;
180         incomeRate = incomeUtility;
181       }
182     } else {
183       withdrawalRate = 0;
184       incomeRate = 0;
185     }
186   }
187 }