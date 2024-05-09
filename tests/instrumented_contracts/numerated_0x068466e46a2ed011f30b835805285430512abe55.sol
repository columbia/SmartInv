1 pragma solidity 0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     uint256 c = a * b;
21     require(c / a == b);
22 
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     require(b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     require(b <= a);
42     uint256 c = a - b;
43 
44     return c;
45   }
46 
47   /**
48   * @dev Adds two numbers, reverts on overflow.
49   */
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     require(c >= a);
53 
54     return c;
55   }
56 
57   /**
58   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59   * reverts when dividing by zero.
60   */
61   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b != 0);
63     return a % b;
64   }
65 }
66 
67 
68 /**
69  * @title Standard ERC20 token
70  *
71  * @dev Implementation of the basic standard token.
72  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
73  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
74  */
75 contract BitDomains {
76   using SafeMath for uint256;
77 
78   mapping (address => uint256) private _balances;
79 
80   mapping (address => mapping (address => uint256)) private _allowed;
81 
82   uint256 private _totalSupply;
83   
84   string private _name;
85   string private _symbol;
86   uint8 private _decimals;
87   address public owner;
88   
89   modifier onlyOwner() {
90     if (msg.sender != owner) {
91         revert();
92         }
93      _;
94         }
95 
96   uint256 private constant INITIAL_SUPPLY = 10000000000 * 10 **10; // 10 billion BTDN 
97 
98   constructor() public {
99     _name = "BitDomains";
100     _symbol = "BTDN";
101     _decimals = 10;
102     owner = msg.sender;
103     _mint(owner, INITIAL_SUPPLY);
104   }
105   
106   
107   /**
108    * @return the name of the token.
109    */
110   function name() public view returns(string) {
111     return _name;
112   }
113 
114   /**
115    * @return the symbol of the token.
116    */
117   function symbol() public view returns(string) {
118     return _symbol;
119   }
120 
121   /**
122    * @return the number of decimals of the token.
123    */
124   function decimals() public view returns(uint8) {
125     return _decimals;
126   }
127 
128 
129   /**
130   * @dev Total number of tokens in existence
131   */
132   function totalSupply() public view returns (uint256) {
133     return _totalSupply;
134   }
135 
136   /**
137   * @dev Gets the balance of the specified address.
138   * @param owner The address to query the balance of.
139   * @return An uint256 representing the amount owned by the passed address.
140   */
141   function balanceOf(address owner) public view returns (uint256) {
142     return _balances[owner];
143   }
144 
145   /**
146    * @dev Function to check the amount of tokens that an owner allowed to a spender.
147    * @param owner address The address which owns the funds.
148    * @param spender address The address which will spend the funds.
149    * @return A uint256 specifying the amount of tokens still available for the spender.
150    */
151   function allowance(
152     address owner,
153     address spender
154    )
155     public
156     view
157     returns (uint256)
158   {
159     return _allowed[owner][spender];
160   }
161 
162   /**
163   * @dev Transfer token for a specified address
164   * @param to The address to transfer to.
165   * @param value The amount to be transferred.
166   */
167   function transfer(address to, uint256 value) public returns (bool) {
168     _transfer(msg.sender, to, value);
169     return true;
170   }
171 
172   /**
173    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
174    * Beware that changing an allowance with this method brings the risk that someone may use both the old
175    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
176    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
177    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
178    * @param spender The address which will spend the funds.
179    * @param value The amount of tokens to be spent.
180    */
181   function approve(address spender, uint256 value) public returns (bool) {
182     require(spender != address(0));
183 
184     _allowed[msg.sender][spender] = value;
185     emit Approval(msg.sender, spender, value);
186     return true;
187   }
188 
189   /**
190    * @dev Transfer tokens from one address to another
191    * @param from address The address which you want to send tokens from
192    * @param to address The address which you want to transfer to
193    * @param value uint256 the amount of tokens to be transferred
194    */
195   function transferFrom(
196     address from,
197     address to,
198     uint256 value
199   )
200     public
201     returns (bool)
202   {
203     require(value <= _allowed[from][msg.sender]);
204 
205     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
206     _transfer(from, to, value);
207     return true;
208   }
209 
210   /**
211    * @dev Increase the amount of tokens that an owner allowed to a spender.
212    * approve should be called when allowed_[_spender] == 0. To increment
213    * allowed value is better to use this function to avoid 2 calls (and wait until
214    * the first transaction is mined)
215    * From MonolithDAO Token.sol
216    * @param spender The address which will spend the funds.
217    * @param addedValue The amount of tokens to increase the allowance by.
218    */
219   function increaseAllowance(
220     address spender,
221     uint256 addedValue
222   )
223     public
224     returns (bool)
225   {
226     require(spender != address(0));
227 
228     _allowed[msg.sender][spender] = (
229       _allowed[msg.sender][spender].add(addedValue));
230     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
231     return true;
232   }
233 
234   /**
235    * @dev Decrease the amount of tokens that an owner allowed to a spender.
236    * approve should be called when allowed_[_spender] == 0. To decrement
237    * allowed value is better to use this function to avoid 2 calls (and wait until
238    * the first transaction is mined)
239    * From MonolithDAO Token.sol
240    * @param spender The address which will spend the funds.
241    * @param subtractedValue The amount of tokens to decrease the allowance by.
242    */
243   function decreaseAllowance(
244     address spender,
245     uint256 subtractedValue
246   )
247     public
248     returns (bool)
249   {
250     require(spender != address(0));
251 
252     _allowed[msg.sender][spender] = (
253       _allowed[msg.sender][spender].sub(subtractedValue));
254     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
255     return true;
256   }
257 
258   /**
259   * @dev Transfer token for a specified addresses
260   * @param from The address to transfer from.
261   * @param to The address to transfer to.
262   * @param value The amount to be transferred.
263   */
264   function _transfer(address from, address to, uint256 value) internal {
265     require(value <= _balances[from]);
266     require(to != address(0));
267 
268     _balances[from] = _balances[from].sub(value);
269     _balances[to] = _balances[to].add(value);
270     emit Transfer(from, to, value);
271   }
272 
273   /**
274    * @dev Internal function that mints an amount of the token and assigns it to
275    * an account. This encapsulates the modification of balances such that the
276    * proper events are emitted.
277    * @param account The account that will receive the created tokens.
278    * @param value The amount that will be created.
279    */
280   function _mint(address account, uint256 value) internal 
281   {
282     require(account != 0);
283     _totalSupply = _totalSupply.add(value);
284     _balances[account] = _balances[account].add(value);
285     emit Transfer(address(0), account, value);
286   }
287 
288   /**
289    * @dev burn function that can be called only by owner
290    */
291   function _burn(uint256 value) external onlyOwner {
292     require(value <= _balances[msg.sender]);
293     _totalSupply = _totalSupply.sub(value);
294     _balances[msg.sender] = _balances[msg.sender].sub(value);
295     emit Transfer(msg.sender, address(0), value);
296   }
297 
298   
299   event Transfer(
300     address indexed from,
301     address indexed to,
302     uint256 value
303   );
304 
305   event Approval(
306     address indexed owner,
307     address indexed spender,
308     uint256 value
309   );
310 }