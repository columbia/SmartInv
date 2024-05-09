1 /**
2 
3 ██╗    ██╗██████╗ ███████╗███╗   ███╗ █████╗ ██████╗ ████████╗ ██████╗ ██████╗ ███╗   ██╗████████╗██████╗  █████╗  ██████╗████████╗███████╗    ██████╗ ██████╗ ███╗   ███╗
4 ██║    ██║██╔══██╗██╔════╝████╗ ████║██╔══██╗██╔══██╗╚══██╔══╝██╔════╝██╔═══██╗████╗  ██║╚══██╔══╝██╔══██╗██╔══██╗██╔════╝╚══██╔══╝██╔════╝   ██╔════╝██╔═══██╗████╗ ████║
5 ██║ █╗ ██║██████╔╝███████╗██╔████╔██║███████║██████╔╝   ██║   ██║     ██║   ██║██╔██╗ ██║   ██║   ██████╔╝███████║██║        ██║   ███████╗   ██║     ██║   ██║██╔████╔██║
6 ██║███╗██║██╔═══╝ ╚════██║██║╚██╔╝██║██╔══██║██╔══██╗   ██║   ██║     ██║   ██║██║╚██╗██║   ██║   ██╔══██╗██╔══██║██║        ██║   ╚════██║   ██║     ██║   ██║██║╚██╔╝██║
7 ╚███╔███╔╝██║     ███████║██║ ╚═╝ ██║██║  ██║██║  ██║   ██║   ╚██████╗╚██████╔╝██║ ╚████║   ██║   ██║  ██║██║  ██║╚██████╗   ██║   ███████║██╗╚██████╗╚██████╔╝██║ ╚═╝ ██║
8  ╚══╝╚══╝ ╚═╝     ╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝    ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝   ╚═╝   ╚══════╝╚═╝ ╚═════╝ ╚═════╝ ╚═╝     ╚═╝
9 
10 Blockchain Made Easy
11 
12 http://wpsmartcontracts.com/
13 
14 */
15 
16 pragma solidity ^0.5.7;
17 
18 /**
19  * @title SafeMath
20  * @dev Math operations with safety checks that revert on error
21  */
22 library SafeMath {
23     
24     int256 constant private INT256_MIN = -2**255;
25 
26     /**
27     * @dev Multiplies two unsigned integers, reverts on overflow.
28     */
29     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
30         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
31         // benefit is lost if 'b' is also tested.
32         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
33         if (a == 0) {
34             return 0;
35         }
36 
37         uint256 c = a * b;
38         require(c / a == b);
39 
40         return c;
41     }
42 
43     /**
44     * @dev Multiplies two signed integers, reverts on overflow.
45     */
46     function mul(int256 a, int256 b) internal pure returns (int256) {
47         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
48         // benefit is lost if 'b' is also tested.
49         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
50         if (a == 0) {
51             return 0;
52         }
53 
54         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
55 
56         int256 c = a * b;
57         require(c / a == b);
58 
59         return c;
60     }
61 
62     /**
63     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
64     */
65     function div(uint256 a, uint256 b) internal pure returns (uint256) {
66         // Solidity only automatically asserts when dividing by 0
67         require(b > 0);
68         uint256 c = a / b;
69         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70 
71         return c;
72     }
73 
74     /**
75     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
76     */
77     function div(int256 a, int256 b) internal pure returns (int256) {
78         require(b != 0); // Solidity only automatically asserts when dividing by 0
79         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
80 
81         int256 c = a / b;
82 
83         return c;
84     }
85 
86     /**
87     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
88     */
89     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
90         require(b <= a);
91         uint256 c = a - b;
92 
93         return c;
94     }
95 
96     /**
97     * @dev Subtracts two signed integers, reverts on overflow.
98     */
99     function sub(int256 a, int256 b) internal pure returns (int256) {
100         int256 c = a - b;
101         require((b >= 0 && c <= a) || (b < 0 && c > a));
102 
103         return c;
104     }
105 
106     /**
107     * @dev Adds two unsigned integers, reverts on overflow.
108     */
109     function add(uint256 a, uint256 b) internal pure returns (uint256) {
110         uint256 c = a + b;
111         require(c >= a);
112 
113         return c;
114     }
115 
116     /**
117     * @dev Adds two signed integers, reverts on overflow.
118     */
119     function add(int256 a, int256 b) internal pure returns (int256) {
120         int256 c = a + b;
121         require((b >= 0 && c >= a) || (b < 0 && c < a));
122 
123         return c;
124     }
125 
126     /**
127     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
128     * reverts when dividing by zero.
129     */
130     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
131         require(b != 0);
132         return a % b;
133     }
134 }
135 
136 /**
137  * @title ERC20 interface
138  * @dev see https://github.com/ethereum/EIPs/issues/20
139  */
140 interface IERC20 {
141     function totalSupply() external view returns (uint256);
142 
143     function balanceOf(address who) external view returns (uint256);
144 
145     function allowance(address owner, address spender) external view returns (uint256);
146 
147     function transfer(address to, uint256 value) external returns (bool);
148 
149     function approve(address spender, uint256 value) external returns (bool);
150 
151     function transferFrom(address from, address to, uint256 value) external returns (bool);
152 
153     event Transfer(address indexed from, address indexed to, uint256 value);
154 
155     event Approval(address indexed owner, address indexed spender, uint256 value);
156 }
157 
158 contract ERC20Pistachio is IERC20 {
159 
160     using SafeMath for uint256;
161 
162     mapping (address => uint256) private _balances;
163 
164     mapping (address => mapping (address => uint256)) private _allowed;
165 
166     uint256 private _totalSupply;
167 
168     /**
169     * @dev Public parameters to define the token
170     */
171 
172     // Token symbol (short)
173     string public symbol;
174 
175     // Token name (Long)
176     string public  name;
177 
178     // Decimals (18 maximum)
179     uint8 public decimals;
180 
181     /**
182     * @dev Public functions to make the contract accesible
183     */
184     constructor (address initialAccount, string memory _tokenSymbol, string memory _tokenName, uint256 initialBalance) public {
185 
186         // Initialize Contract Parameters
187         symbol = _tokenSymbol;
188         name = _tokenName;
189         decimals = 18;  // default decimals is going to be 18 always
190 
191         _mint(initialAccount, initialBalance);
192         
193     }
194 
195     /**
196     * @dev Total number of tokens in existence
197     */
198     function totalSupply() public view returns (uint256) {
199         return _totalSupply;
200     }
201 
202     /**
203     * @dev Gets the balance of the specified address.
204     * @param owner The address to query the balance of.
205     * @return An uint256 representing the amount owned by the passed address.
206     */
207     function balanceOf(address owner) public view returns (uint256) {
208         return _balances[owner];
209     }
210 
211     /**
212      * @dev Function to check the amount of tokens that an owner allowed to a spender.
213      * @param owner address The address which owns the funds.
214      * @param spender address The address which will spend the funds.
215      * @return A uint256 specifying the amount of tokens still available for the spender.
216      */
217     function allowance(address owner, address spender) public view returns (uint256) {
218         return _allowed[owner][spender];
219     }
220 
221     /**
222     * @dev Transfer token for a specified address
223     * @param to The address to transfer to.
224     * @param value The amount to be transferred.
225     */
226     function transfer(address to, uint256 value) public returns (bool) {
227         _transfer(msg.sender, to, value);
228         return true;
229     }
230 
231     /**
232      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
233      * Beware that changing an allowance with this method brings the risk that someone may use both the old
234      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
235      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
236      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
237      * @param spender The address which will spend the funds.
238      * @param value The amount of tokens to be spent.
239      */
240     function approve(address spender, uint256 value) public returns (bool) {
241         require(spender != address(0));
242 
243         _allowed[msg.sender][spender] = value;
244         emit Approval(msg.sender, spender, value);
245         return true;
246     }
247 
248     /**
249      * @dev Transfer tokens from one address to another.
250      * Note that while this function emits an Approval event, this is not required as per the specification,
251      * and other compliant implementations may not emit the event.
252      * @param from address The address which you want to send tokens from
253      * @param to address The address which you want to transfer to
254      * @param value uint256 the amount of tokens to be transferred
255      */
256     function transferFrom(address from, address to, uint256 value) public returns (bool) {
257         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
258         _transfer(from, to, value);
259         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
260         return true;
261     }
262 
263     /**
264      * @dev Increase the amount of tokens that an owner allowed to a spender.
265      * approve should be called when allowed_[_spender] == 0. To increment
266      * allowed value is better to use this function to avoid 2 calls (and wait until
267      * the first transaction is mined)
268      * From MonolithDAO Token.sol
269      * Emits an Approval event.
270      * @param spender The address which will spend the funds.
271      * @param addedValue The amount of tokens to increase the allowance by.
272      */
273     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
274         require(spender != address(0));
275 
276         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
277         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
278         return true;
279     }
280 
281     /**
282      * @dev Decrease the amount of tokens that an owner allowed to a spender.
283      * approve should be called when allowed_[_spender] == 0. To decrement
284      * allowed value is better to use this function to avoid 2 calls (and wait until
285      * the first transaction is mined)
286      * From MonolithDAO Token.sol
287      * Emits an Approval event.
288      * @param spender The address which will spend the funds.
289      * @param subtractedValue The amount of tokens to decrease the allowance by.
290      */
291     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
292         require(spender != address(0));
293 
294         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
295         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
296         return true;
297     }
298 
299     /**
300     * @dev Transfer token for a specified addresses
301     * @param from The address to transfer from.
302     * @param to The address to transfer to.
303     * @param value The amount to be transferred.
304     */
305     function _transfer(address from, address to, uint256 value) internal {
306         require(to != address(0));
307 
308         _balances[from] = _balances[from].sub(value);
309         _balances[to] = _balances[to].add(value);
310         emit Transfer(from, to, value);
311     }
312 
313     /**
314      * @dev Internal function that mints an amount of the token and assigns it to
315      * an account. This encapsulates the modification of balances such that the
316      * proper events are emitted.
317      * @param account The account that will receive the created tokens.
318      * @param value The amount that will be created.
319      */
320     function _mint(address account, uint256 value) internal {
321         require(account != address(0));
322 
323         _totalSupply = _totalSupply.add(value);
324         _balances[account] = _balances[account].add(value);
325         emit Transfer(address(0), account, value);
326     }
327 
328     /**
329      * @dev Internal function that burns an amount of the token of a given
330      * account.
331      * @param account The account whose tokens will be burnt.
332      * @param value The amount that will be burnt.
333      */
334     function _burn(address account, uint256 value) internal {
335         require(account != address(0));
336 
337         _totalSupply = _totalSupply.sub(value);
338         _balances[account] = _balances[account].sub(value);
339         emit Transfer(account, address(0), value);
340     }
341 
342     /**
343      * @dev Internal function that burns an amount of the token of a given
344      * account, deducting from the sender's allowance for said account. Uses the
345      * internal burn function.
346      * Emits an Approval event (reflecting the reduced allowance).
347      * @param account The account whose tokens will be burnt.
348      * @param value The amount that will be burnt.
349      */
350     function _burnFrom(address account, uint256 value) internal {
351         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
352         _burn(account, value);
353         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
354     }
355 
356 }