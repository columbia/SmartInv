1 pragma solidity 0.5.3;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
6  */
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
67 /**
68  * @title ERC20 interface
69  * @dev see https://github.com/ethereum/EIPs/issues/20
70  */
71 interface IERC20 {
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
89 contract ERC20 is IERC20 {
90     using SafeMath for uint256;
91 
92     mapping (address => uint256) private _balances;
93 
94     mapping (address => mapping (address => uint256)) private _allowed;
95 
96     uint256 private _totalSupply;
97 
98     /**
99      * @dev Total number of tokens in existence
100      */
101     function totalSupply() public view returns (uint256) {
102         return _totalSupply;
103     }
104 
105     /**
106      * @dev Gets the balance of the specified address.
107      * @param owner The address to query the balance of.
108      * @return An uint256 representing the amount owned by the passed address.
109      */
110     function balanceOf(address owner) public view returns (uint256) {
111         return _balances[owner];
112     }
113 
114     /**
115      * @dev Function to check the amount of tokens that an owner allowed to a spender.
116      * @param owner address The address which owns the funds.
117      * @param spender address The address which will spend the funds.
118      * @return A uint256 specifying the amount of tokens still available for the spender.
119      */
120     function allowance(address owner, address spender) public view returns (uint256) {
121         return _allowed[owner][spender];
122     }
123 
124     /**
125      * @dev Transfer token for a specified address
126      * @param to The address to transfer to.
127      * @param value The amount to be transferred.
128      */
129     function transfer(address to, uint256 value) public returns (bool) {
130         _transfer(msg.sender, to, value);
131         return true;
132     }
133 
134     /**
135      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
136      * Beware that changing an allowance with this method brings the risk that someone may use both the old
137      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
138      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
139      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
140      * @param spender The address which will spend the funds.
141      * @param value The amount of tokens to be spent.
142      */
143     function approve(address spender, uint256 value) public returns (bool) {
144         _approve(msg.sender, spender, value);
145         return true;
146     }
147 
148     /**
149      * @dev Transfer tokens from one address to another.
150      * Note that while this function emits an Approval event, this is not required as per the specification,
151      * and other compliant implementations may not emit the event.
152      * @param from address The address which you want to send tokens from
153      * @param to address The address which you want to transfer to
154      * @param value uint256 the amount of tokens to be transferred
155      */
156     function transferFrom(address from, address to, uint256 value) public returns (bool) {
157         _transfer(from, to, value);
158         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
159         return true;
160     }
161 
162     /**
163      * @dev Increase the amount of tokens that an owner allowed to a spender.
164      * approve should be called when allowed_[_spender] == 0. To increment
165      * allowed value is better to use this function to avoid 2 calls (and wait until
166      * the first transaction is mined)
167      * From MonolithDAO Token.sol
168      * Emits an Approval event.
169      * @param spender The address which will spend the funds.
170      * @param addedValue The amount of tokens to increase the allowance by.
171      */
172     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
173         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
174         return true;
175     }
176 
177     /**
178      * @dev Decrease the amount of tokens that an owner allowed to a spender.
179      * approve should be called when allowed_[_spender] == 0. To decrement
180      * allowed value is better to use this function to avoid 2 calls (and wait until
181      * the first transaction is mined)
182      * From MonolithDAO Token.sol
183      * Emits an Approval event.
184      * @param spender The address which will spend the funds.
185      * @param subtractedValue The amount of tokens to decrease the allowance by.
186      */
187     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
188         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
189         return true;
190     }
191 
192     /**
193      * @dev Transfer token for a specified addresses
194      * @param from The address to transfer from.
195      * @param to The address to transfer to.
196      * @param value The amount to be transferred.
197      */
198     function _transfer(address from, address to, uint256 value) internal {
199         require(to != address(0));
200 
201         _balances[from] = _balances[from].sub(value);
202         _balances[to] = _balances[to].add(value);
203         emit Transfer(from, to, value);
204     }
205 
206     /**
207      * @dev Internal function that mints an amount of the token and assigns it to
208      * an account. This encapsulates the modification of balances such that the
209      * proper events are emitted.
210      * @param account The account that will receive the created tokens.
211      * @param value The amount that will be created.
212      */
213     function _mint(address account, uint256 value) internal {
214         require(account != address(0));
215 
216         _totalSupply = _totalSupply.add(value);
217         _balances[account] = _balances[account].add(value);
218         emit Transfer(address(0), account, value);
219     }
220 
221     /**
222      * @dev Internal function that burns an amount of the token of a given
223      * account.
224      * @param account The account whose tokens will be burnt.
225      * @param value The amount that will be burnt.
226      */
227     function _burn(address account, uint256 value) internal {
228         require(account != address(0));
229 
230         _totalSupply = _totalSupply.sub(value);
231         _balances[account] = _balances[account].sub(value);
232         emit Transfer(account, address(0), value);
233     }
234 
235     /**
236      * @dev Approve an address to spend another addresses' tokens.
237      * @param owner The address that owns the tokens.
238      * @param spender The address that will spend the tokens.
239      * @param value The number of tokens that can be spent.
240      */
241     function _approve(address owner, address spender, uint256 value) internal {
242         require(spender != address(0));
243         require(owner != address(0));
244 
245         _allowed[owner][spender] = value;
246         emit Approval(owner, spender, value);
247     }
248 
249     /**
250      * @dev Internal function that burns an amount of the token of a given
251      * account, deducting from the sender's allowance for said account. Uses the
252      * internal burn function.
253      * Emits an Approval event (reflecting the reduced allowance).
254      * @param account The account whose tokens will be burnt.
255      * @param value The amount that will be burnt.
256      */
257     function _burnFrom(address account, uint256 value) internal {
258         _burn(account, value);
259         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
260     }
261 }
262 
263 
264 contract TestToken is ERC20{
265     string public constant name = "TestToken";
266     string public constant symbol = "TT";
267     uint8 public constant decimals = 18;
268     
269     uint256 public constant INITIAL_SUPPLY = 520000000 * (10 ** uint256(decimals));
270     
271     
272     constructor() public{
273         _mint(msg.sender,INITIAL_SUPPLY);
274     }
275     
276 }