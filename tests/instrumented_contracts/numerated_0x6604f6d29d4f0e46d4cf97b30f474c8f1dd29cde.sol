1 pragma solidity ^0.5.2;
2 // produced by the Solididy File SCC(c) Danny Hwang 2018
3 // contact : dannyhwang.scc@gmail.com
4 // released under Apache 2.0 licence
5 library SafeMath {
6   /**
7     * @dev Multiplies two unsigned integers, reverts on overflow.
8     */
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
11     // benefit is lost if 'b' is also tested.
12     if (a == 0) {
13       return 0;
14     }
15     uint256 c = a * b;
16     require(c / a == b);
17     return c;
18   }
19 
20   /**
21     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
22     */
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     // Solidity only automatically asserts when dividing by 0
25     require(b > 0);
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
33     */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     require(b <= a);
36     uint256 c = a - b;
37     return c;
38   }
39 
40   /**
41     * @dev Adds two unsigned integers, reverts on overflow.
42     */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     require(c >= a);
46     return c;
47   }
48 
49   /**
50     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
51     * reverts when dividing by zero.
52     */
53   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
54     require(b != 0);
55     return a % b;
56   }
57 }
58 
59 interface IERC20 {
60   function transfer(address to, uint256 value) external returns (bool);
61   function approve(address spender, uint256 value) external returns (bool);
62   function transferFrom(address from, address to, uint256 value) external returns (bool);
63   function totalSupply() external view returns (uint256);
64   function balanceOf(address who) external view returns (uint256);
65   function allowance(address owner, address spender) external view returns (uint256);
66   event Transfer(address indexed from, address indexed to, uint256 value);
67   event Approval(address indexed owner, address indexed spender, uint256 value);
68 }
69 
70 contract ERC20 is IERC20 {
71   using SafeMath for uint256;
72   mapping (address => uint256) private _balances;
73   mapping (address => mapping (address => uint256)) private _allowed;
74   uint256 private _totalSupply;
75 
76   /**
77     * @dev Total number of tokens in existence.
78     */
79   function totalSupply() public view returns (uint256) {
80     return _totalSupply;
81   }
82 
83   /**
84     * @dev Gets the balance of the specified address.
85     * @param owner The address to query the balance of.
86     * @return A uint256 representing the amount owned by the passed address.
87     */
88   function balanceOf(address owner) public view returns (uint256) {
89     return _balances[owner];
90   }
91 
92   /**
93     * @dev Function to check the amount of tokens that an owner allowed to a spender.
94     * @param owner address The address which owns the funds.
95     * @param spender address The address which will spend the funds.
96     * @return A uint256 specifying the amount of tokens still available for the spender.
97     */
98   function allowance(address owner, address spender) public view returns (uint256) {
99     return _allowed[owner][spender];
100   }
101 
102   /**
103     * @dev Transfer token to a specified address.
104     * @param to The address to transfer to.
105     * @param value The amount to be transferred.
106     */
107   function transfer(address to, uint256 value) public returns (bool) {
108     _transfer(msg.sender, to, value);
109     return true;
110   }
111 
112   /**
113     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
114     * Beware that changing an allowance with this method brings the risk that someone may use both the old
115     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
116     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
117     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
118     * @param spender The address which will spend the funds.
119     * @param value The amount of tokens to be spent.
120     */
121   function approve(address spender, uint256 value) public returns (bool) {
122     _approve(msg.sender, spender, value);
123     return true;
124   }
125 
126   /**
127     * @dev Transfer tokens from one address to another.
128     * Note that while this function emits an Approval event, this is not required as per the specification,
129     * and other compliant implementations may not emit the event.
130     * @param from address The address which you want to send tokens from
131     * @param to address The address which you want to transfer to
132     * @param value uint256 the amount of tokens to be transferred
133     */
134   function transferFrom(address from, address to, uint256 value) public returns (bool) {
135     _transfer(from, to, value);
136     _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
137     return true;
138   }
139 
140   /**
141     * @dev Increase the amount of tokens that an owner allowed to a spender.
142     * approve should be called when _allowed[msg.sender][spender] == 0. To increment
143     * allowed value is better to use this function to avoid 2 calls (and wait until
144     * the first transaction is mined)
145     * From MonolithDAO Token.sol
146     * Emits an Approval event.
147     * @param spender The address which will spend the funds.
148     * @param addedValue The amount of tokens to increase the allowance by.
149     */
150   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
151     _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
152     return true;
153   }
154 
155   /**
156     * @dev Decrease the amount of tokens that an owner allowed to a spender.
157     * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
158     * allowed value is better to use this function to avoid 2 calls (and wait until
159     * the first transaction is mined)
160     * From MonolithDAO Token.sol
161     * Emits an Approval event.
162     * @param spender The address which will spend the funds.
163     * @param subtractedValue The amount of tokens to decrease the allowance by.
164     */
165   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
166     _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
167     return true;
168   }
169 
170   /**
171     * @dev Transfer token for a specified addresses.
172     * @param from The address to transfer from.
173     * @param to The address to transfer to.
174     * @param value The amount to be transferred.
175     */
176   function _transfer(address from, address to, uint256 value) internal {
177     require(to != address(0)); 
178     _balances[from] = _balances[from].sub(value);
179     _balances[to] = _balances[to].add(value);
180     emit Transfer(from, to, value);
181   }
182 
183   /**
184     * @dev Internal function that mints an amount of the token and assigns it to
185     * an account. This encapsulates the modification of balances such that the
186     * proper events are emitted.
187     * @param account The account that will receive the created tokens.
188     * @param value The amount that will be created.
189     */
190   function _mint(address account, uint256 value) internal {
191     require(account != address(0));
192     _totalSupply = _totalSupply.add(value);
193     _balances[account] = _balances[account].add(value);
194     emit Transfer(address(0), account, value);
195   }
196 
197   /**
198     * @dev Internal function that burns an amount of the token of a given
199     * account.
200     * @param account The account whose tokens will be burnt.
201     * @param value The amount that will be burnt.
202     */
203   function _burn(address account, uint256 value) internal {
204     require(account != address(0));
205     _totalSupply = _totalSupply.sub(value);
206     _balances[account] = _balances[account].sub(value);
207     emit Transfer(account, address(0), value);
208   }
209 
210   /**
211     * @dev Approve an address to spend another addresses' tokens.
212     * @param owner The address that owns the tokens.
213     * @param spender The address that will spend the tokens.
214     * @param value The number of tokens that can be spent.
215     */
216   function _approve(address owner, address spender, uint256 value) internal {
217     require(spender != address(0));
218     require(owner != address(0));
219     _allowed[owner][spender] = value;
220     emit Approval(owner, spender, value);
221   }
222 
223   /**
224     * @dev Internal function that burns an amount of the token of a given
225     * account, deducting from the sender's allowance for said account. Uses the
226     * internal burn function.
227     * Emits an Approval event (reflecting the reduced allowance).
228     * @param account The account whose tokens will be burnt.
229     * @param value The amount that will be burnt.
230     */
231   function _burnFrom(address account, uint256 value) internal {
232     _burn(account, value);
233     _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
234   }
235 }
236 
237 contract ERC20Detailed is IERC20 {
238   string private _name;
239   string private _symbol;
240   uint8 private _decimals;
241   constructor (string memory name, string memory symbol, uint8 decimals) public {
242       _name = name;
243       _symbol = symbol;
244       _decimals = decimals;
245   }
246 
247   /**
248     * @return the name of the token.
249     */
250   function name() public view returns (string memory) {
251     return _name;
252   }
253 
254   /**
255     * @return the symbol of the token.
256     */
257   function symbol() public view returns (string memory) {
258     return _symbol;
259   }
260 
261   /**
262     * @return the number of decimals of the token.
263     */
264   function decimals() public view returns (uint8) {
265     return _decimals;
266   }
267 }
268 
269 contract ERC20Burnable is ERC20 {
270   /**
271     * @dev Burns a specific amount of tokens.
272     * @param value The amount of token to be burned.
273     */
274   function burn(uint256 value) public {
275     _burn(msg.sender, value);
276   }
277 
278   /**
279     * @dev Burns a specific amount of tokens from the target address and decrements allowance.
280     * @param from address The account whose tokens will be burned.
281     * @param value uint256 The amount of token to be burned.
282     */
283   function burnFrom(address from, uint256 value) public {
284     _burnFrom(from, value);
285   }
286 }
287 
288 contract Petra is ERC20, ERC20Detailed, ERC20Burnable {
289   uint8 public constant DECIMALS = 18;
290   uint256 public constant INITIAL_SUPPLY = 7700000000 * (10 ** uint256(DECIMALS));
291 
292   /**
293     * @dev Constructor that gives msg.sender all of existing tokens.
294     */
295   constructor () public ERC20Detailed("Petra", "PETA", DECIMALS) {
296     _mint(msg.sender, INITIAL_SUPPLY);
297   }
298 }