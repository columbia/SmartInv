1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface ICvnToken {
8     function totalSupply() external view returns (uint256);
9 
10     function balanceOf(address who) external view returns (uint256);
11 
12     function allowance(address owner, address spender) external view returns (uint256);
13 
14     function transfer(address to, uint256 value) external returns (bool);
15 
16     function approve(address spender, uint256 value) external returns (bool);
17 
18     function transferFrom(address from, address to, uint256 value) external returns (bool);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 /**
25  * @title SafeMath
26  * @dev Math operations with safety checks that revert on error
27  */
28 library SafeMath {
29     /**
30     * @dev Multiplies two numbers, reverts on overflow.
31     */
32     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
33         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
34         // benefit is lost if 'b' is also tested.
35         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
36         if (a == 0) {
37             return 0;
38         }
39 
40         uint256 c = a * b;
41         require(c / a == b);
42 
43         return c;
44     }
45 
46     /**
47     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
48     */
49     function div(uint256 a, uint256 b) internal pure returns (uint256) {
50         // Solidity only automatically asserts when dividing by 0
51         require(b > 0);
52         uint256 c = a / b;
53         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
54 
55         return c;
56     }
57 
58     /**
59     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
60     */
61     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b <= a);
63         uint256 c = a - b;
64 
65         return c;
66     }
67 
68     /**
69     * @dev Adds two numbers, reverts on overflow.
70     */
71     function add(uint256 a, uint256 b) internal pure returns (uint256) {
72         uint256 c = a + b;
73         require(c >= a);
74 
75         return c;
76     }
77 
78     /**
79     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
80     * reverts when dividing by zero.
81     */
82     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
83         require(b != 0);
84         return a % b;
85     }
86 }
87 
88 /**
89  * @title SafeERC20
90  * @dev Wrappers around ERC20 operations that throw on failure.
91  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
92  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
93  */
94 library SafeERC20 {
95     using SafeMath for uint256;
96 
97     function safeTransfer(ICvnToken token, address to, uint256 value) internal {
98         require(token.transfer(to, value));
99     }
100 
101     function safeTransferFrom(ICvnToken token, address from, address to, uint256 value) internal {
102         require(token.transferFrom(from, to, value));
103     }
104 
105     function safeApprove(ICvnToken token, address spender, uint256 value) internal {
106         // safeApprove should only be called when setting an initial allowance,
107         // or when resetting it to zero. To increase and decrease it, use
108         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
109         require((value == 0) || (token.allowance(msg.sender, spender) == 0));
110         require(token.approve(spender, value));
111     }
112 
113     function safeIncreaseAllowance(ICvnToken token, address spender, uint256 value) internal {
114         uint256 newAllowance = token.allowance(address(this), spender).add(value);
115         require(token.approve(spender, newAllowance));
116     }
117 
118     function safeDecreaseAllowance(ICvnToken token, address spender, uint256 value) internal {
119         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
120         require(token.approve(spender, newAllowance));
121     }
122 }
123 /**
124  * @title TokenTimelock
125  * @dev TokenTimelock is a token holder contract that will allow a
126  * beneficiary to extract the tokens after a given release time
127  */
128 contract TokenTimelock {
129     using SafeERC20 for ICvnToken;
130 
131     // ERC20 basic token contract being held
132     ICvnToken private _token;
133 
134     // beneficiary of tokens after they are released
135     address private _beneficiary;
136 
137     // timestamp when token release is enabled
138     uint256 private _releaseTime;
139 
140     constructor (ICvnToken token, address beneficiary, uint256 releaseTime) public {
141         // solium-disable-next-line security/no-block-members
142         require(releaseTime > block.timestamp);
143         require(beneficiary != address(0));
144         _token = token;
145         _beneficiary = beneficiary;
146         _releaseTime = releaseTime;
147     }
148 
149     /**
150      * @return the token being held.
151      */
152     function token() public view returns (ICvnToken) {
153         return _token;
154     }
155 
156     /**
157      * @return the beneficiary of the tokens.
158      */
159     function beneficiary() public view returns (address) {
160         return _beneficiary;
161     }
162 
163     /**
164      * @return the time when the tokens are released.
165      */
166     function releaseTime() public view returns (uint256) {
167         return _releaseTime;
168     }
169 
170     /**
171      * @notice Transfers tokens held by timelock to beneficiary.
172      */
173     function release() public {
174         // solium-disable-next-line security/no-block-members
175         require(block.timestamp >= _releaseTime);
176 
177         uint256 amount = _token.balanceOf(address(this));
178         require(amount > 0);
179 
180         _token.safeTransfer(_beneficiary, amount);
181     }
182 
183     // can accept ether
184     function() payable {}
185 }