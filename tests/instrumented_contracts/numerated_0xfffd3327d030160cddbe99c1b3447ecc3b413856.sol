1 pragma solidity ^0.4.25;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that revert on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, reverts on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     uint256 c = a * b;
23     require(c / a == b);
24 
25     return c;
26   }
27 
28   /**
29   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
30   */
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     require(b > 0); // Solidity only automatically asserts when dividing by 0
33     uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36     return c;
37   }
38 
39   /**
40   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41   */
42   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43     require(b <= a);
44     uint256 c = a - b;
45 
46     return c;
47   }
48 
49   /**
50   * @dev Adds two numbers, reverts on overflow.
51   */
52   function add(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a + b;
54     require(c >= a);
55 
56     return c;
57   }
58 
59   /**
60   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
61   * reverts when dividing by zero.
62   */
63   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64     require(b != 0);
65     return a % b;
66   }
67 }
68 
69 // File: contracts\EthSmart.sol
70 
71 contract EthSmart {
72     /**
73     *   RECOMMENDED GAS LIMIT: 300 000 (90755 calculated by myetherwallet)
74     */
75 	using SafeMath for uint256;
76     /**
77     * @dev Admins wallets adresses:
78     */
79 	address public constant referralAddress = 0x0B4a3ADd0276A0DD311D616DCFDDE5686f4b11A7;
80 	address public constant advertisementAddress = 0x28C1aA68681d1Cca986CC1eC2fe4dF07d7Fddeef;
81 	address public constant developerAddress = 0x3f13C78c63cee71224f80d09c58f9c642d7b7b2f;
82 	
83 	mapping (address => uint256) deposited;
84 	mapping (address => uint256) withdrew;
85 	mapping (address => uint256) refearned;
86 	mapping (address => uint256) blocklock;
87 	
88      /**
89     * @dev deposit and withdrew counter for website:
90     */
91 	uint256 public totalDeposited = 0;
92 	uint256 public totalWithdrew = 0;
93 	
94      /**
95     * @dev fee split:
96     */
97 	function() payable external {
98 		uint256 referralPercent = msg.value.mul(10).div(100);
99 		uint256 advertisementPercent = msg.value.mul(7).div(100);
100 		uint256 developerPercent = msg.value.mul(3).div(100);
101         referralAddress.transfer(referralPercent);
102 	    advertisementAddress.transfer(advertisementPercent);
103 	    developerAddress.transfer(developerPercent);
104     
105 		if (deposited[msg.sender] != 0) {
106 			address investor = msg.sender;
107 			
108 			// investors dividends:
109 			uint256 depositsPercents = deposited[msg.sender].mul(5).div(100).mul(block.number-blocklock[msg.sender]).div(5900);
110 			investor.transfer(depositsPercents);
111 			withdrew[msg.sender] += depositsPercents;
112 			totalWithdrew = totalWithdrew.add(depositsPercents);}
113 
114 	    address referrer = bytesToAddress(msg.data);
115 		
116 		//investors referrer program
117 		if (referrer > 0x0 && referrer != msg.sender) {
118 			referrer.transfer(referralPercent);
119 			refearned[referrer] += referralPercent;}
120             
121         blocklock[msg.sender] = block.number;
122 		deposited[msg.sender] += msg.value;
123         totalDeposited = totalDeposited.add(msg.value);}
124 
125 	function investorDeposited(address _address) public view returns (uint256) {
126 		return deposited[_address];}
127 
128 	function investorWithdrew(address _address) public view returns (uint256) {
129 		return withdrew[_address];}
130 
131 	function investorDividends(address _address) public view returns (uint256) {
132 		return deposited[_address].mul(5).div(100).mul(block.number-blocklock[_address]).div(5900);}
133 
134 	function investorReferrals(address _address) public view returns (uint256) {
135 		return refearned[_address];}
136 
137 	function bytesToAddress(bytes bys) private pure returns (address addr) {
138 		assembly {
139 			addr := mload(add(bys, 20))}
140 	}
141 }