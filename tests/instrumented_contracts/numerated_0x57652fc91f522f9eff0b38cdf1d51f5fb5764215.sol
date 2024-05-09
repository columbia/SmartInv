1 pragma solidity ^0.5.2;
2 
3 interface IERC20 {
4     function transfer(address to, uint256 value) external returns (bool);
5 
6     function approve(address spender, uint256 value) external returns (bool);
7 
8     function transferFrom(address from, address to, uint256 value) external returns (bool);
9 
10     function totalSupply() external view returns (uint256);
11 
12     function balanceOf(address who) external view returns (uint256);
13 
14     function allowance(address owner, address spender) external view returns (uint256);
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 contract ERC20 is IERC20 {
22     using SafeMath for uint256;
23 
24     mapping (address => uint256) private _balances;
25 
26     mapping (address => mapping (address => uint256)) private _allowed;
27 
28     uint256 private _totalSupply;
29 
30     /**
31      * @dev Total number of tokens in existence
32      */
33     function totalSupply() public view returns (uint256) {
34         return _totalSupply;
35     }
36 
37     /**
38      * @dev Gets the balance of the specified address.
39      * @param owner The address to query the balance of.
40      * @return An uint256 representing the amount owned by the passed address.
41      */
42     function balanceOf(address owner) public view returns (uint256) {
43         return _balances[owner];
44     }
45 
46     /**
47      * @dev Function to check the amount of tokens that an owner allowed to a spender.
48      * @param owner address The address which owns the funds.
49      * @param spender address The address which will spend the funds.
50      * @return A uint256 specifying the amount of tokens still available for the spender.
51      */
52     function allowance(address owner, address spender) public view returns (uint256) {
53         return _allowed[owner][spender];
54     }
55 
56     /**
57      * @dev Transfer token for a specified address
58      * @param to The address to transfer to.
59      * @param value The amount to be transferred.
60      */
61     function transfer(address to, uint256 value) public returns (bool) {
62         _transfer(msg.sender, to, value);
63         return true;
64     }
65 
66     /**
67      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
68      * Beware that changing an allowance with this method brings the risk that someone may use both the old
69      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
70      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
71      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
72      * @param spender The address which will spend the funds.
73      * @param value The amount of tokens to be spent.
74      */
75     function approve(address spender, uint256 value) public returns (bool) {
76         _approve(msg.sender, spender, value);
77         return true;
78     }
79 
80     /**
81      * @dev Transfer tokens from one address to another.
82      * Note that while this function emits an Approval event, this is not required as per the specification,
83      * and other compliant implementations may not emit the event.
84      * @param from address The address which you want to send tokens from
85      * @param to address The address which you want to transfer to
86      * @param value uint256 the amount of tokens to be transferred
87      */
88     function transferFrom(address from, address to, uint256 value) public returns (bool) {
89         _transfer(from, to, value);
90         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
91         return true;
92     }
93 
94     /**
95      * @dev Increase the amount of tokens that an owner allowed to a spender.
96      * approve should be called when allowed_[_spender] == 0. To increment
97      * allowed value is better to use this function to avoid 2 calls (and wait until
98      * the first transaction is mined)
99      * From MonolithDAO Token.sol
100      * Emits an Approval event.
101      * @param spender The address which will spend the funds.
102      * @param addedValue The amount of tokens to increase the allowance by.
103      */
104     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
105         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
106         return true;
107     }
108 
109     /**
110      * @dev Decrease the amount of tokens that an owner allowed to a spender.
111      * approve should be called when allowed_[_spender] == 0. To decrement
112      * allowed value is better to use this function to avoid 2 calls (and wait until
113      * the first transaction is mined)
114      * From MonolithDAO Token.sol
115      * Emits an Approval event.
116      * @param spender The address which will spend the funds.
117      * @param subtractedValue The amount of tokens to decrease the allowance by.
118      */
119     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
120         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
121         return true;
122     }
123 
124     /**
125      * @dev Transfer token for a specified addresses
126      * @param from The address to transfer from.
127      * @param to The address to transfer to.
128      * @param value The amount to be transferred.
129      */
130     function _transfer(address from, address to, uint256 value) internal {
131         require(to != address(0));
132 
133         _balances[from] = _balances[from].sub(value);
134         _balances[to] = _balances[to].add(value);
135         emit Transfer(from, to, value);
136     }
137 
138     /**
139      * @dev Internal function that mints an amount of the token and assigns it to
140      * an account. This encapsulates the modification of balances such that the
141      * proper events are emitted.
142      * @param account The account that will receive the created tokens.
143      * @param value The amount that will be created.
144      */
145     function _mint(address account, uint256 value) internal {
146         require(account != address(0));
147 
148         _totalSupply = _totalSupply.add(value);
149         _balances[account] = _balances[account].add(value);
150         emit Transfer(address(0), account, value);
151     }
152 
153     /**
154      * @dev Internal function that burns an amount of the token of a given
155      * account.
156      * @param account The account whose tokens will be burnt.
157      * @param value The amount that will be burnt.
158      */
159     function _burn(address account, uint256 value) internal {
160         require(account != address(0));
161 
162         _totalSupply = _totalSupply.sub(value);
163         _balances[account] = _balances[account].sub(value);
164         emit Transfer(account, address(0), value);
165     }
166 
167     /**
168      * @dev Approve an address to spend another addresses' tokens.
169      * @param owner The address that owns the tokens.
170      * @param spender The address that will spend the tokens.
171      * @param value The number of tokens that can be spent.
172      */
173     function _approve(address owner, address spender, uint256 value) internal {
174         require(spender != address(0));
175         require(owner != address(0));
176 
177         _allowed[owner][spender] = value;
178         emit Approval(owner, spender, value);
179     }
180 
181     /**
182      * @dev Internal function that burns an amount of the token of a given
183      * account, deducting from the sender's allowance for said account. Uses the
184      * internal burn function.
185      * Emits an Approval event (reflecting the reduced allowance).
186      * @param account The account whose tokens will be burnt.
187      * @param value The amount that will be burnt.
188      */
189     function _burnFrom(address account, uint256 value) internal {
190         _burn(account, value);
191         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
192     }
193 }
194 
195 contract ERC20Burnable is ERC20 {
196     /**
197      * @dev Burns a specific amount of tokens.
198      * @param value The amount of token to be burned.
199      */
200     function burn(uint256 value) public {
201         _burn(msg.sender, value);
202     }
203 
204     /**
205      * @dev Burns a specific amount of tokens from the target address and decrements allowance
206      * @param from address The account whose tokens will be burned.
207      * @param value uint256 The amount of token to be burned.
208      */
209     function burnFrom(address from, uint256 value) public {
210         _burnFrom(from, value);
211     }
212 }
213 
214 contract ERC20Detailed is IERC20 {
215     string private _name;
216     string private _symbol;
217     uint8 private _decimals;
218 
219     constructor (string memory name, string memory symbol, uint8 decimals) public {
220         _name = name;
221         _symbol = symbol;
222         _decimals = decimals;
223     }
224 
225     /**
226      * @return the name of the token.
227      */
228     function name() public view returns (string memory) {
229         return _name;
230     }
231 
232     /**
233      * @return the symbol of the token.
234      */
235     function symbol() public view returns (string memory) {
236         return _symbol;
237     }
238 
239     /**
240      * @return the number of decimals of the token.
241      */
242     function decimals() public view returns (uint8) {
243         return _decimals;
244     }
245 }
246 
247 contract BuddyToken is ERC20, ERC20Detailed, ERC20Burnable {
248     uint8 public constant DECIMALS = 18;
249     uint256 public constant INITIAL_SUPPLY = 67000000000 * (10 ** uint256(DECIMALS));
250 
251   constructor() public ERC20Detailed("Buddy", "BUD", DECIMALS) {
252     _mint(msg.sender, INITIAL_SUPPLY);
253   }
254 }
255 
256 library SafeMath {
257     /**
258      * @dev Multiplies two unsigned integers, reverts on overflow.
259      */
260     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
261         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
262         // benefit is lost if 'b' is also tested.
263         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
264         if (a == 0) {
265             return 0;
266         }
267 
268         uint256 c = a * b;
269         require(c / a == b);
270 
271         return c;
272     }
273 
274     /**
275      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
276      */
277     function div(uint256 a, uint256 b) internal pure returns (uint256) {
278         // Solidity only automatically asserts when dividing by 0
279         require(b > 0);
280         uint256 c = a / b;
281         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
282 
283         return c;
284     }
285 
286     /**
287      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
288      */
289     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
290         require(b <= a);
291         uint256 c = a - b;
292 
293         return c;
294     }
295 
296     /**
297      * @dev Adds two unsigned integers, reverts on overflow.
298      */
299     function add(uint256 a, uint256 b) internal pure returns (uint256) {
300         uint256 c = a + b;
301         require(c >= a);
302 
303         return c;
304     }
305 
306     /**
307      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
308      * reverts when dividing by zero.
309      */
310     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
311         require(b != 0);
312         return a % b;
313     }
314 }