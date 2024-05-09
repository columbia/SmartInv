1 // File: contracts/busd/IBUSD.sol
2 
3 pragma solidity 0.5.17;
4 
5 interface IBUSD {
6     function balanceOf(address _addr) external returns (uint256);
7     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
8     function transfer(address _to, uint256 _value) external returns (bool);
9     function increaseSupply(uint256 _value) external returns (bool success);
10     function decreaseSupply(uint256 _value) external returns (bool success);
11 }
12 
13 // File: @openzeppelin/contracts/math/SafeMath.sol
14 
15 pragma solidity ^0.5.0;
16 
17 /**
18  * @dev Wrappers over Solidity's arithmetic operations with added overflow
19  * checks.
20  *
21  * Arithmetic operations in Solidity wrap on overflow. This can easily result
22  * in bugs, because programmers usually assume that an overflow raises an
23  * error, which is the standard behavior in high level programming languages.
24  * `SafeMath` restores this intuition by reverting the transaction when an
25  * operation overflows.
26  *
27  * Using this library instead of the unchecked operations eliminates an entire
28  * class of bugs, so it's recommended to use it always.
29  */
30 library SafeMath {
31     /**
32      * @dev Returns the addition of two unsigned integers, reverting on
33      * overflow.
34      *
35      * Counterpart to Solidity's `+` operator.
36      *
37      * Requirements:
38      * - Addition cannot overflow.
39      */
40     function add(uint256 a, uint256 b) internal pure returns (uint256) {
41         uint256 c = a + b;
42         require(c >= a, "SafeMath: addition overflow");
43 
44         return c;
45     }
46 
47     /**
48      * @dev Returns the subtraction of two unsigned integers, reverting on
49      * overflow (when the result is negative).
50      *
51      * Counterpart to Solidity's `-` operator.
52      *
53      * Requirements:
54      * - Subtraction cannot overflow.
55      */
56     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
57         return sub(a, b, "SafeMath: subtraction overflow");
58     }
59 
60     /**
61      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
62      * overflow (when the result is negative).
63      *
64      * Counterpart to Solidity's `-` operator.
65      *
66      * Requirements:
67      * - Subtraction cannot overflow.
68      *
69      * _Available since v2.4.0._
70      */
71     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
72         require(b <= a, errorMessage);
73         uint256 c = a - b;
74 
75         return c;
76     }
77 
78     /**
79      * @dev Returns the multiplication of two unsigned integers, reverting on
80      * overflow.
81      *
82      * Counterpart to Solidity's `*` operator.
83      *
84      * Requirements:
85      * - Multiplication cannot overflow.
86      */
87     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
88         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
89         // benefit is lost if 'b' is also tested.
90         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
91         if (a == 0) {
92             return 0;
93         }
94 
95         uint256 c = a * b;
96         require(c / a == b, "SafeMath: multiplication overflow");
97 
98         return c;
99     }
100 
101     /**
102      * @dev Returns the integer division of two unsigned integers. Reverts on
103      * division by zero. The result is rounded towards zero.
104      *
105      * Counterpart to Solidity's `/` operator. Note: this function uses a
106      * `revert` opcode (which leaves remaining gas untouched) while Solidity
107      * uses an invalid opcode to revert (consuming all remaining gas).
108      *
109      * Requirements:
110      * - The divisor cannot be zero.
111      */
112     function div(uint256 a, uint256 b) internal pure returns (uint256) {
113         return div(a, b, "SafeMath: division by zero");
114     }
115 
116     /**
117      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
118      * division by zero. The result is rounded towards zero.
119      *
120      * Counterpart to Solidity's `/` operator. Note: this function uses a
121      * `revert` opcode (which leaves remaining gas untouched) while Solidity
122      * uses an invalid opcode to revert (consuming all remaining gas).
123      *
124      * Requirements:
125      * - The divisor cannot be zero.
126      *
127      * _Available since v2.4.0._
128      */
129     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
130         // Solidity only automatically asserts when dividing by 0
131         require(b > 0, errorMessage);
132         uint256 c = a / b;
133         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
134 
135         return c;
136     }
137 
138     /**
139      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
140      * Reverts when dividing by zero.
141      *
142      * Counterpart to Solidity's `%` operator. This function uses a `revert`
143      * opcode (which leaves remaining gas untouched) while Solidity uses an
144      * invalid opcode to revert (consuming all remaining gas).
145      *
146      * Requirements:
147      * - The divisor cannot be zero.
148      */
149     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
150         return mod(a, b, "SafeMath: modulo by zero");
151     }
152 
153     /**
154      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
155      * Reverts with custom message when dividing by zero.
156      *
157      * Counterpart to Solidity's `%` operator. This function uses a `revert`
158      * opcode (which leaves remaining gas untouched) while Solidity uses an
159      * invalid opcode to revert (consuming all remaining gas).
160      *
161      * Requirements:
162      * - The divisor cannot be zero.
163      *
164      * _Available since v2.4.0._
165      */
166     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
167         require(b != 0, errorMessage);
168         return a % b;
169     }
170 }
171 
172 // File: contracts/busd/BUSDEthManager.sol
173 
174 pragma solidity 0.5.17;
175 
176 
177 
178 contract BUSDEthManager {
179     using SafeMath for uint256;
180 
181     IBUSD public busd_;
182 
183     mapping(bytes32 => bool) public usedEvents_;
184 
185     event Locked(
186         address indexed token,
187         address indexed sender,
188         uint256 amount,
189         address recipient
190     );
191 
192     event Unlocked(
193         address ethToken,
194         uint256 amount,
195         address recipient,
196         bytes32 receiptId
197     );
198 
199     address public wallet;
200     modifier onlyWallet {
201         require(msg.sender == wallet, "HmyManager/not-authorized");
202         _;
203     }
204 
205     /**
206      * @dev constructor
207      * @param busd token contract address, e.g., erc20 contract
208      * @param _wallet is the multisig wallet
209      */
210     constructor(IBUSD busd, address _wallet) public {
211         busd_ = busd;
212         wallet = _wallet;
213     }
214 
215     /**
216      * @dev lock tokens to be minted on harmony chain
217      * @param amount amount of tokens to lock
218      * @param recipient recipient address on the harmony chain
219      */
220     function lockToken(uint256 amount, address recipient) public {
221         require(
222             recipient != address(0),
223             "EthManager/recipient is a zero address"
224         );
225         require(amount > 0, "EthManager/zero token locked");
226         uint256 _balanceBefore = busd_.balanceOf(msg.sender);
227         require(
228             busd_.transferFrom(msg.sender, address(this), amount),
229             "EthManager/lock failed"
230         );
231         uint256 _balanceAfter = busd_.balanceOf(msg.sender);
232         uint256 _actualAmount = _balanceBefore.sub(_balanceAfter);
233         emit Locked(address(busd_), msg.sender, _actualAmount, recipient);
234     }
235 
236     /**
237      * @dev lock tokens for an user address to be minted on harmony chain
238      * @param amount amount of tokens to lock
239      * @param recipient recipient address on the harmony chain
240      */
241     function lockTokenFor(
242         address userAddr,
243         uint256 amount,
244         address recipient
245     ) public onlyWallet {
246         require(
247             recipient != address(0),
248             "EthManager/recipient is a zero address"
249         );
250         require(amount > 0, "EthManager/zero token locked");
251         uint256 _balanceBefore = busd_.balanceOf(userAddr);
252         require(
253             busd_.transferFrom(userAddr, address(this), amount),
254             "EthManager/lock failed"
255         );
256         uint256 _balanceAfter = busd_.balanceOf(userAddr);
257         uint256 _actualAmount = _balanceBefore.sub(_balanceAfter);
258         emit Locked(address(busd_), userAddr, _actualAmount, recipient);
259     }
260 
261     /**
262      * @dev unlock tokens after burning them on harmony chain
263      * @param amount amount of unlock tokens
264      * @param recipient recipient of the unlock tokens
265      * @param receiptId transaction hash of the burn event on harmony chain
266      */
267     function unlockToken(
268         uint256 amount,
269         address recipient,
270         bytes32 receiptId
271     ) public onlyWallet {
272         require(
273             !usedEvents_[receiptId],
274             "EthManager/The burn event cannot be reused"
275         );
276         usedEvents_[receiptId] = true;
277         require(busd_.transfer(recipient, amount), "EthManager/unlock failed");
278         emit Unlocked(address(busd_), amount, recipient, receiptId);
279     }
280 }