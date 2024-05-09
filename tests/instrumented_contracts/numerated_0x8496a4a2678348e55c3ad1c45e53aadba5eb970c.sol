1 pragma solidity ^0.5.7;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, reverts on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
10     // benefit is lost if 'b' is also tested.
11     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12     if (a == 0) {
13       return 0;
14     }
15 
16     uint256 c = a * b;
17     require(c / a == b);
18 
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     require(b > 0); // Solidity only automatically asserts when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29 
30     return c;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     require(b <= a);
38     uint256 c = a - b;
39 
40     return c;
41   }
42 
43   /**
44   * @dev Adds two numbers, reverts on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256) {
47     uint256 c = a + b;
48     require(c >= a);
49 
50     return c;
51   }
52 
53   /**
54   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
55   * reverts when dividing by zero.
56   */
57   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
58     require(b != 0);
59     return a % b;
60   }
61 }
62 
63 contract Ownable {
64   address public owner;
65 
66   /**
67    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
68    * account.
69    */
70   constructor() public {
71     owner = msg.sender;
72   }
73 
74 
75   /**
76    * @dev Throws if called by any account other than the owner.
77    */
78   modifier onlyOwner() {
79     require(msg.sender == owner);
80     _;
81   }
82 
83 
84   /**
85    * @dev Allows the current owner to transfer control of the contract to a newOwner.
86    * @param newOwner The address to transfer ownership to.
87    */
88   function transferOwnership(address newOwner) public onlyOwner {
89     if (newOwner != address(0)) {
90       owner = newOwner;
91     }
92   }
93 
94 }
95 
96 /**
97  * @title ERC20 interface
98  */
99 interface IERC20 {
100   function totalSupply() external view returns (uint256);
101 
102   function balanceOf(address who) external view returns (uint256);
103 
104   function allowance(address _owner, address spender)
105     external view returns (uint256);
106 
107   function transfer(address to, uint256 value) external returns (bool);
108 
109   function approve(address spender, uint256 value)
110     external returns (bool);
111 
112   function transferFrom(address from, address to, uint256 value)
113     external returns (bool);
114 
115   event Transfer(
116     address indexed from,
117     address indexed to,
118     uint256 value
119   );
120 
121   event Approval(
122     address indexed owner,
123     address indexed spender,
124     uint256 value
125   );
126 }
127 
128 /**
129  * @title Standard ERC20 token
130  *
131  * @dev Implementation of the basic standard token.
132  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
133  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
134  */
135 contract ERC20 is IERC20 {
136   using SafeMath for uint256;
137 
138   mapping (address => uint256) private _balances;
139 
140   mapping (address => mapping (address => uint256)) private _allowed;
141 
142   uint256 private _totalSupply;
143 
144   /**
145   * @dev Total number of tokens in existence
146   */
147   function totalSupply() public view returns (uint256) {
148     return _totalSupply;
149   }
150 
151   /**
152   * @dev Gets the balance of the specified address.
153   * @param _owner The address to query the balance of.
154   * @return An uint256 representing the amount owned by the passed address.
155   */
156   function balanceOf(address _owner) public view returns (uint256) {
157     return _balances[_owner];
158   }
159 
160   /**
161    * @dev Function to check the amount of tokens that an owner allowed to a spender.
162    * @param _owner address The address which owns the funds.
163    * @param spender address The address which will spend the funds.
164    * @return A uint256 specifying the amount of tokens still available for the spender.
165    */
166   function allowance(address _owner,address spender) public view returns (uint256) {
167     return _allowed[_owner][spender];
168   }
169 
170   /**
171   * @dev Transfer token for a specified address
172   * @param to The address to transfer to.
173   * @param value The amount to be transferred.
174   */
175   function transfer(address to, uint256 value) public returns (bool) {
176     require(value <= _balances[msg.sender]);
177     require(to != address(0));
178 
179     _balances[msg.sender] = _balances[msg.sender].sub(value);
180     _balances[to] = _balances[to].add(value);
181     emit Transfer(msg.sender, to, value);
182     return true;
183   }
184 
185   /**
186    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
187    * Beware that changing an allowance with this method brings the risk that someone may use both the old
188    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
189    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
190    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
191    * @param spender The address which will spend the funds.
192    * @param value The amount of tokens to be spent.
193    */
194   function approve(address spender, uint256 value) public returns (bool) {
195     require(spender != address(0));
196 
197     _allowed[msg.sender][spender] = value;
198     emit Approval(msg.sender, spender, value);
199     return true;
200   }
201 
202   /**
203    * @dev Transfer tokens from one address to another
204    * @param from address The address which you want to send tokens from
205    * @param to address The address which you want to transfer to
206    * @param value uint256 the amount of tokens to be transferred
207    */
208   function transferFrom( address from, address to,uint256 value) public returns (bool) {
209     require(value <= _balances[from]);
210     require(value <= _allowed[from][msg.sender]);
211     require(to != address(0));
212 
213     _balances[from] = _balances[from].sub(value);
214     _balances[to] = _balances[to].add(value);
215     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
216     emit Transfer(from, to, value);
217     return true;
218   }
219 
220   /**
221    * @dev Increase the amount of tokens that an owner allowed to a spender.
222    * approve should be called when allowed_[_spender] == 0. To increment
223    * allowed value is better to use this function to avoid 2 calls (and wait until
224    * the first transaction is mined)
225    * From MonolithDAO Token.sol
226    * @param spender The address which will spend the funds.
227    * @param addedValue The amount of tokens to increase the allowance by.
228    */
229   function increaseAllowance(address spender,uint256 addedValue) public returns (bool) {
230     require(spender != address(0));
231 
232     _allowed[msg.sender][spender] = (
233       _allowed[msg.sender][spender].add(addedValue));
234     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
235     return true;
236   }
237 
238   /**
239    * @dev Decrease the amount of tokens that an owner allowed to a spender.
240    * approve should be called when allowed_[_spender] == 0. To decrement
241    * allowed value is better to use this function to avoid 2 calls (and wait until
242    * the first transaction is mined)
243    * From MonolithDAO Token.sol
244    * @param spender The address which will spend the funds.
245    * @param subtractedValue The amount of tokens to decrease the allowance by.
246    */
247   function decreaseAllowance(address spender,uint256 subtractedValue) public returns (bool) {
248     require(spender != address(0));
249 
250     _allowed[msg.sender][spender] = (
251       _allowed[msg.sender][spender].sub(subtractedValue));
252     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
253     return true;
254   }
255 
256   /**
257    * @dev Internal function that mints an amount of the token and assigns it to
258    * an account. This encapsulates the modification of balances such that the
259    * proper events are emitted.
260    * @param account The account that will receive the created tokens.
261    * @param amount The amount that will be created.
262    */
263   function _mint(address account, uint256 amount) internal {
264     require(account != address(0));
265     _totalSupply = _totalSupply.add(amount);
266     _balances[account] = _balances[account].add(amount);
267     emit Transfer(address(0), account, amount);
268   }
269 
270   /**
271    * @dev Internal function that burns an amount of the token of a given
272    * account.
273    * @param account The account whose tokens will be burnt.
274    * @param amount The amount that will be burnt.
275    */
276   function _burn(address account, uint256 amount) internal {
277     require(account != address(0));
278     require(amount <= _balances[account]);
279 
280     _totalSupply = _totalSupply.sub(amount);
281     _balances[account] = _balances[account].sub(amount);
282     emit Transfer(account, address(0), amount);
283   }
284 
285 }
286 
287 contract Spin is ERC20, Ownable {
288     string public name = "Spin";
289     uint8 public decimals = 18; 
290     string public symbol = "SPIN";
291     
292     constructor(uint256 _tokenInitAmount, address _admin) public {
293         transferOwnership(_admin);
294         _mint(_admin, _tokenInitAmount);
295     }
296     
297     
298     function mint(address account, uint256 amount) public onlyOwner {
299         require(amount != 0);
300         _mint(account, amount);
301     }
302     
303     function burn(address account, uint256 amount) public onlyOwner {
304         require(amount != 0);
305         _burn(account, amount);
306     }
307 }