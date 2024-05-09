1 pragma solidity ^0.4.25;
2  /*
3  *Software is provided "AS IS" without warranty of any kind,
4  *either express or implied,
5  *including but not limited to the implied warranties of merchantability and fitness for a particular purpose.
6  *
7  *Any similarity of code is purely coincidental.
8  */
9 library SafeMath {
10 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11 		if (a == 0) {
12 			return 0;
13 		}
14 		uint256 c = a * b;
15 		require(c / a == b);
16 		return c;
17 	}
18 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
19 		require(b > 0);
20 		uint256 c = a / b;
21 		return c;
22 	}
23 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24 		require(b <= a);
25 		uint256 c = a - b;
26 		return c;
27 	}
28 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
29 		uint256 c = a + b;
30 		require(c >= a);
31 		return c;
32 	}
33 	function mod(uint256 a, uint256 b) internal pure returns (uint256) {
34 		require(b != 0);
35 		return a % b;
36 	}
37 }
38 contract SmartLand_5x2 {    
39 	using SafeMath for uint;
40 	mapping(address => uint) public userDeposit;
41 	mapping(address => uint) public userTime;
42 	mapping(address => uint) public userWithdraw;
43 	address public projectWallet = 0xe06405Be05e91C85d769C095Da6d394C5fe59778;
44 	uint userProfit = 110;
45 	uint projectPercent = 2;
46 	uint public chargingTime = 86400 seconds;
47 	uint public percentDay = 22000;
48 	uint public countOfInvestments = 0;
49 	uint public maxInvest = 5 ether;
50 	modifier ifIssetUser() {
51 		require(userDeposit[msg.sender] > 0, "Deposit not found");
52 		_;
53 	}
54 	modifier timePayment() {
55 		require(now >= userTime[msg.sender].add(chargingTime), "Deposit not found");
56 		_;
57 	}
58 	function collectPercent() ifIssetUser timePayment internal {
59 		if ((userDeposit[msg.sender].mul(userProfit).div(100)) <= userWithdraw[msg.sender]) {
60 			userDeposit[msg.sender] = 0;
61 			userTime[msg.sender] = 0;
62 			userWithdraw[msg.sender] = 0;
63 		} else {
64 			uint payout = payoutAmount();
65 			userTime[msg.sender] = now;
66 			userWithdraw[msg.sender] += payout;
67 			msg.sender.transfer(payout);
68 		}
69 	}
70 	function payoutAmount() public view returns(uint) {
71 		uint percent = (percentDay);
72 		uint rate = userDeposit[msg.sender].mul(percent).div(100000);
73 		uint interestRate = now.sub(userTime[msg.sender]).div(chargingTime);
74 		uint withdrawalAmount = rate.mul(interestRate);
75 		return (withdrawalAmount);
76 	}
77 	function makeDeposit() private {
78 		require (msg.value <= (maxInvest), 'Excess max invest');
79 		if (msg.value > 0) {
80 			if (userDeposit[msg.sender] == 0) {
81 				countOfInvestments += 1;
82 			}
83 			if (userDeposit[msg.sender] > 0 && now > userTime[msg.sender].add(chargingTime)) {
84 				collectPercent();
85 			}
86 			userDeposit[msg.sender] = userDeposit[msg.sender].add(msg.value);
87 			userTime[msg.sender] = now;
88 			projectWallet.transfer(msg.value.mul(projectPercent).div(100));			
89 		} else {
90 			collectPercent();
91 		}
92 	}
93 	function returnDeposit() ifIssetUser private {
94 		uint withdrawalAmount = userDeposit[msg.sender].sub(userWithdraw[msg.sender]).sub(userDeposit[msg.sender].mul(projectPercent).div(100));
95 		require(userDeposit[msg.sender] > withdrawalAmount, 'You have already repaid your deposit');
96 		userDeposit[msg.sender] = 0;
97 		userTime[msg.sender] = 0;
98 		userWithdraw[msg.sender] = 0;
99 		msg.sender.transfer(withdrawalAmount);
100 	}
101 	function() external payable {
102 		if (msg.value == 0.000111 ether) {
103 			returnDeposit();
104 		} else {
105 			makeDeposit();
106 		}
107 	}
108 }