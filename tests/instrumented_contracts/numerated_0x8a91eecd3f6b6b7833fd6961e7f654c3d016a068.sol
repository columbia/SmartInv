1 pragma solidity ^0.5.0;
2 
3 /**
4  * @dev Wrappers over Solidity's arithmetic operations with added overflow
5  * checks.
6  *
7  * Arithmetic operations in Solidity wrap on overflow. This can easily result
8  * in bugs, because programmers usually assume that an overflow raises an
9  * error, which is the standard behavior in high level programming languages.
10  * `SafeMath` restores this intuition by reverting the transaction when an
11  * operation overflows.
12  *
13  * Using this library instead of the unchecked operations eliminates an entire
14  * class of bugs, so it's recommended to use it always.
15  */
16 library SafeMath {
17     /**
18      * @dev Returns the addition of two unsigned integers, reverting on
19      * overflow.
20      *
21      * Counterpart to Solidity's `+` operator.
22      *
23      * Requirements:
24      * - Addition cannot overflow.
25      */
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a, "SafeMath: addition overflow");
29 
30         return c;
31     }
32 
33     /**
34      * @dev Returns the subtraction of two unsigned integers, reverting on
35      * overflow (when the result is negative).
36      *
37      * Counterpart to Solidity's `-` operator.
38      *
39      * Requirements:
40      * - Subtraction cannot overflow.
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         return sub(a, b, "SafeMath: subtraction overflow");
44     }
45 
46     /**
47      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
48      * overflow (when the result is negative).
49      *
50      * Counterpart to Solidity's `-` operator.
51      *
52      * Requirements:
53      * - Subtraction cannot overflow.
54      */
55     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
56         require(b <= a, errorMessage);
57         uint256 c = a - b;
58 
59         return c;
60     }
61 
62     /**
63      * @dev Returns the multiplication of two unsigned integers, reverting on
64      * overflow.
65      *
66      * Counterpart to Solidity's `*` operator.
67      *
68      * Requirements:
69      * - Multiplication cannot overflow.
70      */
71     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
72         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
73         // benefit is lost if 'b' is also tested.
74         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
75         if (a == 0) {
76             return 0;
77         }
78 
79         uint256 c = a * b;
80         require(c / a == b, "SafeMath: multiplication overflow");
81 
82         return c;
83     }
84 
85     /**
86      * @dev Returns the integer division of two unsigned integers. Reverts on
87      * division by zero. The result is rounded towards zero.
88      *
89      * Counterpart to Solidity's `/` operator. Note: this function uses a
90      * `revert` opcode (which leaves remaining gas untouched) while Solidity
91      * uses an invalid opcode to revert (consuming all remaining gas).
92      *
93      * Requirements:
94      * - The divisor cannot be zero.
95      */
96     function div(uint256 a, uint256 b) internal pure returns (uint256) {
97         return div(a, b, "SafeMath: division by zero");
98     }
99 
100     /**
101      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
102      * division by zero. The result is rounded towards zero.
103      *
104      * Counterpart to Solidity's `/` operator. Note: this function uses a
105      * `revert` opcode (which leaves remaining gas untouched) while Solidity
106      * uses an invalid opcode to revert (consuming all remaining gas).
107      *
108      * Requirements:
109      * - The divisor cannot be zero.
110      */
111     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
112         // Solidity only automatically asserts when dividing by 0
113         require(b > 0, errorMessage);
114         uint256 c = a / b;
115         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
116 
117         return c;
118     }
119 
120     /**
121      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
122      * Reverts when dividing by zero.
123      *
124      * Counterpart to Solidity's `%` operator. This function uses a `revert`
125      * opcode (which leaves remaining gas untouched) while Solidity uses an
126      * invalid opcode to revert (consuming all remaining gas).
127      *
128      * Requirements:
129      * - The divisor cannot be zero.
130      */
131     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
132         return mod(a, b, "SafeMath: modulo by zero");
133     }
134 
135     /**
136      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
137      * Reverts with custom message when dividing by zero.
138      *
139      * Counterpart to Solidity's `%` operator. This function uses a `revert`
140      * opcode (which leaves remaining gas untouched) while Solidity uses an
141      * invalid opcode to revert (consuming all remaining gas).
142      *
143      * Requirements:
144      * - The divisor cannot be zero.
145      */
146     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
147         require(b != 0, errorMessage);
148         return a % b;
149     }
150 }
151 
152 pragma solidity ^0.5.0;
153 
154 contract Owned {
155 
156     address public owner;
157     event OwnershipTransferred(address indexed oldOwner, address indexed newOwner);
158 
159     constructor () public {
160         owner = msg.sender;
161     }
162 
163     modifier onlyOwner {
164         require(msg.sender == owner, "Caller is not the owner");
165         _;
166     }
167 
168     function transferOwnership(address newOwner) public onlyOwner {
169         require(newOwner != address(0), "Owner cannot be set to zero address");
170         emit OwnershipTransferred(owner, newOwner);
171         owner = newOwner;
172     }
173 
174     function renounceOwnership() public onlyOwner {
175         emit OwnershipTransferred(owner, address(0));
176         owner = address(0);
177     }
178 
179 }
180 
181 pragma solidity ^0.5.0;
182 
183 /**
184  * @title Interface of the ERC20 standard as defined in the EIP.
185  * @dev https://github.com/ethereum/EIPs/issues/20
186  */
187 contract ERC20 {
188 
189     uint256 public totalSupply;
190     function balanceOf(address account) public view returns (uint256);
191     function transfer(address recipient, uint256 amount) public returns (bool);
192     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool);
193     function approve(address spender, uint256 amount) public returns (bool);
194     function allowance(address owner, address spender) public view returns (uint256);
195     event Transfer(address indexed from, address indexed to, uint256 value);
196     event Approval(address indexed owner, address indexed spender, uint256 value);
197 
198 }
199 
200 pragma solidity ^0.5.0;
201 
202 contract ERC20Token is ERC20, Owned {
203     using SafeMath for uint256;
204 
205     mapping (address => uint256) public balances;
206     mapping (address => mapping (address => uint256)) public allowed;
207     uint256 public totalSupply;
208 
209     function balanceOf(address account) public view returns (uint256) {
210         return balances[account];
211     }
212 
213     function transfer(address recipient, uint256 amount) public returns (bool) {
214         _transfer(msg.sender, recipient, amount);
215         return true;
216     }
217 
218     function allowance(address owner, address spender) public view returns (uint256) {
219         return allowed[owner][spender];
220     }
221 
222     function approve(address spender, uint256 value) public returns (bool) {
223         _approve(msg.sender, spender, value);
224         return true;
225     }
226 
227     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
228         _transfer(sender, recipient, amount);
229         _approve(sender, msg.sender, allowed[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
230         return true;
231     }
232 
233     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
234         _approve(msg.sender, spender, allowed[msg.sender][spender].add(addedValue));
235         return true;
236     }
237 
238     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
239         _approve(msg.sender, spender, allowed[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
240         return true;
241     }
242 
243     function _transfer(address sender, address recipient, uint256 amount) internal {
244         require(sender != address(0), "ERC20: transfer from the zero address");
245         require(recipient != address(0), "ERC20: transfer to the zero address");
246 
247         balances[sender] = balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
248         balances[recipient] = balances[recipient].add(amount);
249         emit Transfer(sender, recipient, amount);
250     }
251 
252     function _approve(address owner, address spender, uint256 value) internal {
253         require(owner != address(0), "ERC20: approve from the zero address");
254         require(spender != address(0), "ERC20: approve to the zero address");
255 
256         allowed[owner][spender] = value;
257         emit Approval(owner, spender, value);
258     }
259 
260 }
261 
262 pragma solidity ^0.5.0;
263 
264 contract WWXToken is ERC20Token {
265     using SafeMath for uint256;
266 
267     string public name = "Wowoo Exchange Token";
268     string public symbol = "WWX";
269     uint8 public decimals = 18;
270 
271     uint256 public maxSupply = 4770799141 * 10**uint256(decimals);
272 
273     constructor (address issuer) public {
274         owner = issuer;
275         totalSupply = maxSupply;
276         balances[owner] = maxSupply;
277         emit Transfer(address(0), owner, maxSupply);
278     }
279 
280 }