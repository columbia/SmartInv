1 pragma solidity ^0.5.2;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 // input  /Users/choiseockjun/Downloads/SolidityFlattery-master/SmartCoinToken/SimpleToken.sol
6 // flattened :  Tuesday, 02-Apr-19 02:46:17 UTC
7 library SafeMath {
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
67 interface IERC20 {
68     function transfer(address to, uint256 value) external returns (bool);
69 
70     function approve(address spender, uint256 value) external returns (bool);
71 
72     function transferFrom(address from, address to, uint256 value) external returns (bool);
73 
74     function totalSupply() external view returns (uint256);
75 
76     function balanceOf(address who) external view returns (uint256);
77 
78     function allowance(address owner, address spender) external view returns (uint256);
79 
80     event Transfer(address indexed from, address indexed to, uint256 value);
81 
82     event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84 
85 contract ERC20 is IERC20 {
86     using SafeMath for uint256;
87 
88     mapping (address => uint256) private _balances;
89 
90     mapping (address => mapping (address => uint256)) private _allowed;
91 
92     uint256 private _totalSupply;
93 
94     /**
95      * @dev Total number of tokens in existence.
96      */
97     function totalSupply() public view returns (uint256) {
98         return _totalSupply;
99     }
100 
101     /**
102      * @dev Gets the balance of the specified address.
103      * @param owner The address to query the balance of.
104      * @return A uint256 representing the amount owned by the passed address.
105      */
106     function balanceOf(address owner) public view returns (uint256) {
107         return _balances[owner];
108     }
109 
110     /**
111      * @dev Function to check the amount of tokens that an owner allowed to a spender.
112      * @param owner address The address which owns the funds.
113      * @param spender address The address which will spend the funds.
114      * @return A uint256 specifying the amount of tokens still available for the spender.
115      */
116     function allowance(address owner, address spender) public view returns (uint256) {
117         return _allowed[owner][spender];
118     }
119 
120     /**
121      * @dev Transfer token to a specified address.
122      * @param to The address to transfer to.
123      * @param value The amount to be transferred.
124      */
125     function transfer(address to, uint256 value) public returns (bool) {
126         _transfer(msg.sender, to, value);
127         return true;
128     }
129 
130     /**
131      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
132      * Beware that changing an allowance with this method brings the risk that someone may use both the old
133      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
134      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
135      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
136      * @param spender The address which will spend the funds.
137      * @param value The amount of tokens to be spent.
138      */
139     function approve(address spender, uint256 value) public returns (bool) {
140         _approve(msg.sender, spender, value);
141         return true;
142     }
143 
144     /**
145      * @dev Transfer tokens from one address to another.
146      * Note that while this function emits an Approval event, this is not required as per the specification,
147      * and other compliant implementations may not emit the event.
148      * @param from address The address which you want to send tokens from
149      * @param to address The address which you want to transfer to
150      * @param value uint256 the amount of tokens to be transferred
151      */
152     function transferFrom(address from, address to, uint256 value) public returns (bool) {
153         _transfer(from, to, value);
154         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
155         return true;
156     }
157 
158     /**
159      * @dev Increase the amount of tokens that an owner allowed to a spender.
160      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
161      * allowed value is better to use this function to avoid 2 calls (and wait until
162      * the first transaction is mined)
163      * From MonolithDAO Token.sol
164      * Emits an Approval event.
165      * @param spender The address which will spend the funds.
166      * @param addedValue The amount of tokens to increase the allowance by.
167      */
168     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
169         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
170         return true;
171     }
172 
173     /**
174      * @dev Decrease the amount of tokens that an owner allowed to a spender.
175      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
176      * allowed value is better to use this function to avoid 2 calls (and wait until
177      * the first transaction is mined)
178      * From MonolithDAO Token.sol
179      * Emits an Approval event.
180      * @param spender The address which will spend the funds.
181      * @param subtractedValue The amount of tokens to decrease the allowance by.
182      */
183     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
184         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
185         return true;
186     }
187 
188     /**
189      * @dev Transfer token for a specified addresses.
190      * @param from The address to transfer from.
191      * @param to The address to transfer to.
192      * @param value The amount to be transferred.
193      */
194     function _transfer(address from, address to, uint256 value) internal {
195         require(to != address(0));
196 
197         _balances[from] = _balances[from].sub(value);
198         _balances[to] = _balances[to].add(value);
199         emit Transfer(from, to, value);
200     }
201 
202     /**
203      * @dev Internal function that mints an amount of the token and assigns it to
204      * an account. This encapsulates the modification of balances such that the
205      * proper events are emitted.
206      * @param account The account that will receive the created tokens.
207      * @param value The amount that will be created.
208      */
209     function _mint(address account, uint256 value) internal {
210         require(account != address(0));
211 
212         _totalSupply = _totalSupply.add(value);
213         _balances[account] = _balances[account].add(value);
214         emit Transfer(address(0), account, value);
215     }
216 
217     /**
218      * @dev Internal function that burns an amount of the token of a given
219      * account.
220      * @param account The account whose tokens will be burnt.
221      * @param value The amount that will be burnt.
222      */
223     function _burn(address account, uint256 value) internal {
224         require(account != address(0));
225 
226         _totalSupply = _totalSupply.sub(value);
227         _balances[account] = _balances[account].sub(value);
228         emit Transfer(account, address(0), value);
229     }
230 
231     /**
232      * @dev Approve an address to spend another addresses' tokens.
233      * @param owner The address that owns the tokens.
234      * @param spender The address that will spend the tokens.
235      * @param value The number of tokens that can be spent.
236      */
237     function _approve(address owner, address spender, uint256 value) internal {
238         require(spender != address(0));
239         require(owner != address(0));
240 
241         _allowed[owner][spender] = value;
242         emit Approval(owner, spender, value);
243     }
244 
245     /**
246      * @dev Internal function that burns an amount of the token of a given
247      * account, deducting from the sender's allowance for said account. Uses the
248      * internal burn function.
249      * Emits an Approval event (reflecting the reduced allowance).
250      * @param account The account whose tokens will be burnt.
251      * @param value The amount that will be burnt.
252      */
253     function _burnFrom(address account, uint256 value) internal {
254         _burn(account, value);
255         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
256     }
257 }
258 
259 contract ERC20Detailed is IERC20 {
260     string private _name;
261     string private _symbol;
262     uint8 private _decimals;
263 
264     constructor (string memory name, string memory symbol, uint8 decimals) public {
265         _name = name;
266         _symbol = symbol;
267         _decimals = decimals;
268     }
269 
270     /**
271      * @return the name of the token.
272      */
273     function name() public view returns (string memory) {
274         return _name;
275     }
276 
277     /**
278      * @return the symbol of the token.
279      */
280     function symbol() public view returns (string memory) {
281         return _symbol;
282     }
283 
284     /**
285      * @return the number of decimals of the token.
286      */
287     function decimals() public view returns (uint8) {
288         return _decimals;
289     }
290 }
291 
292 contract ERC20Burnable is ERC20 {
293     /**
294      * @dev Burns a specific amount of tokens.
295      * @param value The amount of token to be burned.
296      */
297     function burn(uint256 value) public {
298         _burn(msg.sender, value);
299     }
300 
301     /**
302      * @dev Burns a specific amount of tokens from the target address and decrements allowance.
303      * @param from address The account whose tokens will be burned.
304      * @param value uint256 The amount of token to be burned.
305      */
306     function burnFrom(address from, uint256 value) public {
307         _burnFrom(from, value);
308     }
309 }
310 
311 contract XSCCToken is ERC20, ERC20Detailed, ERC20Burnable {
312     uint8 public constant DECIMALS = 18;
313     uint256 public constant INITIAL_SUPPLY = 10000000000 * (10 ** uint256(DECIMALS));
314 
315     /**
316      * @dev Constructor that gives msg.sender all of existing tokens.
317      */
318     constructor () public ERC20Detailed("XSCCToken", "XSCC", DECIMALS) {
319         _mint(msg.sender, INITIAL_SUPPLY);
320     }
321 }