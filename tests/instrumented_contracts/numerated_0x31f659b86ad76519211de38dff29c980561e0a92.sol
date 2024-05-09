1 pragma solidity ^0.5.2;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8     function transfer(address to, uint256 value) external returns (bool);
9 
10     function approve(address spender, uint256 value) external returns (bool);
11 
12     function transferFrom(address from, address to, uint256 value) external returns (bool);
13 
14     function totalSupply() external view returns (uint256);
15 
16     function balanceOf(address who) external view returns (uint256);
17 
18     function allowance(address owner, address spender) external view returns (uint256);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 
26 /**
27  * @title SafeMath
28  * @dev Unsigned math operations with safety checks that revert on error
29  */
30 library SafeMath {
31     /**
32      * @dev Multiplies two unsigned integers, reverts on overflow.
33      */
34     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
35         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
36         // benefit is lost if 'b' is also tested.
37         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
38         if (a == 0) {
39             return 0;
40         }
41 
42         uint256 c = a * b;
43         require(c / a == b);
44 
45         return c;
46     }
47 
48     /**
49      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
50      */
51     function div(uint256 a, uint256 b) internal pure returns (uint256) {
52         // Solidity only automatically asserts when dividing by 0
53         require(b > 0);
54         uint256 c = a / b;
55         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
56 
57         return c;
58     }
59 
60     /**
61      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
62      */
63     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b <= a);
65         uint256 c = a - b;
66 
67         return c;
68     }
69 
70     /**
71      * @dev Adds two unsigned integers, reverts on overflow.
72      */
73     function add(uint256 a, uint256 b) internal pure returns (uint256) {
74         uint256 c = a + b;
75         require(c >= a);
76 
77         return c;
78     }
79 
80     /**
81      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
82      * reverts when dividing by zero.
83      */
84     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
85         require(b != 0);
86         return a % b;
87     }
88 }
89 
90 
91 /**
92  * @title Standard ERC20 token
93  *
94  * @dev Implementation of the basic standard token.
95  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
96  * Originally based on code by FirstBlood:
97  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
98  *
99  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
100  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
101  * compliant implementations may not do it.
102  */
103 contract ERC20 is IERC20 {
104     using SafeMath for uint256;
105 
106     mapping (address => uint256) private _balances;
107 
108     mapping (address => mapping (address => uint256)) private _allowed;
109 
110     uint256 private _totalSupply;
111 
112     /**
113      * @dev Total number of tokens in existence
114      */
115     function totalSupply() public view returns (uint256) {
116         return _totalSupply;
117     }
118 
119     /**
120      * @dev Gets the balance of the specified address.
121      * @param owner The address to query the balance of.
122      * @return An uint256 representing the amount owned by the passed address.
123      */
124     function balanceOf(address owner) public view returns (uint256) {
125         return _balances[owner];
126     }
127 
128     /**
129      * @dev Function to check the amount of tokens that an owner allowed to a spender.
130      * @param owner address The address which owns the funds.
131      * @param spender address The address which will spend the funds.
132      * @return A uint256 specifying the amount of tokens still available for the spender.
133      */
134     function allowance(address owner, address spender) public view returns (uint256) {
135         return _allowed[owner][spender];
136     }
137 
138     /**
139      * @dev Transfer token for a specified address
140      * @param to The address to transfer to.
141      * @param value The amount to be transferred.
142      */
143     function transfer(address to, uint256 value) public returns (bool) {
144         _transfer(msg.sender, to, value);
145         return true;
146     }
147 
148     /**
149      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
150      * Beware that changing an allowance with this method brings the risk that someone may use both the old
151      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
152      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
153      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
154      * @param spender The address which will spend the funds.
155      * @param value The amount of tokens to be spent.
156      */
157     function approve(address spender, uint256 value) public returns (bool) {
158         _approve(msg.sender, spender, value);
159         return true;
160     }
161 
162     /**
163      * @dev Transfer tokens from one address to another.
164      * Note that while this function emits an Approval event, this is not required as per the specification,
165      * and other compliant implementations may not emit the event.
166      * @param from address The address which you want to send tokens from
167      * @param to address The address which you want to transfer to
168      * @param value uint256 the amount of tokens to be transferred
169      */
170     function transferFrom(address from, address to, uint256 value) public returns (bool) {
171         _transfer(from, to, value);
172         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
173         return true;
174     }
175 
176     /**
177      * @dev Increase the amount of tokens that an owner allowed to a spender.
178      * approve should be called when allowed_[_spender] == 0. To increment
179      * allowed value is better to use this function to avoid 2 calls (and wait until
180      * the first transaction is mined)
181      * From MonolithDAO Token.sol
182      * Emits an Approval event.
183      * @param spender The address which will spend the funds.
184      * @param addedValue The amount of tokens to increase the allowance by.
185      */
186     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
187         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
188         return true;
189     }
190 
191     /**
192      * @dev Decrease the amount of tokens that an owner allowed to a spender.
193      * approve should be called when allowed_[_spender] == 0. To decrement
194      * allowed value is better to use this function to avoid 2 calls (and wait until
195      * the first transaction is mined)
196      * From MonolithDAO Token.sol
197      * Emits an Approval event.
198      * @param spender The address which will spend the funds.
199      * @param subtractedValue The amount of tokens to decrease the allowance by.
200      */
201     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
202         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
203         return true;
204     }
205 
206     /**
207      * @dev Transfer token for a specified addresses
208      * @param from The address to transfer from.
209      * @param to The address to transfer to.
210      * @param value The amount to be transferred.
211      */
212     function _transfer(address from, address to, uint256 value) internal {
213         require(to != address(0));
214 
215         _balances[from] = _balances[from].sub(value);
216         _balances[to] = _balances[to].add(value);
217         emit Transfer(from, to, value);
218     }
219 
220     /**
221      * @dev Internal function that mints an amount of the token and assigns it to
222      * an account. This encapsulates the modification of balances such that the
223      * proper events are emitted.
224      * @param account The account that will receive the created tokens.
225      * @param value The amount that will be created.
226      */
227     function _mint(address account, uint256 value) internal {
228         require(account != address(0));
229 
230         _totalSupply = _totalSupply.add(value);
231         _balances[account] = _balances[account].add(value);
232         emit Transfer(address(0), account, value);
233     }
234 
235     /**
236      * @dev Internal function that burns an amount of the token of a given
237      * account.
238      * @param account The account whose tokens will be burnt.
239      * @param value The amount that will be burnt.
240      */
241     function _burn(address account, uint256 value) internal {
242         require(account != address(0));
243 
244         _totalSupply = _totalSupply.sub(value);
245         _balances[account] = _balances[account].sub(value);
246         emit Transfer(account, address(0), value);
247     }
248 
249     /**
250      * @dev Approve an address to spend another addresses' tokens.
251      * @param owner The address that owns the tokens.
252      * @param spender The address that will spend the tokens.
253      * @param value The number of tokens that can be spent.
254      */
255     function _approve(address owner, address spender, uint256 value) internal {
256         require(spender != address(0));
257         require(owner != address(0));
258 
259         _allowed[owner][spender] = value;
260         emit Approval(owner, spender, value);
261     }
262 
263     /**
264      * @dev Internal function that burns an amount of the token of a given
265      * account, deducting from the sender's allowance for said account. Uses the
266      * internal burn function.
267      * Emits an Approval event (reflecting the reduced allowance).
268      * @param account The account whose tokens will be burnt.
269      * @param value The amount that will be burnt.
270      */
271     function _burnFrom(address account, uint256 value) internal {
272         _burn(account, value);
273         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
274     }
275 }
276 
277 /**
278  * @title ERC20Detailed token
279  * @dev The decimals are only for visualization purposes.
280  * All the operations are done using the smallest and indivisible token unit,
281  * just as on Ethereum all the operations are done in wei.
282  */
283 contract ERC20Detailed is IERC20 {
284     string private _name;
285     string private _symbol;
286     uint8 private _decimals;
287 
288     constructor (string memory name, string memory symbol, uint8 decimals) public {
289         _name = name;
290         _symbol = symbol;
291         _decimals = decimals;
292     }
293 
294     /**
295      * @return the name of the token.
296      */
297     function name() public view returns (string memory) {
298         return _name;
299     }
300 
301     /**
302      * @return the symbol of the token.
303      */
304     function symbol() public view returns (string memory) {
305         return _symbol;
306     }
307 
308     /**
309      * @return the number of decimals of the token.
310      */
311     function decimals() public view returns (uint8) {
312         return _decimals;
313     }
314 }
315 
316 /**
317  * @title SimpleToken
318  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
319  * Note they can later distribute these tokens as they wish using `transfer` and other
320  * `ERC20` functions.
321  */
322 contract SimpleToken is ERC20, ERC20Detailed {
323     uint8 public constant DECIMALS = 0;
324     uint256 public constant INITIAL_SUPPLY = 15000;
325 
326     /**
327      * @dev Constructor that gives msg.sender all of existing tokens.
328      */
329     constructor () public ERC20Detailed("OKGO", "OGC", DECIMALS) {
330         _mint(msg.sender, INITIAL_SUPPLY);
331     }
332 }