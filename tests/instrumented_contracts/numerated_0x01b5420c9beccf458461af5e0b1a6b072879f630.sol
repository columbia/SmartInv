1 pragma solidity 0.4.24;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8   function totalSupply() external view returns (uint256);
9 
10   function balanceOf(address who) external view returns (uint256);
11 
12   function allowance(address owner, address spender) external view returns (uint256);
13 
14   function transfer(address to, uint256 value) external returns (bool);
15 
16   function approve(address spender, uint256 value) external returns (bool);
17 
18   function transferFrom(address from, address to, uint256 value) external returns (bool);
19 
20   event Transfer(address indexed from, address indexed to, uint256 value);
21 
22   event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 /**
26  * @title SafeMath
27  * @dev Math operations with safety checks that revert on error
28  */
29 library SafeMath {
30 
31   /**
32   * @dev Multiplies two numbers, reverts on overflow.
33   */
34   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
35     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
36     // benefit is lost if 'b' is also tested.
37     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
38     if (a == 0) {
39       return 0;
40     }
41 
42     uint256 c = a * b;
43     require(c / a == b);
44 
45     return c;
46   }
47 
48   /**
49   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
50   */
51   function div(uint256 a, uint256 b) internal pure returns (uint256) {
52     require(b > 0); // Solidity only automatically asserts when dividing by 0
53     uint256 c = a / b;
54     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55 
56     return c;
57   }
58 
59   /**
60   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
61   */
62   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63     require(b <= a);
64     uint256 c = a - b;
65 
66     return c;
67   }
68 
69   /**
70   * @dev Adds two numbers, reverts on overflow.
71   */
72   function add(uint256 a, uint256 b) internal pure returns (uint256) {
73     uint256 c = a + b;
74     require(c >= a);
75 
76     return c;
77   }
78 
79   /**
80   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
81   * reverts when dividing by zero.
82   */
83   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
84     require(b != 0);
85     return a % b;
86   }
87 }
88 
89 /**
90  * @title SafeERC20
91  * @dev Wrappers around ERC20 operations that throw on failure.
92  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
93  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
94  */
95 library SafeERC20 {
96   function safeTransfer(IERC20 token, address to, uint256 value) internal {
97     require(token.transfer(to, value));
98   }
99 
100   function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
101     require(token.transferFrom(from, to, value));
102   }
103 
104   function safeApprove(IERC20 token, address spender, uint256 value) internal {
105     require(token.approve(spender, value));
106   }
107 }
108 
109 /**
110  * @title TokenTimelock
111  * @dev TokenTimelock is a token holder contract that will allow a
112  * beneficiary to extract the tokens after a given release time
113  */
114 contract TokenTimelock {
115   using SafeERC20 for IERC20;
116 
117   // ERC20 basic token contract being held
118   IERC20 private _token;
119 
120   // beneficiary of tokens after they are released
121   address private _beneficiary;
122 
123   // timestamp when token release is enabled
124   uint256 private _releaseTime;
125 
126   constructor(IERC20 token, address beneficiary, uint256 releaseTime) public {
127     // solium-disable-next-line security/no-block-members
128     require(releaseTime > block.timestamp);
129     _token = token;
130     _beneficiary = beneficiary;
131     _releaseTime = releaseTime;
132   }
133 
134   /**
135    * @return the token being held.
136    */
137   function token() public view returns(IERC20) {
138     return _token;
139   }
140 
141   /**
142    * @return the beneficiary of the tokens.
143    */
144   function beneficiary() public view returns(address) {
145     return _beneficiary;
146   }
147 
148   /**
149    * @return the time when the tokens are released.
150    */
151   function releaseTime() public view returns(uint256) {
152     return _releaseTime;
153   }
154 
155   /**
156    * @notice Transfers tokens held by timelock to beneficiary.
157    */
158   function release() public {
159     // solium-disable-next-line security/no-block-members
160     require(block.timestamp >= _releaseTime);
161 
162     uint256 amount = _token.balanceOf(address(this));
163     require(amount > 0);
164 
165     _token.safeTransfer(_beneficiary, amount);
166   }
167 }