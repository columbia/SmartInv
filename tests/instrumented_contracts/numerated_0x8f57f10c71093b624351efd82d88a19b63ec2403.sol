1 pragma solidity ^0.5.4;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two unsigned integers, reverts on overflow.
10      */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27      */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48      * @dev Adds two unsigned integers, reverts on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59      * reverts when dividing by zero.
60      */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 /**
68  * @title SafeERC20
69  * @dev Wrappers around ERC20 operations that throw on failure.
70  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
71  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
72  */
73 library SafeERC20 {
74     using SafeMath for uint256;
75 
76     function safeTransfer(IERC20 token, address to, uint256 value) internal {
77         require(token.transfer(to, value));
78     }
79 }
80 
81 /**
82  * @title ERC20 interface
83  * @dev see https://eips.ethereum.org/EIPS/eip-20
84  */
85 interface IERC20 {
86     function transfer(address to, uint256 value) external returns (bool);
87 }
88 
89 /**
90  * @title MultiBeneficiariesTokenTimelock
91  * @dev MultiBeneficiariesTokenTimelock is a token holder contract that will allow a
92  * beneficiaries to extract the tokens after a given release time
93  */
94 contract MultiBeneficiariesTokenTimelock {
95     using SafeERC20 for IERC20;
96 
97     // ERC20 basic token contract being held
98     IERC20 public token;
99 
100     // beneficiary of tokens after they are released
101     address[] public beneficiaries;
102     
103     // token amounts of beneficiaries to be released
104     uint256[] public tokenValues;
105 
106     // timestamp when token release is enabled
107     uint256 public releaseTime;
108     
109     //Whether tokens have been distributed
110     bool public distributed;
111 
112     constructor(
113         IERC20 _token,
114         address[] memory _beneficiaries,
115         uint256[] memory _tokenValues,
116         uint256 _releaseTime
117     )
118     public
119     {
120         require(_releaseTime > block.timestamp);
121         releaseTime = _releaseTime;
122         require(_beneficiaries.length == _tokenValues.length);
123         beneficiaries = _beneficiaries;
124         tokenValues = _tokenValues;
125         token = _token;
126         distributed = false;
127     }
128 
129     /**
130      * @notice Transfers tokens held by timelock to beneficiaries.
131      */
132     function release() public {
133         require(block.timestamp >= releaseTime);
134         require(!distributed);
135 
136         for (uint256 i = 0; i < beneficiaries.length; i++) {
137             address beneficiary = beneficiaries[i];
138             uint256 amount = tokenValues[i];
139             require(amount > 0);
140             token.safeTransfer(beneficiary, amount);
141         }
142         
143         distributed = true;
144     }
145     
146     /**
147      * Returns the time remaining until release
148      */
149     function getTimeLeft() public view returns (uint256 timeLeft){
150         if (releaseTime > block.timestamp) {
151             return releaseTime - block.timestamp;
152         }
153         return 0;
154     }
155     
156     /**
157      * Reject ETH 
158      */
159     function() external payable {
160         revert();
161     }
162 }