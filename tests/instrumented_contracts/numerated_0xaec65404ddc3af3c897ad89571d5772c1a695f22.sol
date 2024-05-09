1 // File: contracts/IERC20.sol
2 
3 pragma solidity 0.5.16;
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 interface IERC20 {
10     function transfer(address to, uint256 value) external returns (bool);
11 
12     function approve(address spender, uint256 value) external returns (bool);
13 
14     function transferFrom(address from, address to, uint256 value) external returns (bool);
15 
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address who) external view returns (uint256);
19 
20     function allowance(address owner, address spender) external view returns (uint256);
21 
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 // File: contracts/SafeMath.sol
28 
29 pragma solidity 0.5.16;
30 
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
46      * @dev Returns the addition of two unsigned integers, reverting on
47      * overflow.
48      *
49      * Counterpart to Solidity's `+` operator.
50      *
51      * Requirements:
52      *
53      * - Addition cannot overflow.
54      */
55     function add(uint256 a, uint256 b) internal pure returns (uint256) {
56         uint256 c = a + b;
57         require(c >= a, "SafeMath: addition overflow");
58 
59         return c;
60     }
61 
62     /**
63      * @dev Returns the subtraction of two unsigned integers, reverting on
64      * overflow (when the result is negative).
65      *
66      * Counterpart to Solidity's `-` operator.
67      *
68      * Requirements:
69      *
70      * - Subtraction cannot overflow.
71      */
72     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
73         return sub(a, b, "SafeMath: subtraction overflow");
74     }
75 
76     /**
77      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
78      * overflow (when the result is negative).
79      *
80      * Counterpart to Solidity's `-` operator.
81      *
82      * Requirements:
83      *
84      * - Subtraction cannot overflow.
85      */
86     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
87         require(b <= a, errorMessage);
88         uint256 c = a - b;
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the multiplication of two unsigned integers, reverting on
95      * overflow.
96      *
97      * Counterpart to Solidity's `*` operator.
98      *
99      * Requirements:
100      *
101      * - Multiplication cannot overflow.
102      */
103     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
104         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
105         // benefit is lost if 'b' is also tested.
106         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
107         if (a == 0) {
108             return 0;
109         }
110 
111         uint256 c = a * b;
112         require(c / a == b, "SafeMath: multiplication overflow");
113 
114         return c;
115     }
116 
117     /**
118      * @dev Returns the integer division of two unsigned integers. Reverts on
119      * division by zero. The result is rounded towards zero.
120      *
121      * Counterpart to Solidity's `/` operator. Note: this function uses a
122      * `revert` opcode (which leaves remaining gas untouched) while Solidity
123      * uses an invalid opcode to revert (consuming all remaining gas).
124      *
125      * Requirements:
126      *
127      * - The divisor cannot be zero.
128      */
129     function div(uint256 a, uint256 b) internal pure returns (uint256) {
130         return div(a, b, "SafeMath: division by zero");
131     }
132 
133     /**
134      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
135      * division by zero. The result is rounded towards zero.
136      *
137      * Counterpart to Solidity's `/` operator. Note: this function uses a
138      * `revert` opcode (which leaves remaining gas untouched) while Solidity
139      * uses an invalid opcode to revert (consuming all remaining gas).
140      *
141      * Requirements:
142      *
143      * - The divisor cannot be zero.
144      */
145     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
146         require(b > 0, errorMessage);
147         uint256 c = a / b;
148         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
149 
150         return c;
151     }
152 
153     /**
154      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
155      * Reverts when dividing by zero.
156      *
157      * Counterpart to Solidity's `%` operator. This function uses a `revert`
158      * opcode (which leaves remaining gas untouched) while Solidity uses an
159      * invalid opcode to revert (consuming all remaining gas).
160      *
161      * Requirements:
162      *
163      * - The divisor cannot be zero.
164      */
165     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
166         return mod(a, b, "SafeMath: modulo by zero");
167     }
168 
169     /**
170      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
171      * Reverts with custom message when dividing by zero.
172      *
173      * Counterpart to Solidity's `%` operator. This function uses a `revert`
174      * opcode (which leaves remaining gas untouched) while Solidity uses an
175      * invalid opcode to revert (consuming all remaining gas).
176      *
177      * Requirements:
178      *
179      * - The divisor cannot be zero.
180      */
181     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
182         require(b != 0, errorMessage);
183         return a % b;
184     }
185 }
186 
187 // File: contracts/ERC20.sol
188 
189 pragma solidity 0.5.16;
190 
191 
192 
193 /**
194  * @title Standard ERC20 token
195  *
196  * @dev Implementation of the basic standard token.
197  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
198  * Originally based on code by FirstBlood:
199  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
200  *
201  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
202  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
203  * compliant implementations may not do it.
204  */
205 contract ERC20 is IERC20 {
206 
207     using SafeMath for uint256;
208 
209     mapping (address => uint256) private _balances;
210 
211     mapping (address => mapping (address => uint256)) private _allowed;
212 
213     uint256 private _totalSupply;
214 
215     /**
216     * @dev Total number of tokens in existence
217     */
218     function totalSupply() public view returns (uint256) {
219         return _totalSupply;
220     }
221 
222     /**
223     * @dev Gets the balance of the specified address.
224     * @param owner The address to query the balance of.
225     * @return An uint256 representing the amount owned by the passed address.
226     */
227     function balanceOf(address owner) public view returns (uint256) {
228         return _balances[owner];
229     }
230 
231     /**
232      * @dev Function to check the amount of tokens that an owner allowed to a spender.
233      * @param owner address The address which owns the funds.
234      * @param spender address The address which will spend the funds.
235      * @return A uint256 specifying the amount of tokens still available for the spender.
236      */
237     function allowance(address owner, address spender) public view returns (uint256) {
238         return _allowed[owner][spender];
239     }
240 
241     /**
242     * @dev Transfer token for a specified address
243     * @param to The address to transfer to.
244     * @param value The amount to be transferred.
245     */
246     function transfer(address to, uint256 value) public returns (bool) {
247         _transfer(msg.sender, to, value);
248         return true;
249     }
250 
251     /**
252      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
253      * Beware that changing an allowance with this method brings the risk that someone may use both the old
254      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
255      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
256      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
257      * @param spender The address which will spend the funds.
258      * @param value The amount of tokens to be spent.
259      */
260     function approve(address spender, uint256 value) public returns (bool) {
261         require(spender != address(0));
262 
263         _allowed[msg.sender][spender] = value;
264         emit Approval(msg.sender, spender, value);
265         return true;
266     }
267 
268     /**
269      * @dev Transfer tokens from one address to another.
270      * Note that while this function emits an Approval event, this is not required as per the specification,
271      * and other compliant implementations may not emit the event.
272      * @param from address The address which you want to send tokens from
273      * @param to address The address which you want to transfer to
274      * @param value uint256 the amount of tokens to be transferred
275      */
276     function transferFrom(address from, address to, uint256 value) public returns (bool) {
277         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
278         _transfer(from, to, value);
279         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
280         return true;
281     }
282 
283     /**
284      * @dev Increase the amount of tokens that an owner allowed to a spender.
285      * approve should be called when allowed_[_spender] == 0. To increment
286      * allowed value is better to use this function to avoid 2 calls (and wait until
287      * the first transaction is mined)
288      * From MonolithDAO Token.sol
289      * Emits an Approval event.
290      * @param spender The address which will spend the funds.
291      * @param addedValue The amount of tokens to increase the allowance by.
292      */
293     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
294         require(spender != address(0));
295 
296         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
297         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
298         return true;
299     }
300 
301     /**
302      * @dev Decrease the amount of tokens that an owner allowed to a spender.
303      * approve should be called when allowed_[_spender] == 0. To decrement
304      * allowed value is better to use this function to avoid 2 calls (and wait until
305      * the first transaction is mined)
306      * From MonolithDAO Token.sol
307      * Emits an Approval event.
308      * @param spender The address which will spend the funds.
309      * @param subtractedValue The amount of tokens to decrease the allowance by.
310      */
311     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
312         require(spender != address(0));
313 
314         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
315         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
316         return true;
317     }
318 
319     /**
320     * @dev Transfer token for a specified addresses
321     * @param from The address to transfer from.
322     * @param to The address to transfer to.
323     * @param value The amount to be transferred.
324     */
325     function _transfer(address from, address to, uint256 value) internal {
326         //require(to != address(0));
327 
328         _balances[from] = _balances[from].sub(value);
329         _balances[to] = _balances[to].add(value);
330         emit Transfer(from, to, value);
331     }
332 
333     /**
334      * @dev Internal function that init an amount of the token and assigns it to
335      * an account. This encapsulates the modification of balances such that the
336      * proper events are emitted.
337      * @param account The account that will receive the created tokens.
338      * @param value The amount that will be created.
339      */
340     function _init(address account, uint256 value) internal {
341         require(account != address(0));
342         _totalSupply = _totalSupply.add(value);
343         _balances[account] = _balances[account].add(value);
344         emit Transfer(address(0), account, value);
345     }
346 }
347 
348 // File: contracts/PnxToken.sol
349 
350 pragma solidity 0.5.16;
351 
352 
353 contract PnxToken is ERC20{
354     using SafeMath for uint;
355 
356     string private _name = "Phoenix Token";
357     string private _symbol = "PHX";
358 
359     uint8 private _decimals = 18;
360 
361     address private _initiator;
362 
363     /// FinNexus total tokens supply
364     uint public MAX_TOTAL_TOKEN_AMOUNT = 176406168 ether;
365 
366     constructor(address initiator,address operator)public{
367         _initiator = initiator;
368         _init(initiator,MAX_TOTAL_TOKEN_AMOUNT);
369     }
370 
371     /**
372      * @return the name of the token.
373      */
374     function name() public view returns (string memory) {
375         return _name;
376     }
377 
378     /**
379      * @return the symbol of the token.
380      */
381     function symbol() public view returns (string memory) {
382         return _symbol;
383     }
384 
385     /**
386      * @return the number of decimals of the token.
387      */
388     function decimals() public view returns (uint8) {
389         return _decimals;
390     }
391 
392 
393 }