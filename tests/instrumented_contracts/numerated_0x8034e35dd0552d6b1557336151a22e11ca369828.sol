1 pragma solidity ^0.5.1;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Unsigned math operations with safety checks that revert on error
7  */
8 library SafeMath {
9     /**
10      * @dev Multiplies two unsigned integers, reverts on overflow.
11      */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17             return 0;
18         }
19 
20         uint256 c = a * b;
21         require(c / a == b);
22 
23         return c;
24     }
25 
26     /**
27      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
28      */
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         // Solidity only automatically asserts when dividing by 0
31         require(b > 0);
32         uint256 c = a / b;
33         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34 
35         return c;
36     }
37 
38     /**
39      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
40      */
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         require(b <= a);
43         uint256 c = a - b;
44 
45         return c;
46     }
47 
48     /**
49      * @dev Adds two unsigned integers, reverts on overflow.
50      */
51     function add(uint256 a, uint256 b) internal pure returns (uint256) {
52         uint256 c = a + b;
53         require(c >= a);
54 
55         return c;
56     }
57 
58     /**
59      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
60      * reverts when dividing by zero.
61      */
62     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63         require(b != 0);
64         return a % b;
65     }
66 }
67 
68 
69 /**
70  * @title ERC20 interface
71  * @dev see https://eips.ethereum.org/EIPS/eip-20
72  */
73 interface IERC20 {
74     function transfer(address to, uint256 value) external returns (bool);
75 
76     function approve(address spender, uint256 value) external returns (bool);
77 
78     function transferFrom(address from, address to, uint256 value) external returns (bool);
79 
80     function totalSupply() external view returns (uint256);
81 
82     function balanceOf(address who) external view returns (uint256);
83 
84     function allowance(address owner, address spender) external view returns (uint256);
85 
86     event Transfer(address indexed from, address indexed to, uint256 value);
87 
88     event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 
92 /**
93  * @title Standard ERC20 token
94  *
95  * @dev Implementation of the basic standard token.
96  * https://eips.ethereum.org/EIPS/eip-20
97  * Originally based on code by FirstBlood:
98  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
99  *
100  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
101  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
102  * compliant implementations may not do it.
103  */
104 contract ERC20 is IERC20 {
105     using SafeMath for uint256;
106 
107     mapping (address => uint256) private _balances;
108 
109     mapping (address => mapping (address => uint256)) private _allowed;
110 
111     uint256 private _totalSupply;
112 
113     /**
114      * @dev Total number of tokens in existence
115      */
116     function totalSupply() public view returns (uint256) {
117         return _totalSupply;
118     }
119 
120     /**
121      * @dev Gets the balance of the specified address.
122      * @param owner The address to query the balance of.
123      * @return A uint256 representing the amount owned by the passed address.
124      */
125     function balanceOf(address owner) public view returns (uint256) {
126         return _balances[owner];
127     }
128 
129     /**
130      * @dev Function to check the amount of tokens that an owner allowed to a spender.
131      * @param owner address The address which owns the funds.
132      * @param spender address The address which will spend the funds.
133      * @return A uint256 specifying the amount of tokens still available for the spender.
134      */
135     function allowance(address owner, address spender) public view returns (uint256) {
136         return _allowed[owner][spender];
137     }
138 
139     /**
140      * @dev Transfer token to a specified address
141      * @param to The address to transfer to.
142      * @param value The amount to be transferred.
143      */
144     function transfer(address to, uint256 value) public returns (bool) {
145         _transfer(msg.sender, to, value);
146         return true;
147     }
148 
149     /**
150      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
151      * Beware that changing an allowance with this method brings the risk that someone may use both the old
152      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
153      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
154      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
155      * @param spender The address which will spend the funds.
156      * @param value The amount of tokens to be spent.
157      */
158     function approve(address spender, uint256 value) public returns (bool) {
159         _approve(msg.sender, spender, value);
160         return true;
161     }
162 
163     /**
164      * @dev Transfer tokens from one address to another.
165      * Note that while this function emits an Approval event, this is not required as per the specification,
166      * and other compliant implementations may not emit the event.
167      * @param from address The address which you want to send tokens from
168      * @param to address The address which you want to transfer to
169      * @param value uint256 the amount of tokens to be transferred
170      */
171     function transferFrom(address from, address to, uint256 value) public returns (bool) {
172         _transfer(from, to, value);
173         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
174         return true;
175     }
176 
177     /**
178      * @dev Increase the amount of tokens that an owner allowed to a spender.
179      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
180      * allowed value is better to use this function to avoid 2 calls (and wait until
181      * the first transaction is mined)
182      * From MonolithDAO Token.sol
183      * Emits an Approval event.
184      * @param spender The address which will spend the funds.
185      * @param addedValue The amount of tokens to increase the allowance by.
186      */
187     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
188         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
189         return true;
190     }
191 
192     /**
193      * @dev Decrease the amount of tokens that an owner allowed to a spender.
194      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
195      * allowed value is better to use this function to avoid 2 calls (and wait until
196      * the first transaction is mined)
197      * From MonolithDAO Token.sol
198      * Emits an Approval event.
199      * @param spender The address which will spend the funds.
200      * @param subtractedValue The amount of tokens to decrease the allowance by.
201      */
202     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
203         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
204         return true;
205     }
206 
207     /**
208      * @dev Transfer token for a specified addresses
209      * @param from The address to transfer from.
210      * @param to The address to transfer to.
211      * @param value The amount to be transferred.
212      */
213     function _transfer(address from, address to, uint256 value) internal {
214         require(to != address(0));
215 
216         _balances[from] = _balances[from].sub(value);
217         _balances[to] = _balances[to].add(value);
218         emit Transfer(from, to, value);
219     }
220 
221     /**
222      * @dev Internal function that mints an amount of the token and assigns it to
223      * an account. This encapsulates the modification of balances such that the
224      * proper events are emitted.
225      * @param account The account that will receive the created tokens.
226      * @param value The amount that will be created.
227      */
228     function _mint(address account, uint256 value) internal {
229         require(account != address(0));
230 
231         _totalSupply = _totalSupply.add(value);
232         _balances[account] = _balances[account].add(value);
233         emit Transfer(address(0), account, value);
234     }
235 
236     /**
237      * @dev Internal function that burns an amount of the token of a given
238      * account.
239      * @param account The account whose tokens will be burnt.
240      * @param value The amount that will be burnt.
241      */
242     function _burn(address account, uint256 value) internal {
243         require(account != address(0));
244 
245         _totalSupply = _totalSupply.sub(value);
246         _balances[account] = _balances[account].sub(value);
247         emit Transfer(account, address(0), value);
248     }
249 
250     /**
251      * @dev Approve an address to spend another addresses' tokens.
252      * @param owner The address that owns the tokens.
253      * @param spender The address that will spend the tokens.
254      * @param value The number of tokens that can be spent.
255      */
256     function _approve(address owner, address spender, uint256 value) internal {
257         require(spender != address(0));
258         require(owner != address(0));
259 
260         _allowed[owner][spender] = value;
261         emit Approval(owner, spender, value);
262     }
263 
264     /**
265      * @dev Internal function that burns an amount of the token of a given
266      * account, deducting from the sender's allowance for said account. Uses the
267      * internal burn function.
268      * Emits an Approval event (reflecting the reduced allowance).
269      * @param account The account whose tokens will be burnt.
270      * @param value The amount that will be burnt.
271      */
272     function _burnFrom(address account, uint256 value) internal {
273         _burn(account, value);
274         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
275     }
276 }
277 
278 
279 contract ERC20Detailed is IERC20 {
280     string private _name;
281     string private _symbol;
282     uint8 private _decimals;
283 
284     constructor (string memory name, string memory symbol, uint8 decimals) public {
285         _name = name;
286         _symbol = symbol;
287         _decimals = decimals;
288     }
289 
290     /**
291      * @return the name of the token.
292      */
293     function name() public view returns (string memory) {
294         return _name;
295     }
296 
297     /**
298      * @return the symbol of the token.
299      */
300     function symbol() public view returns (string memory) {
301         return _symbol;
302     }
303 
304     /**
305      * @return the number of decimals of the token.
306      */
307     function decimals() public view returns (uint8) {
308         return _decimals;
309     }
310 }
311 
312 
313 contract FXHD is ERC20, ERC20Detailed {
314     string private _name = "Electronic Payment Digital Currency";
315     string private _symbol = "FXHD";
316     uint8 private _decimals = 18;
317     uint256 public initialSupply = 880000000 * (10 ** uint256(_decimals));
318    
319     constructor() public ERC20Detailed(_name, _symbol, _decimals) {
320         _mint(msg.sender, initialSupply);
321     }
322 }