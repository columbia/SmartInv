1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.7.0;
3 
4 library SafeMath {
5     /**
6      * @dev Returns the addition of two unsigned integers, reverting on
7      * overflow.
8      *
9      * Counterpart to Solidity's `+` operator.
10      *
11      * Requirements:
12      * - Addition cannot overflow.
13      */
14     function add(uint256 a, uint256 b) internal pure returns (uint256) {
15         uint256 c = a + b;
16         require(c >= a, "SafeMath: addition overflow");
17 
18         return c;
19     }
20 
21     /**
22      * @dev Returns the subtraction of two unsigned integers, reverting on
23      * overflow (when the result is negative).
24      *
25      * Counterpart to Solidity's `-` operator.
26      *
27      * Requirements:
28      * - Subtraction cannot overflow.
29      */
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         return sub(a, b, "SafeMath: subtraction overflow");
32     }
33 
34     /**
35      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
36      * overflow (when the result is negative).
37      *
38      * Counterpart to Solidity's `-` operator.
39      *
40      * Requirements:
41      * - Subtraction cannot overflow.
42      *
43      * _Available since v2.4.0._
44      */
45     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
46         require(b <= a, errorMessage);
47         uint256 c = a - b;
48 
49         return c;
50     }
51 
52     /**
53      * @dev Returns the multiplication of two unsigned integers, reverting on
54      * overflow.
55      *
56      * Counterpart to Solidity's `*` operator.
57      *
58      * Requirements:
59      * - Multiplication cannot overflow.
60      */
61     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
62         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
63         // benefit is lost if 'b' is also tested.
64         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
65         if (a == 0) {
66             return 0;
67         }
68 
69         uint256 c = a * b;
70         require(c / a == b, "SafeMath: multiplication overflow");
71 
72         return c;
73     }
74 
75     /**
76      * @dev Returns the integer division of two unsigned integers. Reverts on
77      * division by zero. The result is rounded towards zero.
78      *
79      * Counterpart to Solidity's `/` operator. Note: this function uses a
80      * `revert` opcode (which leaves remaining gas untouched) while Solidity
81      * uses an invalid opcode to revert (consuming all remaining gas).
82      *
83      * Requirements:
84      * - The divisor cannot be zero.
85      */
86     function div(uint256 a, uint256 b) internal pure returns (uint256) {
87         return div(a, b, "SafeMath: division by zero");
88     }
89 
90     /**
91      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
92      * division by zero. The result is rounded towards zero.
93      *
94      * Counterpart to Solidity's `/` operator. Note: this function uses a
95      * `revert` opcode (which leaves remaining gas untouched) while Solidity
96      * uses an invalid opcode to revert (consuming all remaining gas).
97      *
98      * Requirements:
99      * - The divisor cannot be zero.
100      *
101      * _Available since v2.4.0._
102      */
103     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
104         // Solidity only automatically asserts when dividing by 0
105         require(b > 0, errorMessage);
106         uint256 c = a / b;
107         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
108 
109         return c;
110     }
111 
112     /**
113      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
114      * Reverts when dividing by zero.
115      *
116      * Counterpart to Solidity's `%` operator. This function uses a `revert`
117      * opcode (which leaves remaining gas untouched) while Solidity uses an
118      * invalid opcode to revert (consuming all remaining gas).
119      *
120      * Requirements:
121      * - The divisor cannot be zero.
122      */
123     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
124         return mod(a, b, "SafeMath: modulo by zero");
125     }
126 
127     /**
128      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
129      * Reverts with custom message when dividing by zero.
130      *
131      * Counterpart to Solidity's `%` operator. This function uses a `revert`
132      * opcode (which leaves remaining gas untouched) while Solidity uses an
133      * invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      * - The divisor cannot be zero.
137      *
138      * _Available since v2.4.0._
139      */
140     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
141         require(b != 0, errorMessage);
142         return a % b;
143     }
144 }
145 
146 
147 interface IERC20 {
148     /**
149      * @dev Returns the amount of tokens in existence.
150      */
151     function totalSupply() external view returns (uint256);
152 
153     /**
154      * @dev Returns the amount of tokens owned by `account`.
155      */
156     function balanceOf(address account) external view returns (uint256);
157 
158     /**
159      * @dev Moves `amount` tokens from the caller's account to `recipient`.
160      *
161      * Returns a boolean value indicating whether the operation succeeded.
162      *
163      * Emits a {Transfer} event.
164      */
165     function transfer(address recipient, uint256 amount) external returns (bool);
166 
167     /**
168      * @dev Returns the remaining number of tokens that `spender` will be
169      * allowed to spend on behalf of `owner` through {transferFrom}. This is
170      * zero by default.
171      *
172      * This value changes when {approve} or {transferFrom} are called.
173      */
174     function allowance(address owner, address spender) external view returns (uint256);
175 
176     /**
177      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
178      *
179      * Returns a boolean value indicating whether the operation succeeded.
180      *
181      * IMPORTANT: Beware that changing an allowance with this method brings the risk
182      * that someone may use both the old and the new allowance by unfortunate
183      * transaction ordering. One possible solution to mitigate this race
184      * condition is to first reduce the spender's allowance to 0 and set the
185      * desired value afterwards:
186      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
187      *
188      * Emits an {Approval} event.
189      */
190     function approve(address spender, uint256 amount) external returns (bool);
191 
192     /**
193      * @dev Moves `amount` tokens from `sender` to `recipient` using the
194      * allowance mechanism. `amount` is then deducted from the caller's
195      * allowance.
196      *
197      * Returns a boolean value indicating whether the operation succeeded.
198      *
199      * Emits a {Transfer} event.
200      */
201     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
202     
203     function burn(uint256 amount) external;
204 
205     /**
206      * @dev Emitted when `value` tokens are moved from one account (`from`) to
207      * another (`to`).
208      *
209      * Note that `value` may be zero.
210      */
211     event Transfer(address indexed from, address indexed to, uint256 value);
212 
213     /**
214      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
215      * a call to {approve}. `value` is the new allowance.
216      */
217     event Approval(address indexed owner, address indexed spender, uint256 value);
218 }
219 
220 
221 contract Readable {
222     function since(uint _timestamp) internal view returns(uint) {
223         if (not(passed(_timestamp))) {
224             return 0;
225         }
226         return block.timestamp - _timestamp;
227     }
228 
229     function passed(uint _timestamp) internal view returns(bool) {
230         return _timestamp < block.timestamp;
231     }
232 
233     function not(bool _condition) internal pure returns(bool) {
234         return !_condition;
235     }
236 }
237 
238 contract TransmuteSale is  Readable {
239     using SafeMath for uint256;
240     
241     uint public constant SALE_START = 1610650800; // Monday, January 14, 2021 7:00:00 PM UTC
242     
243     uint public constant SALE_END = SALE_START + 7 days; // Monday, January 21, 2021 7:00:00 PM UTC
244     uint public hardCap = 777e18; // 777 ETH
245     
246     uint public maximumDeposit = 5e18; // 5 ETH
247     uint public minimumDeposit = 1e17; // 0.1 ETH
248     
249     uint public XPb_1ETH = 1544; // XPb amount per 1 ETH
250     
251     address public XPbToken = 0xbC81BF5B3173BCCDBE62dba5f5b695522aD63559; 
252     
253     address private _owner = 0xA91B501e356a60deE0f1927B377C423Cfeda4d1E;
254     
255     mapping(address => uint) public deposited;
256     
257     uint public totalDepositedETH;
258     
259     event OwnershipTransferred( address indexed previousOwner, address indexed newOwner);
260     
261     constructor()  {  }
262     
263     
264     modifier onlyOwner() {
265         require(isOwner(msg.sender));
266         _;
267     }
268 
269     function isOwner(address account) public view returns(bool) {
270         return account == _owner;
271     }
272     
273     function viewOwner() public view returns(address) {
274     return _owner;
275     }
276     
277     function transferOwnership(address newOwner) public onlyOwner  {
278         
279     _transferOwnership(newOwner);
280     }
281 
282   function _transferOwnership(address newOwner)  internal {
283       emit OwnershipTransferred(_owner, newOwner);
284     _owner = newOwner;
285     
286   }
287   
288     function SaleStarted() public view returns(bool) {
289         return passed(SALE_START);
290     }
291 
292     function SaleEnded() public view returns(bool) {
293         return passed(SALE_END);
294     }
295 
296 
297     fallback () external payable {
298         depositETH();
299     }
300     
301     function depositETH() public payable {
302         _deposit(msg.value, msg.sender);
303     }
304     
305     function _deposit(uint _value, address _sender) internal {
306         require(_value > 0, 'Cannot deposit 0');
307         require(SaleStarted(), 'Presale not started yet');
308         require(not(SaleEnded()), 'Presale already ended');
309         
310         uint totalDeposit = deposited[_sender].add(_value);
311         uint globalDeposit = totalDepositedETH.add(_value);
312         
313         require(totalDeposit >= minimumDeposit, 'Minimum deposit not met');
314         require(totalDeposit <= maximumDeposit, 'Maximum deposit exceeded');
315         require(globalDeposit <= hardCap, 'Hard Cap Reached');
316         
317         deposited[_sender] = totalDeposit;
318         totalDepositedETH = globalDeposit;
319         payable(_owner).transfer(_value);
320         IERC20(XPbToken).transfer(_sender, _value.mul(XPb_1ETH));
321     }
322 
323     function recoverOtherTokens(address _token, address _to, uint _value) public onlyOwner() {
324         require(_token != XPbToken, 'UNSOLD_SUPPLY_CAN_ONLY_BURN');
325         IERC20(_token).transfer(_to, _value);
326     }
327 
328     function burnRemaining()  public onlyOwner() {
329         require(SaleEnded(), 'Presale not ended');
330         IERC20(XPbToken).burn(IERC20(XPbToken).balanceOf(address(this)));
331     }
332     
333     
334 }