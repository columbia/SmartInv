1 pragma solidity ^0.4.25;
2 
3 // File: contracts\math\SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that revert on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, reverts on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     uint256 c = a * b;
23     require(c / a == b);
24 
25     return c;
26   }
27 
28   /**
29   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
30   */
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     require(b > 0); // Solidity only automatically asserts when dividing by 0
33     uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36     return c;
37   }
38 
39   /**
40   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41   */
42   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43     require(b <= a);
44     uint256 c = a - b;
45 
46     return c;
47   }
48 
49   /**
50   * @dev Adds two numbers, reverts on overflow.
51   */
52   function add(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a + b;
54     require(c >= a);
55 
56     return c;
57   }
58 
59   /**
60   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
61   * reverts when dividing by zero.
62   */
63   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64     require(b != 0);
65     return a % b;
66   }
67 }
68 
69 // File: contracts\token\ERC20\IERC20.sol
70 
71 /**
72  * @title ERC20 interface
73  * @dev see https://github.com/ethereum/EIPs/issues/20
74  */
75 interface IERC20 {
76   function totalSupply() external view returns (uint256);
77 
78   function balanceOf(address who) external view returns (uint256);
79 
80   function allowance(address owner, address spender)
81     external view returns (uint256);
82 
83   function transfer(address to, uint256 value) external returns (bool);
84 
85   function approve(address spender, uint256 value)
86     external returns (bool);
87 
88   function transferFrom(address from, address to, uint256 value)
89     external returns (bool);
90 
91   event Transfer(
92     address indexed from,
93     address indexed to,
94     uint256 value
95   );
96 
97   event Approval(
98     address indexed owner,
99     address indexed spender,
100     uint256 value
101   );
102 }
103 
104 // File: contracts\token\ERC20\ERC20.sol
105 
106 /**
107  * @title Standard ERC20 token
108  *
109  * @dev Implementation of the basic standard token.
110  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
111  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
112  */
113 contract Victory is IERC20 {
114   using SafeMath for uint256;
115 
116   mapping (address => uint256) private _balances;
117 
118   mapping (address => mapping (address => uint256)) private _allowed;
119   string public name;                  
120   uint8 public decimals;              
121   string public symbol;  
122   uint256 private _totalSupply;
123   address public _owner;
124   event OwnershipTransferred(
125     address indexed previousOwner,
126     address indexed newOwner
127   );
128   
129    modifier onlyOwner() {
130     require(isOwner());
131     _;
132   }
133   function isOwner() public view returns(bool) {
134     return msg.sender == _owner;
135   }
136 
137     constructor() public {
138             _owner = msg.sender;
139             _balances[msg.sender] = 1000000000000E18;             
140             _totalSupply = 1000000000000E18;                        
141             name = "Victory Protocol";                                  
142             decimals = 18;                            
143             symbol = "VIC";                              
144         }
145 
146 
147   /**
148   * @dev Total number of tokens in existence
149   */
150   function totalSupply() public view returns (uint256) {
151     return _totalSupply;
152   }
153 
154   /**
155   * @dev Gets the balance of the specified address.
156   * @param owner The address to query the balance of.
157   * @return An uint256 representing the amount owned by the passed address.
158   */
159   function balanceOf(address owner) public view returns (uint256) {
160     return _balances[owner];
161   }
162 
163   /**
164    * @dev Function to check the amount of tokens that an owner allowed to a spender.
165    * @param owner address The address which owns the funds.
166    * @param spender address The address which will spend the funds.
167    * @return A uint256 specifying the amount of tokens still available for the spender.
168    */
169   function allowance(
170     address owner,
171     address spender
172    )
173     public
174     view
175     returns (uint256)
176   {
177     return _allowed[owner][spender];
178   }
179 
180   /**
181   * @dev Transfer token for a specified address
182   * @param to The address to transfer to.
183   * @param value The amount to be transferred.
184   */
185   function transfer(address to, uint256 value) public returns (bool) {
186     _transfer(msg.sender, to, value);
187     return true;
188   }
189 
190   /**
191    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
192    * Beware that changing an allowance with this method brings the risk that someone may use both the old
193    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
194    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
195    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
196    * @param spender The address which will spend the funds.
197    * @param value The amount of tokens to be spent.
198    */
199   function approve(address spender, uint256 value) public returns (bool) {
200     require(spender != address(0));
201 
202     _allowed[msg.sender][spender] = value;
203     emit Approval(msg.sender, spender, value);
204     return true;
205   }
206 
207   /**
208    * @dev Transfer tokens from one address to another
209    * @param from address The address which you want to send tokens from
210    * @param to address The address which you want to transfer to
211    * @param value uint256 the amount of tokens to be transferred
212    */
213   function transferFrom(
214     address from,
215     address to,
216     uint256 value
217   )
218     public
219     returns (bool)
220   {
221     require(value <= _allowed[from][msg.sender]);
222 
223     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
224     _transfer(from, to, value);
225     return true;
226   }
227 
228   /**
229    * @dev Increase the amount of tokens that an owner allowed to a spender.
230    * approve should be called when allowed_[_spender] == 0. To increment
231    * allowed value is better to use this function to avoid 2 calls (and wait until
232    * the first transaction is mined)
233    * From MonolithDAO Token.sol
234    * @param spender The address which will spend the funds.
235    * @param addedValue The amount of tokens to increase the allowance by.
236    */
237   function increaseAllowance(
238     address spender,
239     uint256 addedValue
240   )
241     public
242     returns (bool)
243   {
244     require(spender != address(0));
245 
246     _allowed[msg.sender][spender] = (
247       _allowed[msg.sender][spender].add(addedValue));
248     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
249     return true;
250   }
251 
252   /**
253    * @dev Decrease the amount of tokens that an owner allowed to a spender.
254    * approve should be called when allowed_[_spender] == 0. To decrement
255    * allowed value is better to use this function to avoid 2 calls (and wait until
256    * the first transaction is mined)
257    * From MonolithDAO Token.sol
258    * @param spender The address which will spend the funds.
259    * @param subtractedValue The amount of tokens to decrease the allowance by.
260    */
261   function decreaseAllowance(
262     address spender,
263     uint256 subtractedValue
264   )
265     public
266     returns (bool)
267   {
268     require(spender != address(0));
269 
270     _allowed[msg.sender][spender] = (
271       _allowed[msg.sender][spender].sub(subtractedValue));
272     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
273     return true;
274   }
275 
276   /**
277   * @dev Transfer token for a specified addresses
278   * @param from The address to transfer from.
279   * @param to The address to transfer to.
280   * @param value The amount to be transferred.
281   */
282   function _transfer(address from, address to, uint256 value) internal {
283     require(value <= _balances[from]);
284     require(to != address(0));
285 
286     _balances[from] = _balances[from].sub(value);
287     _balances[to] = _balances[to].add(value);
288     emit Transfer(from, to, value);
289   }
290 
291   /**
292    * @dev Internal function that mints an amount of the token and assigns it to
293    * an account. This encapsulates the modification of balances such that the
294    * proper events are emitted.
295    * @param account The account that will receive the created tokens.
296    * @param value The amount that will be created.
297    */
298   function _mint(address account, uint256 value) internal {
299     require(account != 0);
300     _totalSupply = _totalSupply.add(value);
301     _balances[account] = _balances[account].add(value);
302     emit Transfer(address(0), account, value);
303   }
304   
305   function burn(uint256 value) public {
306     _burn(msg.sender, value);
307   }
308   
309   function burnFrom(address from, uint256 value) public {
310     _burnFrom(from, value);
311   }
312 
313   /**
314    * @dev Internal function that burns an amount of the token of a given
315    * account.
316    * @param account The account whose tokens will be burnt.
317    * @param value The amount that will be burnt.
318    */
319   function _burn(address account, uint256 value) internal {
320     require(account != 0);
321     require(value <= _balances[account]);
322 
323     _totalSupply = _totalSupply.sub(value);
324     _balances[account] = _balances[account].sub(value);
325     emit Transfer(account, address(0), value);
326   }
327 
328   /**
329    * @dev Internal function that burns an amount of the token of a given
330    * account, deducting from the sender's allowance for said account. Uses the
331    * internal burn function.
332    * @param account The account whose tokens will be burnt.
333    * @param value The amount that will be burnt.
334    */
335   function _burnFrom(address account, uint256 value) internal {
336     require(value <= _allowed[account][msg.sender]);
337 
338     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
339     // this function needs to emit an event with the updated approval.
340     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
341       value);
342     _burn(account, value);
343   }
344   
345   function transferOwnership(address newOwner) public onlyOwner {
346     _transferOwnership(newOwner);
347   }
348   function _transferOwnership(address newOwner) internal {
349     require(newOwner != address(0));
350     emit OwnershipTransferred(_owner, newOwner);
351     _owner = newOwner;
352   }
353   
354 }