1 pragma solidity ^0.4.24;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 // input  /home/dave/Documents/Play/CFT/contracts/cft.sol
6 // flattened :  Sunday, 25-Nov-18 23:13:02 UTC
7 interface IERC20 {
8   function totalSupply() external view returns (uint256);
9 
10   function balanceOf(address who) external view returns (uint256);
11 
12   function allowance(address owner, address spender)
13     external view returns (uint256);
14 
15   function transfer(address to, uint256 value) external returns (bool);
16 
17   function approve(address spender, uint256 value)
18     external returns (bool);
19 
20   function transferFrom(address from, address to, uint256 value)
21     external returns (bool);
22 
23   event Transfer(
24     address indexed from,
25     address indexed to,
26     uint256 value
27   );
28 
29   event Approval(
30     address indexed owner,
31     address indexed spender,
32     uint256 value
33   );
34 }
35 
36 library SafeMath {
37 
38   /**
39   * @dev Multiplies two numbers, reverts on overflow.
40   */
41   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
42     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
43     // benefit is lost if 'b' is also tested.
44     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
45     if (a == 0) {
46       return 0;
47     }
48 
49     uint256 c = a * b;
50     require(c / a == b);
51 
52     return c;
53   }
54 
55   /**
56   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
57   */
58   function div(uint256 a, uint256 b) internal pure returns (uint256) {
59     require(b > 0); // Solidity only automatically asserts when dividing by 0
60     uint256 c = a / b;
61     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
62 
63     return c;
64   }
65 
66   /**
67   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
68   */
69   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70     require(b <= a);
71     uint256 c = a - b;
72 
73     return c;
74   }
75 
76   /**
77   * @dev Adds two numbers, reverts on overflow.
78   */
79   function add(uint256 a, uint256 b) internal pure returns (uint256) {
80     uint256 c = a + b;
81     require(c >= a);
82 
83     return c;
84   }
85 
86   /**
87   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
88   * reverts when dividing by zero.
89   */
90   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
91     require(b != 0);
92     return a % b;
93   }
94 }
95 
96 contract ERC20 is IERC20 {
97   using SafeMath for uint256;
98 
99   mapping (address => uint256) internal _balances;
100 
101   mapping (address => mapping (address => uint256)) private _allowed;
102 
103   uint256 private _totalSupply;
104 
105   /**
106   * @dev Total number of tokens in existence
107   */
108   function totalSupply() public view returns (uint256) {
109     return _totalSupply;
110   }
111 
112   /**
113   * @dev Gets the balance of the specified address.
114   * @param owner The address to query the balance of.
115   * @return An uint256 representing the amount owned by the passed address.
116   */
117   function balanceOf(address owner) public view returns (uint256) {
118     return _balances[owner];
119   }
120 
121   /**
122    * @dev Function to check the amount of tokens that an owner allowed to a spender.
123    * @param owner address The address which owns the funds.
124    * @param spender address The address which will spend the funds.
125    * @return A uint256 specifying the amount of tokens still available for the spender.
126    */
127   function allowance(
128     address owner,
129     address spender
130    )
131     public
132     view
133     returns (uint256)
134   {
135     return _allowed[owner][spender];
136   }
137 
138   /**
139   * @dev Transfer token for a specified address
140   * @param to The address to transfer to.
141   * @param value The amount to be transferred.
142   */
143   function transfer(address to, uint256 value) public returns (bool) {
144     _transfer(msg.sender, to, value);
145     return true;
146   }
147 
148   /**
149    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
150    * Beware that changing an allowance with this method brings the risk that someone may use both the old
151    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
152    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
153    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
154    * @param spender The address which will spend the funds.
155    * @param value The amount of tokens to be spent.
156    */
157   function approve(address spender, uint256 value) public returns (bool) {
158     require(spender != address(0));
159 
160     _allowed[msg.sender][spender] = value;
161     emit Approval(msg.sender, spender, value);
162     return true;
163   }
164 
165   /**
166    * @dev Transfer tokens from one address to another
167    * @param from address The address which you want to send tokens from
168    * @param to address The address which you want to transfer to
169    * @param value uint256 the amount of tokens to be transferred
170    */
171   function transferFrom(
172     address from,
173     address to,
174     uint256 value
175   )
176     public
177     returns (bool)
178   {
179     require(value <= _allowed[from][msg.sender]);
180 
181     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
182     _transfer(from, to, value);
183     return true;
184   }
185 
186   /**
187    * @dev Increase the amount of tokens that an owner allowed to a spender.
188    * approve should be called when allowed_[_spender] == 0. To increment
189    * allowed value is better to use this function to avoid 2 calls (and wait until
190    * the first transaction is mined)
191    * From MonolithDAO Token.sol
192    * @param spender The address which will spend the funds.
193    * @param addedValue The amount of tokens to increase the allowance by.
194    */
195   function increaseAllowance(
196     address spender,
197     uint256 addedValue
198   )
199     public
200     returns (bool)
201   {
202     require(spender != address(0));
203 
204     _allowed[msg.sender][spender] = (
205       _allowed[msg.sender][spender].add(addedValue));
206     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
207     return true;
208   }
209 
210   /**
211    * @dev Decrease the amount of tokens that an owner allowed to a spender.
212    * approve should be called when allowed_[_spender] == 0. To decrement
213    * allowed value is better to use this function to avoid 2 calls (and wait until
214    * the first transaction is mined)
215    * From MonolithDAO Token.sol
216    * @param spender The address which will spend the funds.
217    * @param subtractedValue The amount of tokens to decrease the allowance by.
218    */
219   function decreaseAllowance(
220     address spender,
221     uint256 subtractedValue
222   )
223     public
224     returns (bool)
225   {
226     require(spender != address(0));
227 
228     _allowed[msg.sender][spender] = (
229       _allowed[msg.sender][spender].sub(subtractedValue));
230     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
231     return true;
232   }
233 
234   /**
235   * @dev Transfer token for a specified addresses
236   * @param from The address to transfer from.
237   * @param to The address to transfer to.
238   * @param value The amount to be transferred.
239   */
240   function _transfer(address from, address to, uint256 value) internal {
241     require(value <= _balances[from]);
242     require(to != address(0));
243 
244     _balances[from] = _balances[from].sub(value);
245     _balances[to] = _balances[to].add(value);
246     emit Transfer(from, to, value);
247   }
248 
249   /**
250    * @dev Internal function that mints an amount of the token and assigns it to
251    * an account. This encapsulates the modification of balances such that the
252    * proper events are emitted.
253    * @param account The account that will receive the created tokens.
254    * @param value The amount that will be created.
255    */
256   function _mint(address account, uint256 value) internal {
257     require(account != 0);
258     _totalSupply = _totalSupply.add(value);
259     _balances[account] = _balances[account].add(value);
260     emit Transfer(address(0), account, value);
261   }
262 
263   /**
264    * @dev Internal function that burns an amount of the token of a given
265    * account.
266    * @param account The account whose tokens will be burnt.
267    * @param value The amount that will be burnt.
268    */
269   function _burn(address account, uint256 value) internal {
270     require(account != 0);
271     require(value <= _balances[account]);
272 
273     _totalSupply = _totalSupply.sub(value);
274     _balances[account] = _balances[account].sub(value);
275     emit Transfer(account, address(0), value);
276   }
277 
278   /**
279    * @dev Internal function that burns an amount of the token of a given
280    * account, deducting from the sender's allowance for said account. Uses the
281    * internal burn function.
282    * @param account The account whose tokens will be burnt.
283    * @param value The amount that will be burnt.
284    */
285   function _burnFrom(address account, uint256 value) internal {
286     require(value <= _allowed[account][msg.sender]);
287 
288     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
289     // this function needs to emit an event with the updated approval.
290     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
291       value);
292     _burn(account, value);
293   }
294 }
295 
296 contract CFT is ERC20  {
297 
298     string public name = "COSS Fee Token";
299     string public symbol = "CFT";
300     uint8 public decimals = 18;
301     address private owner = msg.sender;
302 
303     event Burn(address burner, uint value);
304 
305     constructor() public {
306         uint startAmount = 240000000 * 1e18;
307         _mint(0x82B638831c2Da53aFA29750C544002d4f8a085be,startAmount);
308     }
309 
310     function burn(uint256 _value) public returns (bool) {
311         _burn(msg.sender, _value);
312         emit Burn(msg.sender, _value);
313         return true;
314     }
315 
316 
317     function sendBatchCS(address[] _recipients, uint[] _values) external returns (bool) {
318         require(_recipients.length == _values.length, "Inconsistent data lengths");
319         uint senderBalance = _balances[msg.sender];
320         for (uint i = 0; i < _values.length; i++) {
321             uint value = _values[i];
322             address to = _recipients[i];
323             require(senderBalance >= value,"Insufficient Balance");
324             if (msg.sender != _recipients[i])  {      
325                 senderBalance = senderBalance - value;
326                 _balances[to] += value;
327             }
328             emit Transfer(msg.sender, to, value);
329         }
330         _balances[msg.sender] = senderBalance;
331         return true;            
332     }
333 
334     function emergencyERC20drain(ERC20 token, uint value) public {
335         require(msg.sender == owner, "Unauthorised");
336         require(token.transfer(owner,value),"Transfer fail");
337     }
338 }