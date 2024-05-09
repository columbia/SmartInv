1 // File: contracts/link/ILINK.sol
2 
3 pragma solidity 0.5.17;
4 
5 interface ILINK {
6     function balanceOf(address _addr) external returns (uint256);
7     function transferFrom(address from, address to, uint256 value) external returns (bool);
8     function transfer(address to, uint256 value) external returns (bool);
9 }
10 
11 // File: @openzeppelin/contracts/math/SafeMath.sol
12 
13 pragma solidity ^0.5.0;
14 
15 /**
16  * @dev Wrappers over Solidity's arithmetic operations with added overflow
17  * checks.
18  *
19  * Arithmetic operations in Solidity wrap on overflow. This can easily result
20  * in bugs, because programmers usually assume that an overflow raises an
21  * error, which is the standard behavior in high level programming languages.
22  * `SafeMath` restores this intuition by reverting the transaction when an
23  * operation overflows.
24  *
25  * Using this library instead of the unchecked operations eliminates an entire
26  * class of bugs, so it's recommended to use it always.
27  */
28 library SafeMath {
29     /**
30      * @dev Returns the addition of two unsigned integers, reverting on
31      * overflow.
32      *
33      * Counterpart to Solidity's `+` operator.
34      *
35      * Requirements:
36      * - Addition cannot overflow.
37      */
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a + b;
40         require(c >= a, "SafeMath: addition overflow");
41 
42         return c;
43     }
44 
45     /**
46      * @dev Returns the subtraction of two unsigned integers, reverting on
47      * overflow (when the result is negative).
48      *
49      * Counterpart to Solidity's `-` operator.
50      *
51      * Requirements:
52      * - Subtraction cannot overflow.
53      */
54     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55         return sub(a, b, "SafeMath: subtraction overflow");
56     }
57 
58     /**
59      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
60      * overflow (when the result is negative).
61      *
62      * Counterpart to Solidity's `-` operator.
63      *
64      * Requirements:
65      * - Subtraction cannot overflow.
66      *
67      * _Available since v2.4.0._
68      */
69     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
70         require(b <= a, errorMessage);
71         uint256 c = a - b;
72 
73         return c;
74     }
75 
76     /**
77      * @dev Returns the multiplication of two unsigned integers, reverting on
78      * overflow.
79      *
80      * Counterpart to Solidity's `*` operator.
81      *
82      * Requirements:
83      * - Multiplication cannot overflow.
84      */
85     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
86         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
87         // benefit is lost if 'b' is also tested.
88         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
89         if (a == 0) {
90             return 0;
91         }
92 
93         uint256 c = a * b;
94         require(c / a == b, "SafeMath: multiplication overflow");
95 
96         return c;
97     }
98 
99     /**
100      * @dev Returns the integer division of two unsigned integers. Reverts on
101      * division by zero. The result is rounded towards zero.
102      *
103      * Counterpart to Solidity's `/` operator. Note: this function uses a
104      * `revert` opcode (which leaves remaining gas untouched) while Solidity
105      * uses an invalid opcode to revert (consuming all remaining gas).
106      *
107      * Requirements:
108      * - The divisor cannot be zero.
109      */
110     function div(uint256 a, uint256 b) internal pure returns (uint256) {
111         return div(a, b, "SafeMath: division by zero");
112     }
113 
114     /**
115      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
116      * division by zero. The result is rounded towards zero.
117      *
118      * Counterpart to Solidity's `/` operator. Note: this function uses a
119      * `revert` opcode (which leaves remaining gas untouched) while Solidity
120      * uses an invalid opcode to revert (consuming all remaining gas).
121      *
122      * Requirements:
123      * - The divisor cannot be zero.
124      *
125      * _Available since v2.4.0._
126      */
127     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
128         // Solidity only automatically asserts when dividing by 0
129         require(b > 0, errorMessage);
130         uint256 c = a / b;
131         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
132 
133         return c;
134     }
135 
136     /**
137      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
138      * Reverts when dividing by zero.
139      *
140      * Counterpart to Solidity's `%` operator. This function uses a `revert`
141      * opcode (which leaves remaining gas untouched) while Solidity uses an
142      * invalid opcode to revert (consuming all remaining gas).
143      *
144      * Requirements:
145      * - The divisor cannot be zero.
146      */
147     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
148         return mod(a, b, "SafeMath: modulo by zero");
149     }
150 
151     /**
152      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
153      * Reverts with custom message when dividing by zero.
154      *
155      * Counterpart to Solidity's `%` operator. This function uses a `revert`
156      * opcode (which leaves remaining gas untouched) while Solidity uses an
157      * invalid opcode to revert (consuming all remaining gas).
158      *
159      * Requirements:
160      * - The divisor cannot be zero.
161      *
162      * _Available since v2.4.0._
163      */
164     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
165         require(b != 0, errorMessage);
166         return a % b;
167     }
168 }
169 
170 // File: contracts/link/LINKEthManager.sol
171 
172 pragma solidity 0.5.17;
173 
174 
175 
176 contract LINKEthManager {
177     using SafeMath for uint256;
178 
179     ILINK public link_;
180 
181     mapping(bytes32 => bool) public usedEvents_;
182 
183     event Locked(
184         address indexed token,
185         address indexed sender,
186         uint256 amount,
187         address recipient
188     );
189 
190     event Unlocked(
191         address ethToken,
192         uint256 amount,
193         address recipient,
194         bytes32 receiptId
195     );
196 
197     address public wallet;
198     modifier onlyWallet {
199         require(msg.sender == wallet, "HmyManager/not-authorized");
200         _;
201     }
202 
203     /**
204      * @dev constructor
205      * @param link token contract address, e.g., erc20 contract
206      * @param _wallet is the multisig wallet
207      */
208     constructor(ILINK link, address _wallet) public {
209         link_ = link;
210         wallet = _wallet;
211     }
212 
213     /**
214      * @dev lock tokens to be minted on harmony chain
215      * @param amount amount of tokens to lock
216      * @param recipient recipient address on the harmony chain
217      */
218     function lockToken(uint256 amount, address recipient) public {
219         require(
220             recipient != address(0),
221             "EthManager/recipient is a zero address"
222         );
223         require(amount > 0, "EthManager/zero token locked");
224         uint256 _balanceBefore = link_.balanceOf(msg.sender);
225         require(
226             link_.transferFrom(msg.sender, address(this), amount),
227             "EthManager/lock failed"
228         );
229         uint256 _balanceAfter = link_.balanceOf(msg.sender);
230         uint256 _actualAmount = _balanceBefore.sub(_balanceAfter);
231         emit Locked(address(link_), msg.sender, _actualAmount, recipient);
232     }
233 
234     /**
235      * @dev lock tokens for an user address to be minted on harmony chain
236      * @param amount amount of tokens to lock
237      * @param recipient recipient address on the harmony chain
238      */
239     function lockTokenFor(
240         address userAddr,
241         uint256 amount,
242         address recipient
243     ) public onlyWallet {
244         require(
245             recipient != address(0),
246             "EthManager/recipient is a zero address"
247         );
248         require(amount > 0, "EthManager/zero token locked");
249         uint256 _balanceBefore = link_.balanceOf(userAddr);
250         require(
251             link_.transferFrom(userAddr, address(this), amount),
252             "EthManager/lock failed"
253         );
254         uint256 _balanceAfter = link_.balanceOf(userAddr);
255         uint256 _actualAmount = _balanceBefore.sub(_balanceAfter);
256         emit Locked(address(link_), userAddr, _actualAmount, recipient);
257     }
258 
259     /**
260      * @dev unlock tokens after burning them on harmony chain
261      * @param amount amount of unlock tokens
262      * @param recipient recipient of the unlock tokens
263      * @param receiptId transaction hash of the burn event on harmony chain
264      */
265     function unlockToken(
266         uint256 amount,
267         address recipient,
268         bytes32 receiptId
269     ) public onlyWallet {
270         require(
271             !usedEvents_[receiptId],
272             "EthManager/The burn event cannot be reused"
273         );
274         usedEvents_[receiptId] = true;
275         require(link_.transfer(recipient, amount), "EthManager/unlock failed");
276         emit Unlocked(address(link_), amount, recipient, receiptId);
277     }
278 }