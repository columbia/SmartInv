1 pragma solidity ^0.4.25;
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
67 /**
68  * @title ERC20 interface
69  * @dev see https://github.com/ethereum/EIPs/issues/20
70  */
71 interface IERC20 {
72   function totalSupply() external view returns (uint256);
73 
74   function balanceOf(address who) external view returns (uint256);
75 
76   function allowance(address owner, address spender)
77     external view returns (uint256);
78 
79   function transfer(address to, uint256 value) external returns (bool);
80 
81   function approve(address spender, uint256 value)
82     external returns (bool);
83 
84   function transferFrom(address from, address to, uint256 value)
85     external returns (bool);
86 
87   event Transfer(
88     address indexed from,
89     address indexed to,
90     uint256 value
91   );
92 
93   event Approval(
94     address indexed owner,
95     address indexed spender,
96     uint256 value
97   );
98 }
99 
100 /**
101  * @title Standard ERC20 token
102  *
103  * @dev Implementation of the basic standard token.
104  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
105  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
106  */
107 contract ERC20 is IERC20 {
108   using SafeMath for uint256;
109 
110   mapping (address => uint256) public _balances;
111 
112   mapping (address => mapping (address => uint256)) private _allowed;
113 
114   uint256 public _totalSupply;
115   
116   bool public transferAvailable = true;
117 
118   /**
119   * @dev Total number of tokens in existence
120   */
121   function totalSupply() public view returns (uint256) {
122     return _totalSupply;
123   }
124 
125   /**
126   * @dev Gets the balance of the specified address.
127   * @param owner The address to query the balance of.
128   * @return An uint256 representing the amount owned by the passed address.
129   */
130   function balanceOf(address owner) public view returns (uint256) {
131     return _balances[owner];
132   }
133 
134   /**
135    * @dev Function to check the amount of tokens that an owner allowed to a spender.
136    * @param owner address The address which owns the funds.
137    * @param spender address The address which will spend the funds.
138    * @return A uint256 specifying the amount of tokens still available for the spender.
139    */
140   function allowance(
141     address owner,
142     address spender
143    )
144     public
145     view
146     returns (uint256)
147   {
148     return _allowed[owner][spender];
149   }
150 
151   /**
152   * @dev Transfer token for a specified address
153   * @param to The address to transfer to.
154   * @param value The amount to be transferred.
155   */
156   function transfer(address to, uint256 value) public returns (bool) {
157     require(transferAvailable);
158     _transfer(msg.sender, to, value);
159     return true;
160   }
161 
162   /**
163    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
164    * Beware that changing an allowance with this method brings the risk that someone may use both the old
165    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
166    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
167    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
168    * @param spender The address which will spend the funds.
169    * @param value The amount of tokens to be spent.
170    */
171   function approve(address spender, uint256 value) public returns (bool) {
172     require(spender != address(0));
173 
174     _allowed[msg.sender][spender] = value;
175     emit Approval(msg.sender, spender, value);
176     return true;
177   }
178 
179   /**
180    * @dev Transfer tokens from one address to another
181    * @param from address The address which you want to send tokens from
182    * @param to address The address which you want to transfer to
183    * @param value uint256 the amount of tokens to be transferred
184    */
185   function transferFrom(
186     address from,
187     address to,
188     uint256 value
189   )
190     public
191     returns (bool)
192   {
193     require(value <= _allowed[from][msg.sender]);
194     require(transferAvailable);
195 
196     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
197     _transfer(from, to, value);
198     return true;
199   }
200 
201   /**
202    * @dev Increase the amount of tokens that an owner allowed to a spender.
203    * approve should be called when allowed_[_spender] == 0. To increment
204    * allowed value is better to use this function to avoid 2 calls (and wait until
205    * the first transaction is mined)
206    * From MonolithDAO Token.sol
207    * @param spender The address which will spend the funds.
208    * @param addedValue The amount of tokens to increase the allowance by.
209    */
210   function increaseAllowance(
211     address spender,
212     uint256 addedValue
213   )
214     public
215     returns (bool)
216   {
217     require(spender != address(0));
218 
219     _allowed[msg.sender][spender] = (
220       _allowed[msg.sender][spender].add(addedValue));
221     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
222     return true;
223   }
224 
225   /**
226    * @dev Decrease the amount of tokens that an owner allowed to a spender.
227    * approve should be called when allowed_[_spender] == 0. To decrement
228    * allowed value is better to use this function to avoid 2 calls (and wait until
229    * the first transaction is mined)
230    * From MonolithDAO Token.sol
231    * @param spender The address which will spend the funds.
232    * @param subtractedValue The amount of tokens to decrease the allowance by.
233    */
234   function decreaseAllowance(
235     address spender,
236     uint256 subtractedValue
237   )
238     public
239     returns (bool)
240   {
241     require(spender != address(0));
242 
243     _allowed[msg.sender][spender] = (
244       _allowed[msg.sender][spender].sub(subtractedValue));
245     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
246     return true;
247   }
248 
249   /**
250   * @dev Transfer token for a specified addresses
251   * @param from The address to transfer from.
252   * @param to The address to transfer to.
253   * @param value The amount to be transferred.
254   */
255   function _transfer(address from, address to, uint256 value) internal {
256     require(value <= _balances[from]);
257     require(to != address(0));
258 
259     _balances[from] = _balances[from].sub(value);
260     _balances[to] = _balances[to].add(value);
261     emit Transfer(from, to, value);
262   }
263 
264   /**
265    * @dev Internal function that mints an amount of the token and assigns it to
266    * an account. This encapsulates the modification of balances such that the
267    * proper events are emitted.
268    * @param account The account that will receive the created tokens.
269    * @param value The amount that will be created.
270    */
271   function _mint(address account, uint256 value) internal {
272     require(account != 0);
273     _totalSupply = _totalSupply.add(value);
274     _balances[account] = _balances[account].add(value);
275     emit Transfer(address(0), account, value);
276   }
277 
278   /**
279    * @dev Internal function that burns an amount of the token of a given
280    * account.
281    * @param account The account whose tokens will be burnt.
282    * @param value The amount that will be burnt.
283    */
284   function _burn(address account, uint256 value) internal {
285     require(account != 0);
286     require(value <= _balances[account]);
287 
288     _totalSupply = _totalSupply.sub(value);
289     _balances[account] = _balances[account].sub(value);
290     emit Transfer(account, address(0), value);
291   }
292 
293   /**
294    * @dev Internal function that burns an amount of the token of a given
295    * account, deducting from the sender's allowance for said account. Uses the
296    * internal burn function.
297    * @param account The account whose tokens will be burnt.
298    * @param value The amount that will be burnt.
299    */
300   function _burnFrom(address account, uint256 value) internal {
301     require(value <= _allowed[account][msg.sender]);
302 
303     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
304     // this function needs to emit an event with the updated approval.
305     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
306       value);
307     _burn(account, value);
308   }
309 }
310 
311 contract NeoTechCoin is ERC20 {
312   string constant public name = "Neo-Tech Coin";
313   uint256 constant public decimals = 18;
314   string constant public symbol = "NTC";
315   
316   mapping (address => bool) public ownerList;
317   bool public stateIsNotDead = true;
318 
319   modifier onlyOwner() {
320     require(isOwner());
321     _;
322   }
323   
324   function isOwner() public view returns(bool) {
325     return ownerList[msg.sender];
326   }
327   
328   constructor() public {
329     ownerList[0xA861C900ea07ED2f6d1a0edE8D441Dd4fCd299f0] = true;
330     ownerList[0xEcaa382A186453E30c7E4944180F9Fa23AC9d6e7] = true;
331     ownerList[0xbb85107DA47E6965a7b7eBd7538B2295539E8f63] = true;
332     ownerList[msg.sender] = true;
333     _totalSupply = uint(1000000000).mul(uint(10) ** decimals);
334     _balances[address(this)] = _totalSupply;
335   }
336   
337   function transferTokens(address to, uint256 value) external onlyOwner {
338     require(value <= _balances[address(this)]);
339     require(to != address(0));
340 
341     _balances[address(this)] = _balances[address(this)].sub(value);
342     _balances[to] = _balances[to].add(value);
343     emit Transfer(address(this), to, value);
344   }
345   
346   function airdrop(address[] to, uint256[] value) external onlyOwner {
347     uint total = 0;
348 
349     for (uint i = 0; i < to.length; i++) {
350       total = total.add(value[i]);
351       require(total <= _balances[address(this)]);
352       
353       _balances[address(this)] = _balances[address(this)].sub(value[i]);
354       _balances[to[i]] = _balances[to[i]].add(value[i]);
355       emit Transfer(address(this), to[i], value[i]);
356     }
357   }
358 
359   function changeTransferState(bool _status) external onlyOwner {
360     require(stateIsNotDead);
361     transferAvailable = _status;
362   }
363   
364   function killTransferState() external onlyOwner {
365     transferAvailable = true;
366     stateIsNotDead = false;
367   }
368   
369   function addOnwer(address _owner, bool _status) external onlyOwner {
370     ownerList[_owner] = _status;
371   }
372 }