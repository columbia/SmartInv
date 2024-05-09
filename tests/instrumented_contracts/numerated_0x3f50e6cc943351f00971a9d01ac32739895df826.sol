1 pragma solidity ^0.4.24;
2 
3 // File: contracts/token/IERC20.sol
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 interface IERC20 {
10     function totalSupply() external view returns (uint256);
11 
12     function balanceOf(address who) external view returns (uint256);
13 
14     function allowance(address owner, address spender) external view returns (uint256);
15 
16     function transfer(address to, uint256 value) external returns (bool);
17 
18     function approve(address spender, uint256 value) external returns (bool);
19 
20     function transferFrom(address from, address to, uint256 value) external returns (bool);
21 
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 // File: contracts/misc/SafeMath.sol
28 
29 /**
30  * @title SafeMath
31  * @dev Math operations with safety checks that revert on error
32  */
33 library SafeMath {
34     int256 constant private INT256_MIN = -2**255;
35 
36     /**
37     * @dev Multiplies two unsigned integers, reverts on overflow.
38     */
39     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
41         // benefit is lost if 'b' is also tested.
42         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
43         if (a == 0) {
44             return 0;
45         }
46 
47         uint256 c = a * b;
48         require(c / a == b);
49 
50         return c;
51     }
52 
53     /**
54     * @dev Multiplies two signed integers, reverts on overflow.
55     */
56     function mul(int256 a, int256 b) internal pure returns (int256) {
57         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
58         // benefit is lost if 'b' is also tested.
59         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
60         if (a == 0) {
61             return 0;
62         }
63 
64         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
65 
66         int256 c = a * b;
67         require(c / a == b);
68 
69         return c;
70     }
71 
72     /**
73     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
74     */
75     function div(uint256 a, uint256 b) internal pure returns (uint256) {
76         // Solidity only automatically asserts when dividing by 0
77         require(b > 0);
78         uint256 c = a / b;
79         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
80 
81         return c;
82     }
83 
84     /**
85     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
86     */
87     function div(int256 a, int256 b) internal pure returns (int256) {
88         require(b != 0); // Solidity only automatically asserts when dividing by 0
89         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
90 
91         int256 c = a / b;
92 
93         return c;
94     }
95 
96     /**
97     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
98     */
99     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
100         require(b <= a);
101         uint256 c = a - b;
102 
103         return c;
104     }
105 
106     /**
107     * @dev Subtracts two signed integers, reverts on overflow.
108     */
109     function sub(int256 a, int256 b) internal pure returns (int256) {
110         int256 c = a - b;
111         require((b >= 0 && c <= a) || (b < 0 && c > a));
112 
113         return c;
114     }
115 
116     /**
117     * @dev Adds two unsigned integers, reverts on overflow.
118     */
119     function add(uint256 a, uint256 b) internal pure returns (uint256) {
120         uint256 c = a + b;
121         require(c >= a);
122 
123         return c;
124     }
125 
126     /**
127     * @dev Adds two signed integers, reverts on overflow.
128     */
129     function add(int256 a, int256 b) internal pure returns (int256) {
130         int256 c = a + b;
131         require((b >= 0 && c >= a) || (b < 0 && c < a));
132 
133         return c;
134     }
135 
136     /**
137     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
138     * reverts when dividing by zero.
139     */
140     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
141         require(b != 0);
142         return a % b;
143     }
144 }
145 
146 // File: contracts/token/ERC20.sol
147 
148 /**
149  * @title Standard ERC20 token
150  *
151  * @dev Implementation of the basic standard token.
152  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
153  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
154  *
155  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
156  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
157  * compliant implementations may not do it.
158  */
159 contract ERC20 is IERC20 {
160     using SafeMath for uint256;
161 
162     mapping (address => uint256) private _balances;
163 
164     mapping (address => mapping (address => uint256)) private _allowed;
165 
166     uint256 private _totalSupply;
167 
168     /**
169     * @dev Total number of tokens in existence
170     */
171     function totalSupply() public view returns (uint256) {
172         return _totalSupply;
173     }
174 
175     /**
176     * @dev Gets the balance of the specified address.
177     * @param owner The address to query the balance of.
178     * @return An uint256 representing the amount owned by the passed address.
179     */
180     function balanceOf(address owner) public view returns (uint256) {
181         return _balances[owner];
182     }
183 
184     /**
185      * @dev Function to check the amount of tokens that an owner allowed to a spender.
186      * @param owner address The address which owns the funds.
187      * @param spender address The address which will spend the funds.
188      * @return A uint256 specifying the amount of tokens still available for the spender.
189      */
190     function allowance(address owner, address spender) public view returns (uint256) {
191         return _allowed[owner][spender];
192     }
193 
194     /**
195     * @dev Transfer token for a specified address
196     * @param to The address to transfer to.
197     * @param value The amount to be transferred.
198     */
199     function transfer(address to, uint256 value) public returns (bool) {
200         _transfer(msg.sender, to, value);
201         return true;
202     }
203 
204     /**
205      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
206      * Beware that changing an allowance with this method brings the risk that someone may use both the old
207      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
208      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
209      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
210      * @param spender The address which will spend the funds.
211      * @param value The amount of tokens to be spent.
212      */
213     function approve(address spender, uint256 value) public returns (bool) {
214         require(spender != address(0), "Cannot approve for 0x0 address");
215 
216         _allowed[msg.sender][spender] = value;
217         emit Approval(msg.sender, spender, value);
218         return true;
219     }
220 
221     /**
222      * @dev Transfer tokens from one address to another.
223      * Note that while this function emits an Approval event, this is not required as per the specification,
224      * and other compliant implementations may not emit the event.
225      * @param from address The address which you want to send tokens from
226      * @param to address The address which you want to transfer to
227      * @param value uint256 the amount of tokens to be transferred
228      */
229     function transferFrom(address from, address to, uint256 value) public returns (bool) {
230         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
231         _transfer(from, to, value);
232         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
233         return true;
234     }
235 
236     /**
237      * @dev Increase the amount of tokens that an owner allowed to a spender.
238      * approve should be called when allowed_[_spender] == 0. To increment
239      * allowed value is better to use this function to avoid 2 calls (and wait until
240      * the first transaction is mined)
241      * From MonolithDAO Token.sol
242      * Emits an Approval event.
243      * @param spender The address which will spend the funds.
244      * @param addedValue The amount of tokens to increase the allowance by.
245      */
246     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
247         require(spender != address(0), "Cannot increaseAllowance for 0x0 address");
248 
249         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
250         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
251         return true;
252     }
253 
254     /**
255      * @dev Decrease the amount of tokens that an owner allowed to a spender.
256      * approve should be called when allowed_[_spender] == 0. To decrement
257      * allowed value is better to use this function to avoid 2 calls (and wait until
258      * the first transaction is mined)
259      * From MonolithDAO Token.sol
260      * Emits an Approval event.
261      * @param spender The address which will spend the funds.
262      * @param subtractedValue The amount of tokens to decrease the allowance by.
263      */
264     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
265         require(spender != address(0), "Cannot decreaseAllowance for 0x0 address");
266 
267         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
268         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
269         return true;
270     }
271 
272     /**
273     * @dev Transfer token for a specified addresses
274     * @param from The address to transfer from.
275     * @param to The address to transfer to.
276     * @param value The amount to be transferred.
277     */
278     function _transfer(address from, address to, uint256 value) internal {
279         require(to != address(0), "Cannot transfer to 0x0 address");
280 
281         _balances[from] = _balances[from].sub(value);
282         _balances[to] = _balances[to].add(value);
283         emit Transfer(from, to, value);
284     }
285 
286     /**
287      * @dev Internal function that mints an amount of the token and assigns it to
288      * an account. This encapsulates the modification of balances such that the
289      * proper events are emitted.
290      * @param account The account that will receive the created tokens.
291      * @param value The amount that will be created.
292      */
293     function _mint(address account, uint256 value) internal {
294         require(account != address(0), "Cannot mint to 0x0 address");
295 
296         _totalSupply = _totalSupply.add(value);
297         _balances[account] = _balances[account].add(value);
298         emit Transfer(address(0), account, value);
299     }
300 }
301 
302 // File: contracts\CoineruGold.sol
303 
304 /**
305  * @title CoineruGold
306  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
307  * Note they can later distribute these tokens as they wish using `transfer` and other
308  * `ERC20` functions.
309  */
310 contract CoineruGold is ERC20 {
311     string public constant name = "Coineru Gold";
312     string public constant symbol = "CGLD";
313     uint8 public constant decimals = 8;
314 
315     // twenty six billions + 8 decimals
316     uint256 public constant INITIAL_SUPPLY = 26000000000 * (10 ** uint256(decimals));
317 
318     /**
319      * @dev Constructor that gives msg.sender all of existing tokens.
320      */
321     constructor () public {
322         _mint(msg.sender, INITIAL_SUPPLY);
323     }
324 }