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
63 /**
64  * @title ERC20 interface
65  * @dev see https://eips.ethereum.org/EIPS/eip-20
66  */
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
85 /**
86  * @title Standard ERC20 token
87  *
88  * @dev Implementation of the basic standard token.
89  * https://eips.ethereum.org/EIPS/eip-20
90  * Originally based on code by FirstBlood:
91  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
92  *
93  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
94  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
95  * compliant implementations may not do it.
96  */
97 contract ERC20 is IERC20 {
98     using SafeMath for uint256;
99 
100     mapping (address => uint256) private _balances;
101 
102     mapping (address => mapping (address => uint256)) private _allowed;
103 
104     uint256 private _totalSupply;
105 
106     /**
107      * @dev Total number of tokens in existence.
108      */
109     function totalSupply() public view returns (uint256) {
110         return _totalSupply;
111     }
112 
113     /**
114      * @dev Gets the balance of the specified address.
115      * @param owner The address to query the balance of.
116      * @return A uint256 representing the amount owned by the passed address.
117      */
118     function balanceOf(address owner) public view returns (uint256) {
119         return _balances[owner];
120     }
121 
122     /**
123      * @dev Function to check the amount of tokens that an owner allowed to a spender.
124      * @param owner address The address which owns the funds.
125      * @param spender address The address which will spend the funds.
126      * @return A uint256 specifying the amount of tokens still available for the spender.
127      */
128     function allowance(address owner, address spender) public view returns (uint256) {
129         return _allowed[owner][spender];
130     }
131 
132     /**
133      * @dev Transfer token to a specified address.
134      * @param to The address to transfer to.
135      * @param value The amount to be transferred.
136      */
137     function transfer(address to, uint256 value) public returns (bool) {
138         _transfer(msg.sender, to, value);
139         return true;
140     }
141 
142     /**
143      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
144      * Beware that changing an allowance with this method brings the risk that someone may use both the old
145      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
146      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
147      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
148      * @param spender The address which will spend the funds.
149      * @param value The amount of tokens to be spent.
150      */
151     function approve(address spender, uint256 value) public returns (bool) {
152         _approve(msg.sender, spender, value);
153         return true;
154     }
155 
156     /**
157      * @dev Transfer tokens from one address to another.
158      * Note that while this function emits an Approval event, this is not required as per the specification,
159      * and other compliant implementations may not emit the event.
160      * @param from address The address which you want to send tokens from
161      * @param to address The address which you want to transfer to
162      * @param value uint256 the amount of tokens to be transferred
163      */
164     function transferFrom(address from, address to, uint256 value) public returns (bool) {
165         _transfer(from, to, value);
166         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
167         return true;
168     }
169 
170     /**
171      * @dev Increase the amount of tokens that an owner allowed to a spender.
172      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
173      * allowed value is better to use this function to avoid 2 calls (and wait until
174      * the first transaction is mined)
175      * From MonolithDAO Token.sol
176      * Emits an Approval event.
177      * @param spender The address which will spend the funds.
178      * @param addedValue The amount of tokens to increase the allowance by.
179      */
180     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
181         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
182         return true;
183     }
184 
185     /**
186      * @dev Decrease the amount of tokens that an owner allowed to a spender.
187      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
188      * allowed value is better to use this function to avoid 2 calls (and wait until
189      * the first transaction is mined)
190      * From MonolithDAO Token.sol
191      * Emits an Approval event.
192      * @param spender The address which will spend the funds.
193      * @param subtractedValue The amount of tokens to decrease the allowance by.
194      */
195     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
196         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
197         return true;
198     }
199 
200     /**
201      * @dev Transfer token for a specified addresses.
202      * @param from The address to transfer from.
203      * @param to The address to transfer to.
204      * @param value The amount to be transferred.
205      */
206     function _transfer(address from, address to, uint256 value) internal {
207         require(to != address(0));
208 
209         _balances[from] = _balances[from].sub(value);
210         _balances[to] = _balances[to].add(value);
211         emit Transfer(from, to, value);
212     }
213 
214     /**
215      * @dev Internal function that mints an amount of the token and assigns it to
216      * an account. This encapsulates the modification of balances such that the
217      * proper events are emitted.
218      * @param account The account that will receive the created tokens.
219      * @param value The amount that will be created.
220      */
221     function _mint(address account, uint256 value) internal {
222         require(account != address(0));
223 
224         _totalSupply = _totalSupply.add(value);
225         _balances[account] = _balances[account].add(value);
226         emit Transfer(address(0), account, value);
227     }
228 
229     /**
230      * @dev Internal function that burns an amount of the token of a given
231      * account.
232      * @param account The account whose tokens will be burnt.
233      * @param value The amount that will be burnt.
234      */
235     function _burn(address account, uint256 value) internal {
236         require(account != address(0));
237 
238         _totalSupply = _totalSupply.sub(value);
239         _balances[account] = _balances[account].sub(value);
240         emit Transfer(account, address(0), value);
241     }
242 
243     /**
244      * @dev Approve an address to spend another addresses' tokens.
245      * @param owner The address that owns the tokens.
246      * @param spender The address that will spend the tokens.
247      * @param value The number of tokens that can be spent.
248      */
249     function _approve(address owner, address spender, uint256 value) internal {
250         require(spender != address(0));
251         require(owner != address(0));
252 
253         _allowed[owner][spender] = value;
254         emit Approval(owner, spender, value);
255     }
256 
257     /**
258      * @dev Internal function that burns an amount of the token of a given
259      * account, deducting from the sender's allowance for said account. Uses the
260      * internal burn function.
261      * Emits an Approval event (reflecting the reduced allowance).
262      * @param account The account whose tokens will be burnt.
263      * @param value The amount that will be burnt.
264      */
265     function _burnFrom(address account, uint256 value) internal {
266         _burn(account, value);
267         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
268     }
269 }
270 
271 /**
272  * @title Burnable Token
273  * @dev Token that can be irreversibly burned (destroyed).
274  */
275 contract ERC20Burnable is ERC20 {
276     /**
277      * @dev Burns a specific amount of tokens.
278      * @param value The amount of token to be burned.
279      */
280     function burn(uint256 value) public {
281         _burn(msg.sender, value);
282     }
283 
284     /**
285      * @dev Burns a specific amount of tokens from the target address and decrements allowance.
286      * @param from address The account whose tokens will be burned.
287      * @param value uint256 The amount of token to be burned.
288      */
289     function burnFrom(address from, uint256 value) public {
290         _burnFrom(from, value);
291     }
292 }
293 
294 /**
295  * @title ERC20Detailed token
296  * @dev The decimals are only for visualization purposes.
297  * All the operations are done using the smallest and indivisible token unit,
298  * just as on Ethereum all the operations are done in wei.
299  */
300 contract ERC20Detailed is IERC20 {
301     string private _name;
302     string private _symbol;
303     uint8 private _decimals;
304 
305     constructor (string memory name, string memory symbol, uint8 decimals) public {
306         _name = name;
307         _symbol = symbol;
308         _decimals = decimals;
309     }
310 
311     /**
312      * @return the name of the token.
313      */
314     function name() public view returns (string memory) {
315         return _name;
316     }
317 
318     /**
319      * @return the symbol of the token.
320      */
321     function symbol() public view returns (string memory) {
322         return _symbol;
323     }
324 
325     /**
326      * @return the number of decimals of the token.
327      */
328     function decimals() public view returns (uint8) {
329         return _decimals;
330     }
331 }
332 
333 /**
334  * @title tranToken
335  * Note they can later distribute these tokens as they wish using `transfer` and other
336  * `ERC20` functions.
337  */
338 contract ndwtToken is ERC20, ERC20Burnable, ERC20Detailed {
339     uint8 public constant DECIMALS = 18;
340     uint256 public constant INITIAL_SUPPLY = 8800000000 * (10 ** uint256(DECIMALS)); 
341 
342     /**
343      * @dev Constructor that gives msg.sender all of existing tokens.
344      */
345     constructor () public ERC20Detailed("NewDreamWorld Token", "NDWT", 18) {
346         _mint(msg.sender, INITIAL_SUPPLY); 
347     }
348 }