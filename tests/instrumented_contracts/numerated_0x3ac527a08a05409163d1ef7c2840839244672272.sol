1 pragma solidity ^0.5.2;
2 
3 library SafeMath {
4     /**
5      * @dev Multiplies two unsigned integers, reverts on overflow.
6      */
7     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
9         // benefit is lost if 'b' is also tested.
10         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
11         if (a == 0) {
12             return 0;
13         }
14 
15         uint256 c = a * b;
16         require(c / a == b);
17 
18         return c;
19     }
20 
21     /**
22      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
23      */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // Solidity only automatically asserts when dividing by 0
26         require(b > 0);
27         uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29 
30         return c;
31     }
32 
33     /**
34      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
35      */
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         require(b <= a);
38         uint256 c = a - b;
39 
40         return c;
41     }
42 
43     /**
44      * @dev Adds two unsigned integers, reverts on overflow.
45      */
46     function add(uint256 a, uint256 b) internal pure returns (uint256) {
47         uint256 c = a + b;
48         require(c >= a);
49 
50         return c;
51     }
52 
53     /**
54      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
55      * reverts when dividing by zero.
56      */
57     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
58         require(b != 0);
59         return a % b;
60     }
61 }
62 
63 interface IERC20 {
64     function transfer(address to, uint256 value) external returns (bool);
65 
66     function approve(address spender, uint256 value) external returns (bool);
67 
68     function transferFrom(address from, address to, uint256 value) external returns (bool);
69 
70     function totalSupply() external view returns (uint256);
71 
72     function balanceOf(address who) external view returns (uint256);
73 
74     function allowance(address owner, address spender) external view returns (uint256);
75 
76     event Transfer(address indexed from, address indexed to, uint256 value);
77 
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 contract ERC20 is IERC20 {
82     using SafeMath for uint256;
83 
84     mapping (address => uint256) private _balances;
85 
86     mapping (address => mapping (address => uint256)) private _allowed;
87 
88     uint256 private _totalSupply;
89 
90     /**
91      * @dev Total number of tokens in existence
92      */
93     function totalSupply() public view returns (uint256) {
94         return _totalSupply;
95     }
96 
97     /**
98      * @dev Gets the balance of the specified address.
99      * @param owner The address to query the balance of.
100      * @return A uint256 representing the amount owned by the passed address.
101      */
102     function balanceOf(address owner) public view returns (uint256) {
103         return _balances[owner];
104     }
105 
106     /**
107      * @dev Function to check the amount of tokens that an owner allowed to a spender.
108      * @param owner address The address which owns the funds.
109      * @param spender address The address which will spend the funds.
110      * @return A uint256 specifying the amount of tokens still available for the spender.
111      */
112     function allowance(address owner, address spender) public view returns (uint256) {
113         return _allowed[owner][spender];
114     }
115 
116     /**
117      * @dev Transfer token to a specified address
118      * @param to The address to transfer to.
119      * @param value The amount to be transferred.
120      */
121     function transfer(address to, uint256 value) public returns (bool) {
122         _transfer(msg.sender, to, value);
123         return true;
124     }
125 
126     /**
127      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
128      * Beware that changing an allowance with this method brings the risk that someone may use both the old
129      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
130      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
131      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132      * @param spender The address which will spend the funds.
133      * @param value The amount of tokens to be spent.
134      */
135     function approve(address spender, uint256 value) public returns (bool) {
136         _approve(msg.sender, spender, value);
137         return true;
138     }
139 
140     /**
141      * @dev Transfer tokens from one address to another.
142      * Note that while this function emits an Approval event, this is not required as per the specification,
143      * and other compliant implementations may not emit the event.
144      * @param from address The address which you want to send tokens from
145      * @param to address The address which you want to transfer to
146      * @param value uint256 the amount of tokens to be transferred
147      */
148     function transferFrom(address from, address to, uint256 value) public returns (bool) {
149         _transfer(from, to, value);
150         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
151         return true;
152     }
153 
154     /**
155      * @dev Increase the amount of tokens that an owner allowed to a spender.
156      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
157      * allowed value is better to use this function to avoid 2 calls (and wait until
158      * the first transaction is mined)
159      * From MonolithDAO Token.sol
160      * Emits an Approval event.
161      * @param spender The address which will spend the funds.
162      * @param addedValue The amount of tokens to increase the allowance by.
163      */
164     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
165         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
166         return true;
167     }
168 
169     /**
170      * @dev Decrease the amount of tokens that an owner allowed to a spender.
171      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
172      * allowed value is better to use this function to avoid 2 calls (and wait until
173      * the first transaction is mined)
174      * From MonolithDAO Token.sol
175      * Emits an Approval event.
176      * @param spender The address which will spend the funds.
177      * @param subtractedValue The amount of tokens to decrease the allowance by.
178      */
179     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
180         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
181         return true;
182     }
183 
184     /**
185      * @dev Transfer token for a specified addresses
186      * @param from The address to transfer from.
187      * @param to The address to transfer to.
188      * @param value The amount to be transferred.
189      */
190     function _transfer(address from, address to, uint256 value) internal {
191         require(to != address(0));
192 
193         _balances[from] = _balances[from].sub(value);
194         _balances[to] = _balances[to].add(value);
195         emit Transfer(from, to, value);
196     }
197 
198     /**
199      * @dev Internal function that mints an amount of the token and assigns it to
200      * an account. This encapsulates the modification of balances such that the
201      * proper events are emitted.
202      * @param account The account that will receive the created tokens.
203      * @param value The amount that will be created.
204      */
205     function _mint(address account, uint256 value) internal {
206         require(account != address(0));
207 
208         _totalSupply = _totalSupply.add(value);
209         _balances[account] = _balances[account].add(value);
210         emit Transfer(address(0), account, value);
211     }
212 
213     /**
214      * @dev Internal function that burns an amount of the token of a given
215      * account.
216      * @param account The account whose tokens will be burnt.
217      * @param value The amount that will be burnt.
218      */
219     function _burn(address account, uint256 value) internal {
220         require(account != address(0));
221 
222         _totalSupply = _totalSupply.sub(value);
223         _balances[account] = _balances[account].sub(value);
224         emit Transfer(account, address(0), value);
225     }
226 
227     /**
228      * @dev Approve an address to spend another addresses' tokens.
229      * @param owner The address that owns the tokens.
230      * @param spender The address that will spend the tokens.
231      * @param value The number of tokens that can be spent.
232      */
233     function _approve(address owner, address spender, uint256 value) internal {
234         require(spender != address(0));
235         require(owner != address(0));
236 
237         _allowed[owner][spender] = value;
238         emit Approval(owner, spender, value);
239     }
240 
241     /**
242      * @dev Internal function that burns an amount of the token of a given
243      * account, deducting from the sender's allowance for said account. Uses the
244      * internal burn function.
245      * Emits an Approval event (reflecting the reduced allowance).
246      * @param account The account whose tokens will be burnt.
247      * @param value The amount that will be burnt.
248      */
249     function _burnFrom(address account, uint256 value) internal {
250         _burn(account, value);
251         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
252     }
253 }
254 
255 contract ERC20Detailed is IERC20 {
256     string private _name;
257     string private _symbol;
258     uint8 private _decimals;
259 
260     constructor (string memory name, string memory symbol, uint8 decimals) public {
261         _name = name;
262         _symbol = symbol;
263         _decimals = decimals;
264     }
265 
266     /**
267      * @return the name of the token.
268      */
269     function name() public view returns (string memory) {
270         return _name;
271     }
272 
273     /**
274      * @return the symbol of the token.
275      */
276     function symbol() public view returns (string memory) {
277         return _symbol;
278     }
279 
280     /**
281      * @return the number of decimals of the token.
282      */
283     function decimals() public view returns (uint8) {
284         return _decimals;
285     }
286 }
287 
288 /**
289  * @title SimpleToken
290  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
291  * Note they can later distribute these tokens as they wish using `transfer` and other
292  * `ERC20` functions.
293  */
294 contract SteinToken is ERC20, ERC20Detailed {
295     uint8 public constant DECIMALS = 18;
296     uint256 public constant INITIAL_SUPPLY = 666 * (10 ** uint256(DECIMALS));
297 
298     /**
299      * @dev Constructor that gives msg.sender all of existing tokens.
300      */
301     constructor () public ERC20Detailed("SteinToken", "STOKE", DECIMALS) {
302         _mint(msg.sender, INITIAL_SUPPLY);
303     }
304 }