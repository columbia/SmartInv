1 // SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity ^0.6.0;
4 
5 library SafeMath {
6     /**
7      * @dev Returns the addition of two unsigned integers, reverting on
8      * overflow.
9      *
10      * Counterpart to Solidity's `+` operator.
11      *
12      * Requirements:
13      *
14      * - Addition cannot overflow.
15      */
16     function add(uint256 a, uint256 b) internal pure returns (uint256) {
17         uint256 c = a + b;
18         require(c >= a, "SafeMath: addition overflow");
19 
20         return c;
21     }
22 
23     /**
24      * @dev Returns the subtraction of two unsigned integers, reverting on
25      * overflow (when the result is negative).
26      *
27      * Counterpart to Solidity's `-` operator.
28      *
29      * Requirements:
30      *
31      * - Subtraction cannot overflow.
32      */
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         return sub(a, b, "SafeMath: subtraction overflow");
35     }
36 
37     /**
38      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
39      * overflow (when the result is negative).
40      *
41      * Counterpart to Solidity's `-` operator.
42      *
43      * Requirements:
44      *
45      * - Subtraction cannot overflow.
46      */
47     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
48         require(b <= a, errorMessage);
49         uint256 c = a - b;
50 
51         return c;
52     }
53 
54     /**
55      * @dev Returns the multiplication of two unsigned integers, reverting on
56      * overflow.
57      *
58      * Counterpart to Solidity's `*` operator.
59      *
60      * Requirements:
61      *
62      * - Multiplication cannot overflow.
63      */
64     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
65         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
66         // benefit is lost if 'b' is also tested.
67         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
68         if (a == 0) {
69             return 0;
70         }
71 
72         uint256 c = a * b;
73         require(c / a == b, "SafeMath: multiplication overflow");
74 
75         return c;
76     }
77 
78     /**
79      * @dev Returns the integer division of two unsigned integers. Reverts on
80      * division by zero. The result is rounded towards zero.
81      *
82      * Counterpart to Solidity's `/` operator. Note: this function uses a
83      * `revert` opcode (which leaves remaining gas untouched) while Solidity
84      * uses an invalid opcode to revert (consuming all remaining gas).
85      *
86      * Requirements:
87      *
88      * - The divisor cannot be zero.
89      */
90     function div(uint256 a, uint256 b) internal pure returns (uint256) {
91         return div(a, b, "SafeMath: division by zero");
92     }
93 
94     /**
95      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
96      * division by zero. The result is rounded towards zero.
97      *
98      * Counterpart to Solidity's `/` operator. Note: this function uses a
99      * `revert` opcode (which leaves remaining gas untouched) while Solidity
100      * uses an invalid opcode to revert (consuming all remaining gas).
101      *
102      * Requirements:
103      *
104      * - The divisor cannot be zero.
105      */
106     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
107         require(b > 0, errorMessage);
108         uint256 c = a / b;
109         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
110 
111         return c;
112     }
113 
114     /**
115      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
116      * Reverts when dividing by zero.
117      *
118      * Counterpart to Solidity's `%` operator. This function uses a `revert`
119      * opcode (which leaves remaining gas untouched) while Solidity uses an
120      * invalid opcode to revert (consuming all remaining gas).
121      *
122      * Requirements:
123      *
124      * - The divisor cannot be zero.
125      */
126     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
127         return mod(a, b, "SafeMath: modulo by zero");
128     }
129 
130     /**
131      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
132      * Reverts with custom message when dividing by zero.
133      *
134      * Counterpart to Solidity's `%` operator. This function uses a `revert`
135      * opcode (which leaves remaining gas untouched) while Solidity uses an
136      * invalid opcode to revert (consuming all remaining gas).
137      *
138      * Requirements:
139      *
140      * - The divisor cannot be zero.
141      */
142     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
143         require(b != 0, errorMessage);
144         return a % b;
145     }
146 }
147 
148 
149 interface IDSDS {
150   function epoch() external view returns (uint256);
151   function couponsExpiration(uint256 epoch) external view returns (uint256);
152   function transferCoupons(address sender, address recipient, uint256 epoch, uint256 amount) external;
153 }
154 
155 contract ReentrancyGuard {
156     // Booleans are more expensive than uint256 or any type that takes up a full
157     // word because each write operation emits an extra SLOAD to first read the
158     // slot's contents, replace the bits taken up by the boolean, and then write
159     // back. This is the compiler's defense against contract upgrades and
160     // pointer aliasing, and it cannot be disabled.
161 
162     // The values being non-zero value makes deployment a bit more expensive,
163     // but in exchange the refund on every call to nonReentrant will be lower in
164     // amount. Since refunds are capped to a percentage of the total
165     // transaction's gas, it is best to keep them low in cases like this one, to
166     // increase the likelihood of the full refund coming into effect.
167     uint256 private constant _NOT_ENTERED = 1;
168     uint256 private constant _ENTERED = 2;
169 
170     uint256 private _status;
171 
172     constructor () internal {
173         _status = _NOT_ENTERED;
174     }
175 
176     /**
177      * @dev Prevents a contract from calling itself, directly or indirectly.
178      * Calling a `nonReentrant` function from another `nonReentrant`
179      * function is not supported. It is possible to prevent this from happening
180      * by making the `nonReentrant` function external, and make it call a
181      * `private` function that does the actual work.
182      */
183     modifier nonReentrant() {
184         // On the first call to nonReentrant, _notEntered will be true
185         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
186 
187         // Any calls to nonReentrant after this point will fail
188         _status = _ENTERED;
189 
190         _;
191 
192         // By storing the original value once again, a refund is triggered (see
193         // https://eips.ethereum.org/EIPS/eip-2200)
194         _status = _NOT_ENTERED;
195     }
196 }
197 
198 contract PooledDSDCoupons is ReentrancyGuard {
199 
200   using SafeMath for uint;
201 
202   IDSDS public DSDS = IDSDS(0x6Bf977ED1A09214E6209F4EA5f525261f1A2690a);
203   address public owner;
204 
205   uint public totalSupply;
206   string public constant name = "DSD Coupon Pool";
207   string public constant symbol = "DPOOL";
208   uint8 public constant decimals = 18;
209   uint public constant WRAP_FEE_BPS = 100;
210 
211   mapping (address => uint) public balanceOf;
212   mapping (address => mapping (address => uint)) public allowance;
213 
214   event Transfer(address indexed from, address indexed to, uint value);
215   event Approval(address indexed owner, address indexed spender, uint value);
216 
217   constructor() public {
218     owner = msg.sender;
219   }
220 
221   function wrap(uint _epoch, uint _amount) public nonReentrant {
222     uint expiresIn = DSDS.couponsExpiration(_epoch).sub(DSDS.epoch());
223     require(expiresIn >= 120, "PooledDSDCoupons: coupon expires in less than 120 epochs");
224 
225     uint fee = _amount.mul(WRAP_FEE_BPS).div(10000);
226     _mint(owner, fee);
227     _mint(msg.sender, _amount.sub(fee));
228     DSDS.transferCoupons(msg.sender, address(this), _epoch, _amount);
229   }
230 
231   function unwrap(uint _epoch, uint _amount) public nonReentrant {
232     _burn(msg.sender, _amount);
233     DSDS.transferCoupons(address(this), msg.sender, _epoch, _amount);
234   }
235 
236   // ERC20 functions
237 
238   function approve(address _spender, uint _amount) public returns (bool) {
239     _approve(msg.sender, _spender, _amount);
240     return true;
241   }
242 
243   function transfer(address _recipient, uint _amount) public returns (bool) {
244     _transfer(msg.sender, _recipient, _amount);
245     return true;
246   }
247 
248   function transferFrom(address _sender, address _recipient, uint _amount) public returns (bool) {
249     _transfer(_sender, _recipient, _amount);
250     _approve(_sender, msg.sender, allowance[_sender][msg.sender].sub(_amount, "ERC20: transfer amount exceeds allowance"));
251     return true;
252   }
253 
254   function _transfer(
255     address _sender,
256     address _recipient,
257     uint _amount
258   ) internal {
259     require(_sender != address(0), "ERC20: transfer from the zero address");
260     require(_recipient != address(0), "ERC20: transfer to the zero address");
261 
262     balanceOf[_sender] = balanceOf[_sender].sub(_amount, "ERC20: transfer amount exceeds balance");
263     balanceOf[_recipient] = balanceOf[_recipient].add(_amount);
264 
265     emit Transfer(_sender, _recipient, _amount);
266   }
267 
268   function _mint(address _account, uint _amount) internal {
269     require(_account != address(0), "ERC20: mint to the zero address");
270 
271     totalSupply = totalSupply.add(_amount);
272     balanceOf[_account] = balanceOf[_account].add(_amount);
273     emit Transfer(address(0), _account, _amount);
274   }
275 
276   function _burn(address _account, uint _amount) internal {
277     require(_account != address(0), "ERC20: burn to the zero address");
278 
279     totalSupply = totalSupply.sub(_amount);
280     balanceOf[_account] = balanceOf[_account].sub(_amount);
281     emit Transfer(_account, address(0), _amount);
282   }
283 
284   function _approve(address _owner, address _spender, uint _amount) internal {
285     require(_owner != address(0), "ERC20: approve from the zero address");
286     require(_spender != address(0), "ERC20: approve to the zero address");
287 
288     allowance[_owner][_spender] = _amount;
289     emit Approval(_owner, _spender, _amount);
290   }
291 }