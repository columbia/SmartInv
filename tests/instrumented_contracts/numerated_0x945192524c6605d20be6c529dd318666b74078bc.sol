1 pragma solidity ^0.4.24;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that revert on error
5  */
6 library SafeMath {
7 
8   /**
9   * @dev Multiplies two numbers, reverts on overflow.
10   */
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13     // benefit is lost if 'b' is also tested.
14     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15     if (a == 0) {
16       return 0;
17     }
18 
19     uint256 c = a * b;
20     require(c / a == b);
21 
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     require(b > 0); // Solidity only automatically asserts when dividing by 0
30     uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32 
33     return c;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     require(b <= a);
41     uint256 c = a - b;
42 
43     return c;
44   }
45 
46   /**
47   * @dev Adds two numbers, reverts on overflow.
48   */
49   function add(uint256 a, uint256 b) internal pure returns (uint256) {
50     uint256 c = a + b;
51     require(c >= a);
52 
53     return c;
54   }
55 
56   /**
57   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
58   * reverts when dividing by zero.
59   */
60   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
61     require(b != 0);
62     return a % b;
63   }
64 }
65 /**
66  * @title Ownable
67  * @dev The Ownable contract has an owner address, and provides basic authorization control
68  * functions, this simplifies the implementation of "user permissions".
69  */
70 contract Ownable {
71     address public owner;
72     /**
73      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
74      * account.
75      */
76       constructor() public {
77      owner = msg.sender;
78   }
79 
80     /**
81      * @dev Throws if called by any account other than the owner.
82      */
83     modifier onlyOwner() {
84         require(msg.sender == owner);
85         _;
86     }
87 
88 
89     /**
90      * @dev Allows the current owner to transfer control of the contract to a newOwner.
91      * @param newOwner The address to transfer ownership to.
92      */
93     function transferOwnership(address newOwner) onlyOwner public {
94         require(newOwner != address(0));
95         owner = newOwner;
96     }
97 
98 }
99 
100 interface IERC20 {
101   function totalSupply() external view returns (uint256);
102 
103   function balanceOf(address who) external view returns (uint256);
104 
105   function allowance(address owner, address spender)
106     external view returns (uint256);
107 
108   function transfer(address to, uint256 value) external returns (bool);
109 
110   function approve(address spender, uint256 value)
111     external returns (bool);
112 
113   function transferFrom(address from, address to, uint256 value)
114     external returns (bool);
115 
116   event Transfer(
117     address indexed from,
118     address indexed to,
119     uint256 value
120   );
121 
122   event Approval(
123     address indexed owner,
124     address indexed spender,
125     uint256 value
126   );
127 }
128 contract ERC20 is IERC20,Ownable {
129   using SafeMath for uint256;
130 
131   mapping (address => uint256) private _balances;
132 
133   mapping (address => mapping (address => uint256)) private _allowed;
134 
135   uint256 private _totalSupply;
136   
137   //Freeze parameter
138   
139   mapping (address => bool)  private _frozenAccount;
140   
141   // This notifies about accounts locked
142   event FrozenFunds(address target, bool frozen);
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
153   * @param owner The address to query the balance of.
154   * @return An uint256 representing the amount owned by the passed address.
155   */
156   function balanceOf(address owner) public view returns (uint256) {
157     return _balances[owner];
158   }
159   
160   /**
161   * @dev Gets the freeze state of the specified address.
162   * @param _address The address to query the freeze state of.
163   * @return An bool representing the state of freeze.
164   */
165   function isAccountFreezed(address _address) public view returns (bool) {
166     return _frozenAccount[_address];
167   }
168   
169 
170   /**
171    * @dev Function to check the amount of tokens that an owner allowed to a spender.
172    * @param owner address The address which owns the funds.
173    * @param spender address The address which will spend the funds.
174    * @return A uint256 specifying the amount of tokens still available for the spender.
175    */
176   function allowance(
177     address owner,
178     address spender
179    )
180     public
181     view
182     returns (uint256)
183   {
184     return _allowed[owner][spender];
185   }
186 
187   /**
188   * @dev Transfer token for a specified address
189   * @param to The address to transfer to.
190   * @param value The amount to be transferred.
191   */
192   function transfer(address to, uint256 value) public returns (bool) {
193     require(value <= _balances[msg.sender]);
194     require(!_frozenAccount[msg.sender]);  //sender should not be frozen Account
195     require(!_frozenAccount[to]);  //receiver should not be frozen Account
196     require(to != address(0));
197     _balances[msg.sender] = _balances[msg.sender].sub(value);
198     _balances[to] = _balances[to].add(value);
199     emit Transfer(msg.sender, to, value);
200     return true;
201   }
202 
203   /**
204    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
205    * Beware that changing an allowance with this method brings the risk that someone may use both the old
206    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
207    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
208    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
209    * @param spender The address which will spend the funds.
210    * @param value The amount of tokens to be spent.
211    */
212   function approve(address spender, uint256 value) public returns (bool) {
213     require(spender != address(0));
214 
215     _allowed[msg.sender][spender] = value;
216     emit Approval(msg.sender, spender, value);
217     return true;
218   }
219 
220   /**
221    * @dev Transfer tokens from one address to another
222    * @param from address The address which you want to send tokens from
223    * @param to address The address which you want to transfer to
224    * @param value uint256 the amount of tokens to be transferred
225    */
226   function transferFrom(
227     address from,
228     address to,
229     uint256 value
230   )
231     public
232     returns (bool)
233   {
234     require(value <= _balances[from]);
235     require(value <= _allowed[from][msg.sender]);
236      require(!_frozenAccount[from]);  //sender should not be frozen Account
237     require(!_frozenAccount[to]);  //receiver should not be frozen Account
238     require(to != address(0));
239 
240     _balances[from] = _balances[from].sub(value);
241     _balances[to] = _balances[to].add(value);
242     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
243     emit Transfer(from, to, value);
244     return true;
245   }
246  
247   /**
248    * @dev Internal function that mints an amount of the token and assigns it to
249    * an account. This encapsulates the modification of balances such that the
250    * proper events are emitted.
251    * @param account The account that will receive the created tokens.
252    * @param amount The amount that will be created.
253    */
254   function _mint(address account, uint256 amount) internal {
255     require(account != 0);
256     _totalSupply = _totalSupply.add(amount);
257     _balances[account] = _balances[account].add(amount);
258     emit Transfer(address(0), account, amount);
259   }
260 
261   /**
262    * @dev Internal function that burns an amount of the token of a given
263    * account.
264    * @param account The account whose tokens will be burnt.
265    * @param amount The amount that will be burnt.
266    */
267   function _burn(address account, uint256 amount) internal {
268     require(account != 0);
269     require(amount <= _balances[account]);
270     _totalSupply = _totalSupply.sub(amount);
271     _balances[account] = _balances[account].sub(amount);
272     emit Transfer(account, address(0), amount);
273   }
274   
275    
276   /**
277    * @dev Freezes the account from transferring tokens from own address to another
278    * @param target The account which will be freezed.
279    * @param freeze The decision to freeze.
280    */
281   function _freezeAccount(address target, bool freeze) internal {
282     _frozenAccount[target] = freeze;
283     emit FrozenFunds(target, freeze);
284     }
285   
286 }
287 contract BitsrentToken is ERC20{
288     string public constant name = "Bitsrent";
289     string public constant symbol = "BTR";
290     uint8 public constant decimals = 18;
291     //supply is 20 Billion
292     uint256 public constant INITIAL_SUPPLY=20000000000*(10 ** uint256(decimals));
293     
294 /**
295    * @dev Constructor that gives msg.sender all of existing tokens.
296    * minted only during contract initialization
297    */
298   constructor() public {
299     _mint(msg.sender, INITIAL_SUPPLY);
300   }
301    /**
302    * @dev function that burns an amount of the token of a given
303    * account.
304    * @param amount The amount that will be burnt.
305    **/
306   function burnToken( uint256 amount)  public {
307       _burn(msg.sender,amount);
308   }
309   
310    /**
311    * @dev Freezes the account from transferring tokens from own address to another
312    * can be called by owner only
313    **/
314   function freeze(address freezingAddress,bool decision)  onlyOwner public {
315       _freezeAccount(freezingAddress,decision);
316   }
317   
318 }