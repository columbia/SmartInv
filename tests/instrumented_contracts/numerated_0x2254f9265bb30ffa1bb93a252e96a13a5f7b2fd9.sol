1 /**
2  *Submitted for verification at Etherscan.io on 2021-01-29
3 */
4 
5 // File: Contracts/Utils/SafeMath.sol
6 
7 // SPDX-License-Identifier: MIT
8 pragma solidity 0.6.12;
9 
10 /**
11  * @dev Wrappers over Solidity's arithmetic operations with added overflow
12  * checks.
13  *
14  * Arithmetic operations in Solidity wrap on overflow. This can easily result
15  * in bugs, because programmers usually assume that an overflow raises an
16  * error, which is the standard behavior in high level programming languages.
17  * `SafeMath` restores this intuition by reverting the transaction when an
18  * operation overflows.
19  *
20  * Using this library instead of the unchecked operations eliminates an entire
21  * class of bugs, so it's recommended to use it always.
22  */
23 library SafeMath {
24     /**
25      * @dev Returns the addition of two unsigned integers, reverting on
26      * overflow.
27      *
28      * Counterpart to Solidity's `+` operator.
29      *
30      * Requirements:
31      *
32      * - Addition cannot overflow.
33      */
34     function add(uint256 a, uint256 b) internal pure returns (uint256) {
35         uint256 c = a + b;
36         require(c >= a, "SafeMath: addition overflow");
37 
38         return c;
39     }
40 
41     /**
42      * @dev Returns the subtraction of two unsigned integers, reverting on
43      * overflow (when the result is negative).
44      *
45      * Counterpart to Solidity's `-` operator.
46      *
47      * Requirements:
48      *
49      * - Subtraction cannot overflow.
50      */
51     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
52         return sub(a, b, "SafeMath: subtraction overflow");
53     }
54 
55     /**
56      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
57      * overflow (when the result is negative).
58      *
59      * Counterpart to Solidity's `-` operator.
60      *
61      * Requirements:
62      *
63      * - Subtraction cannot overflow.
64      */
65     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
66         require(b <= a, errorMessage);
67         uint256 c = a - b;
68 
69         return c;
70     }
71 
72     /**
73      * @dev Returns the multiplication of two unsigned integers, reverting on
74      * overflow.
75      *
76      * Counterpart to Solidity's `*` operator.
77      *
78      * Requirements:
79      *
80      * - Multiplication cannot overflow.
81      */
82     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
83         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
84         // benefit is lost if 'b' is also tested.
85         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
86         if (a == 0) {
87             return 0;
88         }
89 
90         uint256 c = a * b;
91         require(c / a == b, "SafeMath: multiplication overflow");
92 
93         return c;
94     }
95 
96     /**
97      * @dev Returns the integer division of two unsigned integers. Reverts on
98      * division by zero. The result is rounded towards zero.
99      *
100      * Counterpart to Solidity's `/` operator. Note: this function uses a
101      * `revert` opcode (which leaves remaining gas untouched) while Solidity
102      * uses an invalid opcode to revert (consuming all remaining gas).
103      *
104      * Requirements:
105      *
106      * - The divisor cannot be zero.
107      */
108     function div(uint256 a, uint256 b) internal pure returns (uint256) {
109         return div(a, b, "SafeMath: division by zero");
110     }
111 
112     /**
113      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
114      * division by zero. The result is rounded towards zero.
115      *
116      * Counterpart to Solidity's `/` operator. Note: this function uses a
117      * `revert` opcode (which leaves remaining gas untouched) while Solidity
118      * uses an invalid opcode to revert (consuming all remaining gas).
119      *
120      * Requirements:
121      *
122      * - The divisor cannot be zero.
123      */
124     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
125         require(b > 0, errorMessage);
126         uint256 c = a / b;
127         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
128 
129         return c;
130     }
131 
132     /**
133      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
134      * Reverts when dividing by zero.
135      *
136      * Counterpart to Solidity's `%` operator. This function uses a `revert`
137      * opcode (which leaves remaining gas untouched) while Solidity uses an
138      * invalid opcode to revert (consuming all remaining gas).
139      *
140      * Requirements:
141      *
142      * - The divisor cannot be zero.
143      */
144     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
145         return mod(a, b, "SafeMath: modulo by zero");
146     }
147 
148     /**
149      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
150      * Reverts with custom message when dividing by zero.
151      *
152      * Counterpart to Solidity's `%` operator. This function uses a `revert`
153      * opcode (which leaves remaining gas untouched) while Solidity uses an
154      * invalid opcode to revert (consuming all remaining gas).
155      *
156      * Requirements:
157      *
158      * - The divisor cannot be zero.
159      */
160     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
161         require(b != 0, errorMessage);
162         return a % b;
163     }
164 }
165 
166 // File: Contracts/Mute/MuteSwap.sol
167 
168 pragma solidity 0.6.12;
169 
170 
171 /**
172  * @title Mute Swap Contract
173  * @dev Maintains and issues minting for the mute chain swap
174  */
175 contract MuteSwap {
176     using SafeMath for uint256;
177 
178     mapping(address => uint256) private _balances;
179     address public owner;
180     address public muteContract;
181     uint256 public amountSetToClaim;
182     uint256 public amountClaimed;
183 
184     modifier onlyOwner() {
185       require(msg.sender == owner, "MuteSwap::OnlyOwner: Not the owner");
186       _;
187     }
188 
189     constructor(address _muteContract) public {
190         owner = msg.sender;
191         muteContract = _muteContract;
192     }
193 
194     function addSwapInfo(address[] memory _addresses, uint256[] memory _values) external onlyOwner {
195         for (uint256 index = 0; index < _addresses.length; index++) {
196             _balances[_addresses[index]] = _balances[_addresses[index]].add(_values[index]);
197             amountSetToClaim = amountSetToClaim.add(_values[index]);
198         }
199     }
200 
201     function claimSwap() external {
202         require(_balances[msg.sender] > 0, "MuteSwap::claimSwap: must have a balance greater than 0");
203         require(IMute(muteContract).Mint(msg.sender, _balances[msg.sender]) == true);
204 
205         amountClaimed = amountClaimed.add(_balances[msg.sender]);
206         _balances[msg.sender] = 0;
207     }
208 
209     function claimBalance() external view returns (uint256) {
210         return _balances[msg.sender];
211     }
212 }
213 
214 interface IMute {
215     function Mint(address account, uint256 amount) external returns (bool);
216 }