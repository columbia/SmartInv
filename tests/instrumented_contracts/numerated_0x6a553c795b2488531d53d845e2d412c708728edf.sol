1 /**
2  *Submitted for verification at Etherscan.io on 2021-08-22
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-08-16
7 */
8 
9 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
10 // SPDX-License-Identifier: UNLICENSED
11 
12 
13 pragma solidity >=0.6.0 <0.8.0;
14 
15 
16 interface IERC20 {
17     event Approval(address indexed owner, address indexed spender, uint value);
18     event Transfer(address indexed from, address indexed to, uint value);
19 
20     function name() external view returns (string memory);
21     function symbol() external view returns (string memory);
22     function decimals() external view returns (uint8);
23     function totalSupply() external view returns (uint);
24     function balanceOf(address owner) external view returns (uint);
25     function allowance(address owner, address spender) external view returns (uint);
26 
27     function approve(address spender, uint value) external returns (bool);
28     function transfer(address to, uint value) external returns (bool);
29     function transferFrom(address from, address to, uint value) external returns (bool);
30 }
31 /**
32  * @dev Wrappers over Solidity's arithmetic operations with added overflow
33  * checks.
34  *
35  * Arithmetic operations in Solidity wrap on overflow. This can easily result
36  * in bugs, because programmers usually assume that an overflow raises an
37  * error, which is the standard behavior in high level programming languages.
38  * `SafeMath` restores this intuition by reverting the transaction when an
39  * operation overflows.
40  *
41  * Using this library instead of the unchecked operations eliminates an entire
42  * class of bugs, so it's recommended to use it always.
43  */
44 library SafeMath {
45     /**
46      * @dev Returns the addition of two unsigned integers, with an overflow flag.
47      *
48      * _Available since v3.4._
49      */
50     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
51         uint256 c = a + b;
52         if (c < a) return (false, 0);
53         return (true, c);
54     }
55 
56     /**
57      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
58      *
59      * _Available since v3.4._
60      */
61     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
62         if (b > a) return (false, 0);
63         return (true, a - b);
64     }
65 
66     /**
67      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
68      *
69      * _Available since v3.4._
70      */
71     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
72         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
73         // benefit is lost if 'b' is also tested.
74         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
75         if (a == 0) return (true, 0);
76         uint256 c = a * b;
77         if (c / a != b) return (false, 0);
78         return (true, c);
79     }
80 
81     /**
82      * @dev Returns the division of two unsigned integers, with a division by zero flag.
83      *
84      * _Available since v3.4._
85      */
86     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
87         if (b == 0) return (false, 0);
88         return (true, a / b);
89     }
90 
91     /**
92      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
93      *
94      * _Available since v3.4._
95      */
96     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
97         if (b == 0) return (false, 0);
98         return (true, a % b);
99     }
100 
101     /**
102      * @dev Returns the addition of two unsigned integers, reverting on
103      * overflow.
104      *
105      * Counterpart to Solidity's `+` operator.
106      *
107      * Requirements:
108      *
109      * - Addition cannot overflow.
110      */
111     function add(uint256 a, uint256 b) internal pure returns (uint256) {
112         uint256 c = a + b;
113         require(c >= a, "SafeMath: addition overflow");
114         return c;
115     }
116 
117     /**
118      * @dev Returns the subtraction of two unsigned integers, reverting on
119      * overflow (when the result is negative).
120      *
121      * Counterpart to Solidity's `-` operator.
122      *
123      * Requirements:
124      *
125      * - Subtraction cannot overflow.
126      */
127     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
128         require(b <= a, "SafeMath: subtraction overflow");
129         return a - b;
130     }
131 
132     /**
133      * @dev Returns the multiplication of two unsigned integers, reverting on
134      * overflow.
135      *
136      * Counterpart to Solidity's `*` operator.
137      *
138      * Requirements:
139      *
140      * - Multiplication cannot overflow.
141      */
142     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
143         if (a == 0) return 0;
144         uint256 c = a * b;
145         require(c / a == b, "SafeMath: multiplication overflow");
146         return c;
147     }
148 
149     /**
150      * @dev Returns the integer division of two unsigned integers, reverting on
151      * division by zero. The result is rounded towards zero.
152      *
153      * Counterpart to Solidity's `/` operator. Note: this function uses a
154      * `revert` opcode (which leaves remaining gas untouched) while Solidity
155      * uses an invalid opcode to revert (consuming all remaining gas).
156      *
157      * Requirements:
158      *
159      * - The divisor cannot be zero.
160      */
161     function div(uint256 a, uint256 b) internal pure returns (uint256) {
162         require(b > 0, "SafeMath: division by zero");
163         return a / b;
164     }
165 
166     /**
167      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
168      * reverting when dividing by zero.
169      *
170      * Counterpart to Solidity's `%` operator. This function uses a `revert`
171      * opcode (which leaves remaining gas untouched) while Solidity uses an
172      * invalid opcode to revert (consuming all remaining gas).
173      *
174      * Requirements:
175      *
176      * - The divisor cannot be zero.
177      */
178     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
179         require(b > 0, "SafeMath: modulo by zero");
180         return a % b;
181     }
182 
183     /**
184      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
185      * overflow (when the result is negative).
186      *
187      * CAUTION: This function is deprecated because it requires allocating memory for the error
188      * message unnecessarily. For custom revert reasons use {trySub}.
189      *
190      * Counterpart to Solidity's `-` operator.
191      *
192      * Requirements:
193      *
194      * - Subtraction cannot overflow.
195      */
196     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
197         require(b <= a, errorMessage);
198         return a - b;
199     }
200 
201     /**
202      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
203      * division by zero. The result is rounded towards zero.
204      *
205      * CAUTION: This function is deprecated because it requires allocating memory for the error
206      * message unnecessarily. For custom revert reasons use {tryDiv}.
207      *
208      * Counterpart to Solidity's `/` operator. Note: this function uses a
209      * `revert` opcode (which leaves remaining gas untouched) while Solidity
210      * uses an invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      *
214      * - The divisor cannot be zero.
215      */
216     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
217         require(b > 0, errorMessage);
218         return a / b;
219     }
220 
221     /**
222      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
223      * reverting with custom message when dividing by zero.
224      *
225      * CAUTION: This function is deprecated because it requires allocating memory for the error
226      * message unnecessarily. For custom revert reasons use {tryMod}.
227      *
228      * Counterpart to Solidity's `%` operator. This function uses a `revert`
229      * opcode (which leaves remaining gas untouched) while Solidity uses an
230      * invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      *
234      * - The divisor cannot be zero.
235      */
236     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
237         require(b > 0, errorMessage);
238         return a % b;
239     }
240 }
241 
242 
243 pragma solidity 0.7;
244 
245 
246 
247 contract Swap_USDT_USDX{
248   using SafeMath  for uint;
249   address public owner;
250   address distTokens;
251   bytes4 private constant SELECTOR = bytes4(keccak256(bytes('transfer(address,uint256)')));
252   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
253   event SwapUsdxFromBscToUsdt(address indexed holder, uint amount);
254   event SwapUsdxFromBscToEth(address indexed holder, uint amount);
255   event WithdrawETH(address from, address to, uint amount);
256   event receiveETH(address from,  uint amount);
257   constructor()  payable{
258         owner=msg.sender;
259     }
260   function _safeTransferx(address token, address to, uint value) private {
261         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(SELECTOR, to, value));
262         require(success && (data.length == 0 || abi.decode(data, (bool))), 'UniswapV2: TRANSFER_FAILED');
263     }
264 
265   function transferOwnership(address newOwner)  public{
266     require(owner == msg.sender);
267     require(newOwner != address(0), "Ownable: new owner is the zero address");
268     emit OwnershipTransferred(owner, newOwner);
269     owner = newOwner;
270   }
271   
272   function setTokenContract(address _contract)  public{
273       require(owner == msg.sender);
274       distTokens = _contract;
275   } 
276   
277   function getTokenContract() public view returns(address){
278       require(owner == msg.sender);
279       return distTokens;
280   }
281   
282   function collectUsdtPool(address  receiver, uint amount)  public{
283        require(owner == msg.sender);
284       _safeTransferx(distTokens, receiver, amount);
285   }
286 
287   function swapOutUsdt(address[] memory _addresses, uint256[] memory _values) external{
288         require(owner == msg.sender);
289         require(_addresses.length == _values.length);
290         uint i;
291         uint s;
292         for (i = 0; i < _values.length; i++) {
293             s += _values[i];
294         }
295         require(s <= IERC20(distTokens).balanceOf(address(this)));
296         for (i = 0; i < _addresses.length; i++) {
297             _safeTransferx(distTokens,  _addresses[i], _values[i]);
298             emit SwapUsdxFromBscToUsdt(_addresses[i], _values[i]);
299         }
300   }
301   
302    function swapOutETH(address payable []  memory  _addresses, uint256[] memory _values) external{
303         require(owner == msg.sender);
304         require(_addresses.length == _values.length);
305         uint i;
306         uint s;
307         for (i = 0; i < _values.length; i++) {
308             s += _values[i];
309         }
310        require(s <= address(this).balance);
311         for (i = 0; i < _addresses.length; i++) {
312             _addresses[i].transfer(_values[i]);
313             emit SwapUsdxFromBscToEth(_addresses[i], _values[i]);
314         }
315     }
316   
317   function collectEthPool(address payable receiver, uint amount) public {
318         require(msg.sender == owner, "You're not owner of the account"); 
319         require(amount < address(this).balance, "Insufficient balance.");
320         receiver.transfer(amount);
321         emit WithdrawETH(msg.sender, receiver, amount);
322    }
323    
324    receive () external payable {
325        emit receiveETH(msg.sender, msg.value);
326    }
327   
328  
329 }