1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Standard ERC20 token
5  *
6  * @dev Implementation of the basic standard token.
7  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
8  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
9  */
10  
11  
12 interface IERC20 {
13   function totalSupply() external view returns (uint256);
14 
15   function balanceOf(address who) external view returns (uint256);
16 
17   function allowance(address owner, address spender)
18     external view returns (uint256);
19 
20   function transfer(address to, uint256 value) external returns (bool);
21 
22   function approve(address spender, uint256 value)
23     external returns (bool);
24 
25   function transferFrom(address from, address to, uint256 value)
26     external returns (bool);
27 
28   event Transfer(
29     address indexed from,
30     address indexed to,
31     uint256 value
32   );
33 
34   event Approval(
35     address indexed owner,
36     address indexed spender,
37     uint256 value
38   );
39 }
40 
41 library SafeMath {
42 
43   /**
44   * @dev Multiplies two numbers, reverts on overflow.
45   */
46   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
47     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
48     // benefit is lost if 'b' is also tested.
49     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
50     if (a == 0) {
51       return 0;
52     }
53 
54     uint256 c = a * b;
55     require(c / a == b);
56 
57     return c;
58   }
59 
60   /**
61   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
62   */
63   function div(uint256 a, uint256 b) internal pure returns (uint256) {
64     require(b > 0); // Solidity only automatically asserts when dividing by 0
65     uint256 c = a / b;
66     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
67 
68     return c;
69   }
70 
71   /**
72   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
73   */
74   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75     require(b <= a);
76     uint256 c = a - b;
77 
78     return c;
79   }
80 
81   /**
82   * @dev Adds two numbers, reverts on overflow.
83   */
84   function add(uint256 a, uint256 b) internal pure returns (uint256) {
85     uint256 c = a + b;
86     require(c >= a);
87 
88     return c;
89   }
90 
91   /**
92   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
93   * reverts when dividing by zero.
94   */
95   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
96     require(b != 0);
97     return a % b;
98   }
99 }
100 
101 
102 
103 contract ERC20 is IERC20 {
104   using SafeMath for uint256;
105 
106   mapping (address => uint256) internal _balances;
107 
108   mapping (address => mapping (address => uint256)) internal _allowed;
109 
110   uint256 internal _totalSupply;
111 
112   /**
113   * @dev Total number of tokens in existence
114   */
115   function totalSupply() public view returns (uint256) {
116     return _totalSupply;
117   }
118 
119   /**
120   * @dev Gets the balance of the specified address.
121   * @param owner The address to query the balance of.
122   * @return An uint256 representing the amount owned by the passed address.
123   */
124   function balanceOf(address owner) public view returns (uint256) {
125     return _balances[owner];
126   }
127 
128   /**
129    * @dev Function to check the amount of tokens that an owner allowed to a spender.
130    * @param owner address The address which owns the funds.
131    * @param spender address The address which will spend the funds.
132    * @return A uint256 specifying the amount of tokens still available for the spender.
133    */
134   function allowance(
135     address owner,
136     address spender
137    )
138     public
139     view
140     returns (uint256)
141   {
142     return _allowed[owner][spender];
143   }
144 
145   /**
146   * @dev Transfer token for a specified address
147   * @param to The address to transfer to.
148   * @param value The amount to be transferred.
149   */
150   function transfer(address to, uint256 value) public returns (bool) {
151     _transfer(msg.sender, to, value);
152     return true;
153   }
154 
155   /**
156    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
157    * Beware that changing an allowance with this method brings the risk that someone may use both the old
158    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
159    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
160    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
161    * @param spender The address which will spend the funds.
162    * @param value The amount of tokens to be spent.
163    */
164   function approve(address spender, uint256 value) public returns (bool) {
165     require(spender != address(0));
166 
167     _allowed[msg.sender][spender] = value;
168     emit Approval(msg.sender, spender, value);
169     return true;
170   }
171 
172   /**
173    * @dev Transfer tokens from one address to another
174    * @param from address The address which you want to send tokens from
175    * @param to address The address which you want to transfer to
176    * @param value uint256 the amount of tokens to be transferred
177    */
178   function transferFrom(
179     address from,
180     address to,
181     uint256 value
182   )
183     public
184     returns (bool)
185   {
186     require(value <= _allowed[from][msg.sender]);
187 
188     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
189     _transfer(from, to, value);
190     return true;
191   }
192 
193   /**
194    * @dev Increase the amount of tokens that an owner allowed to a spender.
195    * approve should be called when allowed_[_spender] == 0. To increment
196    * allowed value is better to use this function to avoid 2 calls (and wait until
197    * the first transaction is mined)
198    * From MonolithDAO Token.sol
199    * @param spender The address which will spend the funds.
200    * @param addedValue The amount of tokens to increase the allowance by.
201    */
202   function increaseAllowance(
203     address spender,
204     uint256 addedValue
205   )
206     public
207     returns (bool)
208   {
209     require(spender != address(0));
210 
211     _allowed[msg.sender][spender] = (
212       _allowed[msg.sender][spender].add(addedValue));
213     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
214     return true;
215   }
216 
217   /**
218    * @dev Decrease the amount of tokens that an owner allowed to a spender.
219    * approve should be called when allowed_[_spender] == 0. To decrement
220    * allowed value is better to use this function to avoid 2 calls (and wait until
221    * the first transaction is mined)
222    * From MonolithDAO Token.sol
223    * @param spender The address which will spend the funds.
224    * @param subtractedValue The amount of tokens to decrease the allowance by.
225    */
226   function decreaseAllowance(
227     address spender,
228     uint256 subtractedValue
229   )
230     public
231     returns (bool)
232   {
233     require(spender != address(0));
234 
235     _allowed[msg.sender][spender] = (
236       _allowed[msg.sender][spender].sub(subtractedValue));
237     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
238     return true;
239   }
240 
241   /**
242   * @dev Transfer token for a specified addresses
243   * @param from The address to transfer from.
244   * @param to The address to transfer to.
245   * @param value The amount to be transferred.
246   */
247   function _transfer(address from, address to, uint256 value) internal {
248     require(value <= _balances[from]);
249     require(to != address(0));
250 
251     _balances[from] = _balances[from].sub(value);
252     _balances[to] = _balances[to].add(value);
253     emit Transfer(from, to, value);
254   }
255 
256   /**
257    * @dev Internal function that mints an amount of the token and assigns it to
258    * an account. This encapsulates the modification of balances such that the
259    * proper events are emitted.
260    * @param account The account that will receive the created tokens.
261    * @param value The amount that will be created.
262    */
263   function _mint(address account, uint256 value) internal {
264     require(account != 0);
265     _totalSupply = _totalSupply.add(value);
266     _balances[account] = _balances[account].add(value);
267     emit Transfer(address(0), account, value);
268   }
269 
270   /**
271    * @dev Internal function that burns an amount of the token of a given
272    * account.
273    * @param account The account whose tokens will be burnt.
274    * @param value The amount that will be burnt.
275    */
276   function _burn(address account, uint256 value) internal {
277     require(account != 0);
278     require(value <= _balances[account]);
279 
280     _totalSupply = _totalSupply.sub(value);
281     _balances[account] = _balances[account].sub(value);
282     emit Transfer(account, address(0), value);
283   }
284 
285   /**
286    * @dev Internal function that burns an amount of the token of a given
287    * account, deducting from the sender's allowance for said account. Uses the
288    * internal burn function.
289    * @param account The account whose tokens will be burnt.
290    * @param value The amount that will be burnt.
291    */
292   function _burnFrom(address account, uint256 value) internal {
293     require(value <= _allowed[account][msg.sender]);
294 
295     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
296     // this function needs to emit an event with the updated approval.
297     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
298       value);
299     _burn(account, value);
300   }
301 }
302 
303 contract ActionKap is ERC20 {
304 	string public name = "ActionKaps";
305 	string public symbol = "KAPS";
306 	uint public decimals = 18;
307 	uint public INITIAL_SUPPLY = 500000000 * (10 ** decimals);
308 	
309 	constructor() public {
310 	_totalSupply = INITIAL_SUPPLY;
311 	_balances[msg.sender] = INITIAL_SUPPLY;
312 	}
313 
314 }