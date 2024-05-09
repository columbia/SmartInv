1 pragma solidity ^0.5.2;
2 
3 /**
4  * @title SafeMath(Connor)
5  * @dev Unsigned math operations with safety checks that revert on error
6  */
7 library SafeMath_Connor {
8     /**
9      * @dev Multiplies two unsigned integers, reverts on overflow.
10      */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27      */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48      * @dev Adds two unsigned integers, reverts on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59      * reverts when dividing by zero.
60      */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 /**
68  * @title IERC20(Connor) interface
69  * @dev see https://github.com/ethereum/EIPs/issues/20
70  */
71 interface IERC20_Connor {
72     function transfer(address to, uint256 value) external returns (bool);
73 
74     function approve(address spender, uint256 value) external returns (bool);
75 
76     function transferFrom(address from, address to, uint256 value) external returns (bool);
77 
78     function totalSupply() external view returns (uint256);
79 
80     function balanceOf(address who) external view returns (uint256);
81 
82     function allowance(address owner, address spender) external view returns (uint256);
83 
84     event Transfer(address indexed from, address indexed to, uint256 value);
85 
86     event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 /**
90  * @title Standard ERC20(Connor) token
91  * @dev Implementation of the basic standard token.
92 */
93 contract ERC20_Connor is IERC20_Connor {
94     using SafeMath_Connor for uint256;
95 
96     mapping (address => uint256) private _balances;
97 
98     mapping (address => mapping (address => uint256)) private _allowed;
99 
100     uint256 private _totalSupply;
101 
102     /**
103      * @dev Total number of tokens in existence
104      */
105     function totalSupply() public view returns (uint256) {
106         return _totalSupply;
107     }
108 
109     /**
110      * @dev Gets the balance of the specified address.
111      * @param owner The address to query the balance of.
112      * @return An uint256 representing the amount owned by the passed address.
113      */
114     function balanceOf(address owner) public view returns (uint256) {
115         return _balances[owner];
116     }
117 
118     /**
119      * @dev Function to check the amount of tokens that an owner allowed to a spender.
120      * @param owner address The address which owns the funds.
121      * @param spender address The address which will spend the funds.
122      * @return A uint256 specifying the amount of tokens still available for the spender.
123      */
124     function allowance(address owner, address spender) public view returns (uint256) {
125         return _allowed[owner][spender];
126     }
127 
128     /**
129      * @dev Transfer token for a specified address
130      * @param to The address to transfer to.
131      * @param value The amount to be transferred.
132      */
133     function transfer(address to, uint256 value) public returns (bool) {
134         _transfer(msg.sender, to, value);
135         return true;
136     }
137 
138     /**
139      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
140      * Beware that changing an allowance with this method brings the risk that someone may use both the old
141      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
142      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
143      * @param spender The address which will spend the funds.
144      * @param value The amount of tokens to be spent.
145      */
146     function approve(address spender, uint256 value) public returns (bool) {
147         _approve(msg.sender, spender, value);
148         return true;
149     }
150 
151     /**
152      * @dev Transfer tokens from one address to another.
153      * Note that while this function emits an Approval event, this is not required as per the specification,
154      * and other compliant implementations may not emit the event.
155      * @param from address The address which you want to send tokens from
156      * @param to address The address which you want to transfer to
157      * @param value uint256 the amount of tokens to be transferred
158      */
159     function transferFrom(address from, address to, uint256 value) public returns (bool) {
160         _transfer(from, to, value);
161         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
162         return true;
163     }
164 
165     /**
166      * @dev Increase the amount of tokens that an owner allowed to a spender.
167      * approve should be called when allowed_[_spender] == 0. To increment
168      * allowed value is better to use this function to avoid 2 calls (and wait until
169      * the first transaction is mined)
170      * From MonolithDAO Token.sol
171      * Emits an Approval event.
172      * @param spender The address which will spend the funds.
173      * @param addedValue The amount of tokens to increase the allowance by.
174      */
175     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
176         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
177         return true;
178     }
179 
180     /**
181      * @dev Decrease the amount of tokens that an owner allowed to a spender.
182      * approve should be called when allowed_[_spender] == 0. To decrement
183      * allowed value is better to use this function to avoid 2 calls (and wait until
184      * the first transaction is mined)
185      * From MonolithDAO Token.sol
186      * Emits an Approval event.
187      * @param spender The address which will spend the funds.
188      * @param subtractedValue The amount of tokens to decrease the allowance by.
189      */
190     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
191         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
192         return true;
193     }
194 
195     /**
196      * @dev Transfer token for a specified addresses
197      * @param from The address to transfer from.
198      * @param to The address to transfer to.
199      * @param value The amount to be transferred.
200      */
201     function _transfer(address from, address to, uint256 value) internal {
202         require(to != address(0));
203 
204         _balances[from] = _balances[from].sub(value);
205         _balances[to] = _balances[to].add(value);
206         emit Transfer(from, to, value);
207     }
208 
209     /**
210      * @dev Internal function that mints an amount of the token and assigns it to
211      * an account. This encapsulates the modification of balances such that the
212      * proper events are emitted.
213      * @param account The account that will receive the created tokens.
214      * @param value The amount that will be created.
215      */
216     function _mint(address account, uint256 value) internal {
217         require(account != address(0));
218 
219         _totalSupply = _totalSupply.add(value);
220         _balances[account] = _balances[account].add(value);
221         emit Transfer(address(0), account, value);
222     }
223 
224     /**
225      * @dev Internal function that burns an amount of the token of a given
226      * account.
227      * @param account The account whose tokens will be burnt.
228      * @param value The amount that will be burnt.
229      */
230     function _burn(address account, uint256 value) internal {
231         require(account != address(0));
232 
233         _totalSupply = _totalSupply.sub(value);
234         _balances[account] = _balances[account].sub(value);
235         emit Transfer(account, address(0), value);
236     }
237 
238     /**
239      * @dev Approve an address to spend another addresses' tokens.
240      * @param owner The address that owns the tokens.
241      * @param spender The address that will spend the tokens.
242      * @param value The number of tokens that can be spent.
243      */
244     function _approve(address owner, address spender, uint256 value) internal {
245         require(spender != address(0));
246         require(owner != address(0));
247 
248         _allowed[owner][spender] = value;
249         emit Approval(owner, spender, value);
250     }
251 
252     /**
253      * @dev Internal function that burns an amount of the token of a given
254      * account, deducting from the sender's allowance for said account. Uses the
255      * internal burn function.
256      * Emits an Approval event (reflecting the reduced allowance).
257      * @param account The account whose tokens will be burnt.
258      * @param value The amount that will be burnt.
259      */
260     function _burnFrom(address account, uint256 value) internal {
261         _burn(account, value);
262         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
263     }
264 }
265 
266 /**
267  * @title ERC20Detailed(Connor) token
268  * @dev The decimals are only for visualization purposes.
269  * All the operations are done using the smallest and indivisible token unit,
270  * just as on Ethereum all the operations are done in wei.
271  */
272 contract ERC20Detailed_Connor is IERC20_Connor {
273     string private _name;
274     string private _symbol;
275     uint8 private _decimals;
276 
277     constructor (string memory name, string memory symbol, uint8 decimals) public {
278         _name = name;
279         _symbol = symbol;
280         _decimals = decimals;
281     }
282 
283     /**
284      * @return the name of the token.
285      */
286     function name() public view returns (string memory) {
287         return _name;
288     }
289 
290     /**
291      * @return the symbol of the token.
292      */
293     function symbol() public view returns (string memory) {
294         return _symbol;
295     }
296 
297     /**
298      * @return the number of decimals of the token.
299      */
300     function decimals() public view returns (uint8) {
301         return _decimals;
302     }
303 }
304 /**
305  * @title ERC20Burnable(Connor) Token
306  * @dev Token that can be irreversibly burned (destroyed).
307  */
308 contract ERC20Burnable_Connor is ERC20_Connor {
309     /**
310      * @dev Burns a specific amount of tokens.
311      * @param value The amount of token to be burned.
312      */
313     function burn(uint256 value) public {
314         _burn(msg.sender, value);
315     }
316 
317     /**
318      * @dev Burns a specific amount of tokens from the target address and decrements allowance
319      * @param from address The account whose tokens will be burned.
320      * @param value uint256 The amount of token to be burned.
321      */
322     function burnFrom(address from, uint256 value) public {
323         _burnFrom(from, value);
324     }
325 }
326 /**
327  * @title SimpleToken
328  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
329  * Note they can later distribute these tokens as they wish using `transfer` and other
330  * `ERC20` functions.
331  */
332 contract ConnorToken is ERC20_Connor, ERC20Detailed_Connor, ERC20Burnable_Connor {
333     uint8 public constant DECIMALS = 18;
334     uint256 public constant INITIAL_SUPPLY = 21000000 * (10 ** uint256(DECIMALS));
335     // 10 곱하기 10성
336 
337     /**
338      * @dev Constructor that gives msg.sender all of existing tokens.
339      */
340     constructor () public ERC20Detailed_Connor("BitEthereum", "BITE", DECIMALS) {
341         _mint(msg.sender, INITIAL_SUPPLY);
342     }
343 }