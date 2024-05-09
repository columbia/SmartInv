1 pragma solidity ^0.5.2;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 // flattened :  Tuesday, 02-Apr-19 02:46:17 UTC
6 library SafeMath {
7     /**
8      * @dev Multiplies two unsigned integers, reverts on overflow.
9      */
10     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
12         // benefit is lost if 'b' is also tested.
13         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
14         if (a == 0) {
15             return 0;
16         }
17 
18         uint256 c = a * b;
19         require(c / a == b);
20 
21         return c;
22     }
23 
24     /**
25      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
26      */
27     function div(uint256 a, uint256 b) internal pure returns (uint256) {
28         // Solidity only automatically asserts when dividing by 0
29         require(b > 0);
30         uint256 c = a / b;
31         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32 
33         return c;
34     }
35 
36     /**
37      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
38      */
39     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40         require(b <= a);
41         uint256 c = a - b;
42 
43         return c;
44     }
45 
46     /**
47      * @dev Adds two unsigned integers, reverts on overflow.
48      */
49     function add(uint256 a, uint256 b) internal pure returns (uint256) {
50         uint256 c = a + b;
51         require(c >= a);
52 
53         return c;
54     }
55 
56     /**
57      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
58      * reverts when dividing by zero.
59      */
60     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
61         require(b != 0);
62         return a % b;
63     }
64 }
65 
66 interface IERC20 {
67     function transfer(address to, uint256 value) external returns (bool);
68 
69     function approve(address spender, uint256 value) external returns (bool);
70 
71     function transferFrom(address from, address to, uint256 value) external returns (bool);
72 
73     function totalSupply() external view returns (uint256);
74 
75     function balanceOf(address who) external view returns (uint256);
76 
77     function allowance(address owner, address spender) external view returns (uint256);
78 
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 
81     event Approval(address indexed owner, address indexed spender, uint256 value);
82 }
83 
84 contract ERC20 is IERC20 {
85     using SafeMath for uint256;
86 
87     mapping (address => uint256) private _balances;
88 
89     mapping (address => mapping (address => uint256)) private _allowed;
90 
91     uint256 private _totalSupply;
92 
93     /**
94      * @dev Total number of tokens in existence.
95      */
96     function totalSupply() public view returns (uint256) {
97         return _totalSupply;
98     }
99 
100     /**
101      * @dev Gets the balance of the specified address.
102      * @param owner The address to query the balance of.
103      * @return A uint256 representing the amount owned by the passed address.
104      */
105     function balanceOf(address owner) public view returns (uint256) {
106         return _balances[owner];
107     }
108 
109     /**
110      * @dev Function to check the amount of tokens that an owner allowed to a spender.
111      * @param owner address The address which owns the funds.
112      * @param spender address The address which will spend the funds.
113      * @return A uint256 specifying the amount of tokens still available for the spender.
114      */
115     function allowance(address owner, address spender) public view returns (uint256) {
116         return _allowed[owner][spender];
117     }
118 
119     /**
120      * @dev Transfer token to a specified address.
121      * @param to The address to transfer to.
122      * @param value The amount to be transferred.
123      */
124     function transfer(address to, uint256 value) public returns (bool) {
125         _transfer(msg.sender, to, value);
126         return true;
127     }
128 
129     /**
130      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
131      * Beware that changing an allowance with this method brings the risk that someone may use both the old
132      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
133      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
134      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
135      * @param spender The address which will spend the funds.
136      * @param value The amount of tokens to be spent.
137      */
138     function approve(address spender, uint256 value) public returns (bool) {
139         _approve(msg.sender, spender, value);
140         return true;
141     }
142 
143     /**
144      * @dev Transfer tokens from one address to another.
145      * Note that while this function emits an Approval event, this is not required as per the specification,
146      * and other compliant implementations may not emit the event.
147      * @param from address The address which you want to send tokens from
148      * @param to address The address which you want to transfer to
149      * @param value uint256 the amount of tokens to be transferred
150      */
151     function transferFrom(address from, address to, uint256 value) public returns (bool) {
152         _transfer(from, to, value);
153         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
154         return true;
155     }
156 
157     /**
158      * @dev Increase the amount of tokens that an owner allowed to a spender.
159      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
160      * allowed value is better to use this function to avoid 2 calls (and wait until
161      * the first transaction is mined)
162      * From MonolithDAO Token.sol
163      * Emits an Approval event.
164      * @param spender The address which will spend the funds.
165      * @param addedValue The amount of tokens to increase the allowance by.
166      */
167     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
168         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
169         return true;
170     }
171 
172     /**
173      * @dev Decrease the amount of tokens that an owner allowed to a spender.
174      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
175      * allowed value is better to use this function to avoid 2 calls (and wait until
176      * the first transaction is mined)
177      * From MonolithDAO Token.sol
178      * Emits an Approval event.
179      * @param spender The address which will spend the funds.
180      * @param subtractedValue The amount of tokens to decrease the allowance by.
181      */
182     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
183         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
184         return true;
185     }
186 
187     /**
188      * @dev Transfer token for a specified addresses.
189      * @param from The address to transfer from.
190      * @param to The address to transfer to.
191      * @param value The amount to be transferred.
192      */
193     function _transfer(address from, address to, uint256 value) internal {
194         require(to != address(0));
195 
196         _balances[from] = _balances[from].sub(value);
197         _balances[to] = _balances[to].add(value);
198         emit Transfer(from, to, value);
199     }
200 
201     /**
202      * @dev Internal function that mints an amount of the token and assigns it to
203      * an account. This encapsulates the modification of balances such that the
204      * proper events are emitted.
205      * @param account The account that will receive the created tokens.
206      * @param value The amount that will be created.
207      */
208     function _mint(address account, uint256 value) internal {
209         require(account != address(0));
210 
211         _totalSupply = _totalSupply.add(value);
212         _balances[account] = _balances[account].add(value);
213         emit Transfer(address(0), account, value);
214     }
215 
216     /**
217      * @dev Internal function that burns an amount of the token of a given
218      * account.
219      * @param account The account whose tokens will be burnt.
220      * @param value The amount that will be burnt.
221      */
222     function _burn(address account, uint256 value) internal {
223         require(account != address(0));
224 
225         _totalSupply = _totalSupply.sub(value);
226         _balances[account] = _balances[account].sub(value);
227         emit Transfer(account, address(0), value);
228     }
229 
230     /**
231      * @dev Approve an address to spend another addresses' tokens.
232      * @param owner The address that owns the tokens.
233      * @param spender The address that will spend the tokens.
234      * @param value The number of tokens that can be spent.
235      */
236     function _approve(address owner, address spender, uint256 value) internal {
237         require(spender != address(0));
238         require(owner != address(0));
239 
240         _allowed[owner][spender] = value;
241         emit Approval(owner, spender, value);
242     }
243 
244     /**
245      * @dev Internal function that burns an amount of the token of a given
246      * account, deducting from the sender's allowance for said account. Uses the
247      * internal burn function.
248      * Emits an Approval event (reflecting the reduced allowance).
249      * @param account The account whose tokens will be burnt.
250      * @param value The amount that will be burnt.
251      */
252     function _burnFrom(address account, uint256 value) internal {
253         _burn(account, value);
254         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
255     }
256 }
257 
258 contract ERC20Detailed is IERC20 {
259     string private _name;
260     string private _symbol;
261     uint8 private _decimals;
262 
263     constructor (string memory name, string memory symbol, uint8 decimals) public {
264         _name = name;
265         _symbol = symbol;
266         _decimals = decimals;
267     }
268 
269     /**
270      * @return the name of the token.
271      */
272     function name() public view returns (string memory) {
273         return _name;
274     }
275 
276     /**
277      * @return the symbol of the token.
278      */
279     function symbol() public view returns (string memory) {
280         return _symbol;
281     }
282 
283     /**
284      * @return the number of decimals of the token.
285      */
286     function decimals() public view returns (uint8) {
287         return _decimals;
288     }
289 }
290 
291 contract ERC20Burnable is ERC20 {
292     /**
293      * @dev Burns a specific amount of tokens.
294      * @param value The amount of token to be burned.
295      */
296     function burn(uint256 value) public {
297         _burn(msg.sender, value);
298     }
299 
300     /**
301      * @dev Burns a specific amount of tokens from the target address and decrements allowance.
302      * @param from address The account whose tokens will be burned.
303      * @param value uint256 The amount of token to be burned.
304      */
305     function burnFrom(address from, uint256 value) public {
306         _burnFrom(from, value);
307     }
308 }
309 
310 contract FintechCoin is ERC20, ERC20Detailed, ERC20Burnable {
311     uint8 public constant DECIMALS = 18;
312     uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(DECIMALS));
313 
314     /**
315      * @dev Constructor that gives msg.sender all of existing tokens.
316      */
317     constructor () public ERC20Detailed("FintechCoin", "FINT", DECIMALS) {
318         _mint(msg.sender, INITIAL_SUPPLY);
319     }
320 }