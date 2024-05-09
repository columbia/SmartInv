1 /**
2  * @title SafeMath
3  * Decimals : 18
4  * TotalSupply : 40,000 iYearnFinance
5  * Source By MIT License 
6  **/
7 
8 pragma solidity ^0.4.26;
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with GSN meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19  
20 contract  IYFII {
21    
22     uint256 public totalSupply;
23 
24      /**
25      * @dev Returns the amount of tokens owned by `account`.
26      */
27     function balanceOf(address _owner) public view returns (uint256 balance);
28 
29     /**
30      * @dev Emitted when `value` tokens are moved from one account (`from`) to
31      * another (`to`).
32      *
33      * Note that `value` may be zero.
34      */
35     function transfer(address _to, uint256 _value) public returns (bool success);
36     /**
37      * @dev Moves `amount` tokens from `sender` to `recipient` using the
38      * allowance mechanism. `amount` is then deducted from the caller's
39      * allowance.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * Emits a {Transfer} event.
44      */
45 
46     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
47     /**
48      * @dev Returns the remaining number of tokens that `spender` will be
49      * allowed to spend on behalf of `owner` through {transferFrom}. This is
50      * zero by default.
51      *
52      * This value changes when {approve} or {transferFrom} are called.
53      */
54     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
55         /**
56      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
57      * a call to {approve}. `value` is the new allowance.
58      */
59     function approve(address _spender, uint256 _value) public returns (bool success);
60 
61 
62 
63 
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed _from, address indexed _to, uint256 _value);
71     
72         /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to {approve}. `value` is the new allowance.
75      */
76     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
77 }
78 /**
79  * @dev Wrappers over Solidity's arithmetic operations with added overflow
80  * checks.
81  *
82  * Arithmetic operations in Solidity wrap on overflow. This can easily result
83  * in bugs, because programmers usually assume that an overflow raises an
84  * error, which is the standard behavior in high level programming languages.
85  * `SafeMath` restores this intuition by reverting the transaction when an
86  * operation overflows.
87  *
88  * Using this library instead of the unchecked operations eliminates an entire
89  * class of bugs, so it's recommended to use it always.
90  */
91 library SafeMath {
92     /**
93      * @dev Returns the integer division of two unsigned integers. Reverts on
94      * division by zero. The result is rounded towards zero.
95      *
96      * Counterpart to Solidity's `/` operator. Note: this function uses a
97      * `revert` opcode (which leaves remaining gas untouched) while Solidity
98      * uses an invalid opcode to revert (consuming all remaining gas).
99      *
100      * Requirements:
101      *
102      * - The divisor cannot be zero.
103      */
104     function div(uint256 a, uint256 b) internal pure returns (uint256) {
105     require(b > 0); 
106     uint256 c = a / b;
107 
108 
109     return c;
110   }
111   
112       /**
113      * @dev Returns the multiplication of two unsigned integers, reverting on
114      * overflow.
115      *
116      * Counterpart to Solidity's `*` operator.
117      *
118      * Requirements:
119      *
120      * - Multiplication cannot overflow.
121      */
122   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
123 
124     if (a == 0) {
125       return 0;
126     }
127 
128     uint256 c = a * b;
129     require(c / a == b);
130 
131     return c;
132   }
133 
134 
135 
136     /**
137      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
138      * overflow (when the result is negative).
139      *
140      * Counterpart to Solidity's `-` operator.
141      *
142      * Requirements:
143      *
144      * - Subtraction cannot overflow.
145      */
146      
147   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
148     require(b <= a);
149     uint256 c = a - b;
150 
151     return c;
152   }
153 
154     /**
155      * @dev Returns the addition of two unsigned integers, reverting on
156      * overflow.
157      *
158      * Counterpart to Solidity's `+` operator.
159      *
160      * Requirements:
161      *
162      * - Addition cannot overflow.
163      */
164   function add(uint256 a, uint256 b) internal pure returns (uint256) {
165     uint256 c = a + b;
166     require(c >= a);
167 
168     return c;
169   }
170 
171     /**
172      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
173      * Reverts when dividing by zero.
174      *
175      * Counterpart to Solidity's `%` operator. This function uses a `revert`
176      * opcode (which leaves remaining gas untouched) while Solidity uses an
177      * invalid opcode to revert (consuming all remaining gas).
178      *
179      * Requirements:
180      *
181      * - The divisor cannot be zero.
182      */
183   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
184     require(b != 0);
185     return a % b;
186   }
187 }
188 
189 /**
190  * @dev Implementation of the {IERC20} interface.
191  *
192  * This implementation is agnostic to the way tokens are created. This means
193  * that a supply mechanism has to be added in a derived contract using {_mint}.
194  * For a generic mechanism see {ERC20PresetMinterPauser}.
195  *
196  * TIP: For a detailed writeup see our guide
197  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
198  * to implement supply mechanisms].
199  *
200  * We have followed general OpenZeppelin guidelines: functions revert instead
201  * of returning `false` on failure. This behavior is nonetheless conventional
202  * and does not conflict with the expectations of ERC20 applications.
203  *
204  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
205  * This allows applications to reconstruct the allowance for all accounts just
206  * by listening to said events. Other implementations of the EIP may not emit
207  * these events, as it isn't required by the specification.
208  *
209  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
210  * functions have been added to mitigate the well-known issues around setting
211  * allowances. See {IERC20-approve}.
212  */
213  
214 contract IYFI is IYFII {
215     using SafeMath for uint256;
216 
217     mapping (address => uint256) public balances;
218     mapping (address => mapping (address => uint256)) public allowed;
219 
220     /**
221      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
222      * a default value of 18.
223      *
224      * To select a different value for {decimals}, use {_setupDecimals}.
225      *
226      * All three of these values are immutable: they can only be set once during
227      * construction.
228      */
229      
230     string public name;                   
231     uint8 public decimals;                
232     string public symbol;                 
233 
234     function IYFI(
235         uint256 _initialAmount,
236         string _tokenName,
237         uint8 _decimalUnits,
238         string _tokenSymbol
239     ) public {
240         balances[msg.sender] = _initialAmount;               
241         totalSupply = _initialAmount;                       
242         name = _tokenName;                                  
243         decimals = _decimalUnits;                            
244         symbol = _tokenSymbol;                             
245     }
246 
247     function transfer(address _to, uint256 _value) public returns (bool success) {
248         require(_to != address(0));
249         require(balances[msg.sender] >= _value);
250       
251         balances[msg.sender] = balances[msg.sender].sub(_value);
252   
253         balances[_to] = balances[_to].add(_value);
254         emit Transfer(msg.sender, _to, _value); 
255         return true;
256     }
257     /**
258      * @dev See {IERC20-transferFrom}.
259      *
260      * Emits an {Approval} event indicating the updated allowance. This is not
261      * required by the EIP. See the note at the beginning of {ERC20};
262      *
263      * Requirements:
264      * - `sender` and `recipient` cannot be the zero address.
265      * - `sender` must have a balance of at least `amount`.
266      * - the caller must have allowance for ``sender``'s tokens of at least
267      * `amount`.
268      */
269     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
270         uint256 allowance = allowed[_from][msg.sender];
271         require(balances[_from] >= _value && allowance >= _value);
272         require(_to != address(0));
273       
274         balances[_to] = balances[_to].add(_value);
275  
276         balances[_from] = balances[_from].sub(_value);
277 
278         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
279  
280         emit Transfer(_from, _to, _value); 
281         return true;
282     }
283     /**
284      * @dev See {IERC20-balanceOf}.
285      */
286     function balanceOf(address _owner) public view returns (uint256 balance) {
287         return balances[_owner];
288     }
289     /**
290      * @dev See {IERC20-approve}.
291      *
292      * Requirements:
293      *
294      * - `spender` cannot be the zero address.
295      */
296     function approve(address _spender, uint256 _value) public returns (bool success) {
297         require(_spender != address(0));
298         allowed[msg.sender][_spender] = _value;
299         emit Approval(msg.sender, _spender, _value); 
300         return true;
301     }
302     /**
303      * @dev See {IERC20-allowance}.
304      */
305     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
306         require(_spender != address(0));
307         return allowed[_owner][_spender];
308     }
309 }