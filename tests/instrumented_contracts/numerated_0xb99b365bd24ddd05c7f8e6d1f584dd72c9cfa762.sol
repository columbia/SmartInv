1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Roles
5  * @dev Library for managing addresses assigned to a Role.
6  */
7 library Roles {
8   struct Role {
9     mapping (address => bool) bearer;
10   }
11 
12   /**
13    * @dev give an account access to this role
14    */
15   function add(Role storage role, address account) internal {
16     require(account != address(0));
17     role.bearer[account] = true;
18   }
19 
20   /**
21    * @dev remove an account's access to this role
22    */
23   function remove(Role storage role, address account) internal {
24     require(account != address(0));
25     role.bearer[account] = false;
26   }
27 
28   /**
29    * @dev check if an account has this role
30    * @return bool
31    */
32   function has(Role storage role, address account)  internal  view    returns (bool)
33   {
34     require(account != address(0));
35     return role.bearer[account];
36   }
37 }
38 
39 
40 contract MinterRole {
41   using Roles for Roles.Role;
42 
43   event MinterAdded(address indexed account);
44   event MinterRemoved(address indexed account);
45 
46   Roles.Role private minters;
47 
48   constructor() public {
49     minters.add(msg.sender);
50   }
51 
52   modifier onlyMinter() {
53     require(isMinter(msg.sender));
54     _;
55   }
56 
57   function isMinter(address account) public view returns (bool) {
58     return minters.has(account);
59   }
60 
61   function addMinter(address account) public onlyMinter {
62     minters.add(account);
63     emit MinterAdded(account);
64   }
65 
66   function renounceMinter() public {
67     minters.remove(msg.sender);
68   }
69 
70   function _removeMinter(address account) internal {
71     minters.remove(account);
72     emit MinterRemoved(account);
73   }
74 }
75 
76 /**
77  * @title SafeMath
78  * @dev Math operations with safety checks that revert on error
79  */
80 library SafeMath {
81 
82   /**
83   * @dev Multiplies two numbers, reverts on overflow.
84   */
85   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
86     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
87     // benefit is lost if 'b' is also tested.
88     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
89     if (a == 0) {
90       return 0;
91     }
92 
93     uint256 c = a * b;
94     require(c / a == b);
95 
96     return c;
97   }
98 
99   /**
100   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
101   */
102   function div(uint256 a, uint256 b) internal pure returns (uint256) {
103     require(b > 0); // Solidity only automatically asserts when dividing by 0
104     uint256 c = a / b;
105     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
106 
107     return c;
108   }
109 
110   /**
111   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
112   */
113   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
114     require(b <= a);
115     uint256 c = a - b;
116 
117     return c;
118   }
119 
120   /**
121   * @dev Adds two numbers, reverts on overflow.
122   */
123   function add(uint256 a, uint256 b) internal pure returns (uint256) {
124     uint256 c = a + b;
125     require(c >= a);
126 
127     return c;
128   }
129 
130   /**
131   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
132   * reverts when dividing by zero.
133   */
134   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
135     require(b != 0);
136     return a % b;
137   }
138 }
139 
140 
141 /**
142  * @title ERC20 interface
143  * @dev see https://github.com/ethereum/EIPs/issues/20
144  */
145 interface IERC20 {
146   function totalSupply() external view returns (uint256);
147 
148   function balanceOf(address who) external view returns (uint256);
149 
150   function allowance(address owner, address spender)
151     external view returns (uint256);
152 
153   function transfer(address to, uint256 value) external returns (bool);
154 
155   function approve(address spender, uint256 value)
156     external returns (bool);
157 
158   function transferFrom(address from, address to, uint256 value)
159     external returns (bool);
160 
161   event Transfer(
162     address indexed from,
163     address indexed to,
164     uint256 value
165   );
166 
167   event Approval(
168     address indexed owner,
169     address indexed spender,
170     uint256 value
171   );
172 }
173 
174 
175 /**
176  * @title Standard ERC20 token
177  *
178  * @dev Implementation of the basic standard token.
179  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
180  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
181  */
182 contract ERC20 is IERC20 {
183   using SafeMath for uint256;
184 
185   mapping (address => uint256) private _balances;
186 
187   mapping (address => mapping (address => uint256)) private _allowed;
188 
189   uint256 private _totalSupply;
190 
191   /**
192   * @dev Total number of tokens in existence
193   */
194   function totalSupply() public view returns (uint256) {
195     return _totalSupply;
196   }
197 
198   /**
199   * @dev Gets the balance of the specified address.
200   * @param owner The address to query the balance of.
201   * @return An uint256 representing the amount owned by the passed address.
202   */
203   function balanceOf(address owner) public view returns (uint256) {
204     return _balances[owner];
205   }
206 
207   /**
208    * @dev Function to check the amount of tokens that an owner allowed to a spender.
209    * @param owner address The address which owns the funds.
210    * @param spender address The address which will spend the funds.
211    * @return A uint256 specifying the amount of tokens still available for the spender.
212    */
213   function allowance(  address owner,  address spender   )  public    view    returns (uint256)
214   {
215     return _allowed[owner][spender];
216   }
217 
218   /**
219   * @dev Transfer token for a specified address
220   * @param to The address to transfer to.
221   * @param value The amount to be transferred.
222   */
223   function transfer(address to, uint256 value) public returns (bool) {
224     require(value <= _balances[msg.sender]);
225     require(to != address(0));
226 
227     _balances[msg.sender] = _balances[msg.sender].sub(value);
228     _balances[to] = _balances[to].add(value);
229     emit Transfer(msg.sender, to, value);
230     return true;
231   }
232 
233   /**
234    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
235    * Beware that changing an allowance with this method brings the risk that someone may use both the old
236    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
237    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
238    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
239    * @param spender The address which will spend the funds.
240    * @param value The amount of tokens to be spent.
241    */
242   function approve(address spender, uint256 value) public returns (bool) {
243     require(spender != address(0));
244 
245     _allowed[msg.sender][spender] = value;
246     emit Approval(msg.sender, spender, value);
247     return true;
248   }
249 
250   /**
251    * @dev Transfer tokens from one address to another
252    * @param from address The address which you want to send tokens from
253    * @param to address The address which you want to transfer to
254    * @param value uint256 the amount of tokens to be transferred
255    */
256   function transferFrom(    address from,    address to,    uint256 value  )    public    returns (bool)
257   {
258     require(value <= _balances[from]);
259     require(value <= _allowed[from][msg.sender]);
260     require(to != address(0));
261 
262     _balances[from] = _balances[from].sub(value);
263     _balances[to] = _balances[to].add(value);
264     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
265     emit Transfer(from, to, value);
266     return true;
267   }
268 
269   /**
270    * @dev Internal function that mints an amount of the token and assigns it to
271    * an account. This encapsulates the modification of balances such that the
272    * proper events are emitted.
273    * @param account The account that will receive the created tokens.
274    * @param amount The amount that will be created.
275    */
276   function _mint(address account, uint256 amount) internal {
277     require(account != 0);
278     _totalSupply = _totalSupply.add(amount);
279     _balances[account] = _balances[account].add(amount);
280     emit Transfer(address(0), account, amount);
281   }
282 
283 }
284 
285 /**
286  * @title ERC20Mintable
287  * @dev ERC20 minting logic
288  */
289 contract VUXMintable is ERC20, MinterRole {
290 
291   string public constant name = "VUX";
292   string public constant symbol = "VUX";
293   uint8 public constant decimals = 18;
294 
295   uint256 public constant INITIAL_SUPPLY = 10000000000 * (10 ** uint256(decimals));
296 
297 
298   /**
299    * @dev Constructor that gives msg.sender all of existing tokens.
300    */
301   constructor() public {
302     _mint(msg.sender, INITIAL_SUPPLY);
303   }
304 
305 /**
306   *铸币方法
307 */
308   function mint(  address to,  uint256 amount  )  public  onlyMinter      returns (bool)
309   {
310     _mint(to, amount);
311     return true;
312   }
313 
314 }