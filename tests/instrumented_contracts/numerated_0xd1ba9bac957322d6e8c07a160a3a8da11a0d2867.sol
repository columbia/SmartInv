1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.2;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      *
27      * - Addition cannot overflow.
28      */
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32 
33         return c;
34     }
35 
36     /**
37      * @dev Returns the subtraction of two unsigned integers, reverting on
38      * overflow (when the result is negative).
39      *
40      * Counterpart to Solidity's `-` operator.
41      *
42      * Requirements:
43      *
44      * - Subtraction cannot overflow.
45      */
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, "SafeMath: subtraction overflow");
48     }
49 
50     /**
51      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
52      * overflow (when the result is negative).
53      *
54      * Counterpart to Solidity's `-` operator.
55      *
56      * Requirements:
57      *
58      * - Subtraction cannot overflow.
59      */
60     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b <= a, errorMessage);
62         uint256 c = a - b;
63 
64         return c;
65     }
66 
67     /**
68      * @dev Returns the multiplication of two unsigned integers, reverting on
69      * overflow.
70      *
71      * Counterpart to Solidity's `*` operator.
72      *
73      * Requirements:
74      *
75      * - Multiplication cannot overflow.
76      */
77     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
79         // benefit is lost if 'b' is also tested.
80         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
81         if (a == 0) {
82             return 0;
83         }
84 
85         uint256 c = a * b;
86         require(c / a == b, "SafeMath: multiplication overflow");
87 
88         return c;
89     }
90 
91     /**
92      * @dev Returns the integer division of two unsigned integers. Reverts on
93      * division by zero. The result is rounded towards zero.
94      *
95      * Counterpart to Solidity's `/` operator. Note: this function uses a
96      * `revert` opcode (which leaves remaining gas untouched) while Solidity
97      * uses an invalid opcode to revert (consuming all remaining gas).
98      *
99      * Requirements:
100      *
101      * - The divisor cannot be zero.
102      */
103     function div(uint256 a, uint256 b) internal pure returns (uint256) {
104         return div(a, b, "SafeMath: division by zero");
105     }
106 
107     /**
108      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
109      * division by zero. The result is rounded towards zero.
110      *
111      * Counterpart to Solidity's `/` operator. Note: this function uses a
112      * `revert` opcode (which leaves remaining gas untouched) while Solidity
113      * uses an invalid opcode to revert (consuming all remaining gas).
114      *
115      * Requirements:
116      *
117      * - The divisor cannot be zero.
118      */
119     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
120         require(b > 0, errorMessage);
121         uint256 c = a / b;
122         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
129      * Reverts when dividing by zero.
130      *
131      * Counterpart to Solidity's `%` operator. This function uses a `revert`
132      * opcode (which leaves remaining gas untouched) while Solidity uses an
133      * invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
140         return mod(a, b, "SafeMath: modulo by zero");
141     }
142 
143     /**
144      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
145      * Reverts with custom message when dividing by zero.
146      *
147      * Counterpart to Solidity's `%` operator. This function uses a `revert`
148      * opcode (which leaves remaining gas untouched) while Solidity uses an
149      * invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      *
153      * - The divisor cannot be zero.
154      */
155     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
156         require(b != 0, errorMessage);
157         return a % b;
158     }
159 }
160 
161 interface HMTokenInterface {
162 
163     event Transfer(address indexed _from, address indexed _to, uint256 _value);
164     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
165 
166     /// @param _owner The address from which the balance will be retrieved
167     /// @return balance The balance
168     function balanceOf(address _owner) external view returns (uint256 balance);
169 
170     /// @notice send `_value` token to `_to` from `msg.sender`
171     /// @param _to The address of the recipient
172     /// @param _value The amount of token to be transferred
173     /// @return success Whether the transfer was successful or not
174     function transfer(address _to, uint256 _value) external returns (bool success);
175 
176     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
177     /// @param _from The address of the sender
178     /// @param _to The address of the recipient
179     /// @param _value The amount of token to be transferred
180     /// @return success Whether the transfer was successful or not
181     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
182 
183     function transferBulk(address[] calldata _tos, uint256[] calldata _values, uint256 _txId) external returns (uint256 _bulkCount);
184 
185     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
186     /// @param _spender The address of the account able to transfer the tokens
187     /// @param _value The amount of tokens to be approved for transfer
188     /// @return success Whether the approval was successful or not
189     function approve(address _spender, uint256 _value) external returns (bool success);
190 
191     /// @param _owner The address of the account owning tokens
192     /// @param _spender The address of the account able to transfer the tokens
193     /// @return remaining Amount of remaining tokens allowed to spent
194     function allowance(address _owner, address _spender) external view returns (uint256 remaining);
195 }
196 
197 contract HMToken is HMTokenInterface {
198     using SafeMath for uint256;
199 
200     /* This is a slight change to the ERC20 base standard.
201     function totalSupply() constant returns (uint256 supply);
202     is replaced with:
203     uint256 public totalSupply;
204     This automatically creates a getter function for the totalSupply.
205     This is moved to the base contract since public getter functions are not
206     currently recognised as an implementation of the matching abstract
207     function by the compiler.
208     */
209     /// total amount of tokens
210     uint256 public totalSupply;
211 
212     uint256 private constant MAX_UINT256 = ~uint256(0);
213     uint256 private constant BULK_MAX_VALUE = 1000000000 * (10 ** 18);
214     uint32  private constant BULK_MAX_COUNT = 100;
215 
216     event BulkTransfer(uint256 indexed _txId, uint256 _bulkCount);
217     event BulkApproval(uint256 indexed _txId, uint256 _bulkCount);
218 
219     mapping (address => uint256) private balances;
220     mapping (address => mapping (address => uint256)) private allowed;
221 
222     string public name;
223     uint8 public decimals;
224     string public symbol;
225 
226     constructor(uint256 _totalSupply, string memory _name, uint8 _decimals, string memory _symbol) public {
227         totalSupply = _totalSupply * (10 ** uint256(_decimals));
228         name = _name;
229         decimals = _decimals;
230         symbol = _symbol;
231         balances[msg.sender] = totalSupply;
232     }
233 
234     function transfer(address _to, uint256 _value) public override returns (bool success) {
235         success = transferQuiet(_to, _value);
236         require(success, "Transfer didn't succeed");
237         return success;
238     }
239 
240     function transferFrom(address _spender, address _to, uint256 _value) public override returns (bool success) {
241         uint256 _allowance = allowed[_spender][msg.sender];
242         require(_allowance >= _value, "Spender allowance too low");
243         require(_to != address(0), "Can't send tokens to uninitialized address");
244 
245         balances[_spender] = balances[_spender].sub(_value, "Spender balance too low");
246         balances[_to] = balances[_to].add(_value);
247 
248         if (_allowance != MAX_UINT256) { // Special case to approve unlimited transfers
249             allowed[_spender][msg.sender] = allowed[_spender][msg.sender].sub(_value);
250         }
251 
252         emit Transfer(_spender, _to, _value);
253         return true;
254     }
255 
256     function balanceOf(address _owner) public view override returns (uint256 balance) {
257         return balances[_owner];
258     }
259 
260     function approve(address _spender, uint256 _value) public override returns (bool success) {
261         require(_spender != address(0), "Token spender is an uninitialized address");
262 
263         allowed[msg.sender][_spender] = _value;
264         emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
265         return true;
266     }
267 
268     function increaseApproval(address _spender, uint _delta) public returns (bool success) {
269         require(_spender != address(0), "Token spender is an uninitialized address");
270 
271         uint _oldValue = allowed[msg.sender][_spender];
272         if (_oldValue.add(_delta) < _oldValue || _oldValue.add(_delta) >= MAX_UINT256) { // Truncate upon overflow.
273             allowed[msg.sender][_spender] = MAX_UINT256.sub(1);
274         } else {
275             allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_delta);
276         }
277         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
278         return true;
279     }
280 
281     function decreaseApproval(address _spender, uint _delta) public returns (bool success) {
282         require(_spender != address(0), "Token spender is an uninitialized address");
283 
284         uint _oldValue = allowed[msg.sender][_spender];
285         if (_delta > _oldValue) { // Truncate upon overflow.
286             allowed[msg.sender][_spender] = 0;
287         } else {
288             allowed[msg.sender][_spender] = allowed[msg.sender][_spender].sub(_delta);
289         }
290         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
291         return true;
292     }
293 
294     function allowance(address _owner, address _spender) public view override returns (uint256 remaining) {
295         return allowed[_owner][_spender];
296     }
297 
298     function transferBulk(address[] memory _tos, uint256[] memory _values, uint256 _txId) public override returns (uint256 _bulkCount) {
299         require(_tos.length == _values.length, "Amount of recipients and values don't match");
300         require(_tos.length < BULK_MAX_COUNT, "Too many recipients");
301 
302         uint256 _bulkValue = 0;
303         for (uint j = 0; j < _tos.length; ++j) {
304             _bulkValue = _bulkValue.add(_values[j]);
305         }
306         require(_bulkValue < BULK_MAX_VALUE, "Bulk value too high");
307 
308         bool _success;
309         for (uint i = 0; i < _tos.length; ++i) {
310             _success = transferQuiet(_tos[i], _values[i]);
311             if (_success) {
312                 _bulkCount = _bulkCount.add(1);
313             }
314         }
315         emit BulkTransfer(_txId, _bulkCount);
316         return _bulkCount;
317     }
318 
319     function approveBulk(address[] memory _spenders, uint256[] memory _values, uint256 _txId) public returns (uint256 _bulkCount) {
320         require(_spenders.length == _values.length, "Amount of spenders and values don't match");
321         require(_spenders.length < BULK_MAX_COUNT, "Too many spenders");
322 
323         uint256 _bulkValue = 0;
324         for (uint j = 0; j < _spenders.length; ++j) {
325             _bulkValue = _bulkValue.add(_values[j]);
326         }
327         require(_bulkValue < BULK_MAX_VALUE, "Bulk value too high");
328 
329         bool _success;
330         for (uint i = 0; i < _spenders.length; ++i) {
331             _success = increaseApproval(_spenders[i], _values[i]);
332             if (_success) {
333                 _bulkCount = _bulkCount.add(1);
334             }
335         }
336         emit BulkApproval(_txId, _bulkCount);
337         return _bulkCount;
338     }
339 
340     // Like transfer, but fails quietly.
341     function transferQuiet(address _to, uint256 _value) internal returns (bool success) {
342         if (_to == address(0)) return false; // Preclude burning tokens to uninitialized address.
343         if (_to == address(this)) return false; // Preclude sending tokens to the contract.
344         if (balances[msg.sender] < _value) return false;
345 
346         balances[msg.sender] = balances[msg.sender] - _value;
347         balances[_to] = balances[_to].add(_value);
348 
349         emit Transfer(msg.sender, _to, _value);
350         return true;
351     }
352 }