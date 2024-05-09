1 pragma solidity 0.4.25;
2 
3 /**
4  * @dev Welcome to Criptomiles token.  This is a utility token to be used in 
5  * Driveon's platform.  Come with us and help to create a more decentalized
6  * world.  Earn as you drive.  Know better this project accessing:
7  * www.CryptoMiles.me and participate on our ICO.  The first token for mobility
8  * in America Latina.
9  * This contract was developed using the best practices recomended in OpenZeppelin
10  * Main developer: Rodrigo Bezerra
11  */
12 
13 
14 /**
15  * @title SafeMath
16  * @dev Math operations with safety checks that throw on error
17  */
18 library SafeMath {
19 
20   /**
21   * @dev Multiplies two numbers, throws on overflow.
22   */
23   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
24     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
25     // benefit is lost if 'b' is also tested.
26     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
27     if (_a == 0) {
28       return 0;
29     }
30 
31     c = _a * _b;
32     assert(c / _a == _b);
33     return c;
34   }
35 
36   /**
37   * @dev Integer division of two numbers, truncating the quotient.
38   */
39   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
40     // assert(_b > 0); // Solidity automatically throws when dividing by 0
41     // uint256 c = _a / _b;
42     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
43     return _a / _b;
44   }
45 
46   /**
47   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
48   */
49   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
50     assert(_b <= _a);
51     return _a - _b;
52   }
53 
54   /**
55   * @dev Adds two numbers, throws on overflow.
56   */
57   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
58     c = _a + _b;
59     assert(c >= _a);
60     return c;
61   }
62 }
63 
64 /**
65  * @title Ownable
66  * @dev The Ownable contract has an owner address, and provides basic authorization control
67  * functions, this simplifies the implementation of "user permissions".
68  */
69 contract Ownable {
70   address public owner;
71 
72 
73   event OwnershipRenounced(address indexed previousOwner);
74   event OwnershipTransferred(
75     address indexed previousOwner,
76     address indexed newOwner
77   );
78 
79 
80   /**
81    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
82    * account.
83    */
84   constructor() public {
85     owner = msg.sender;
86   }
87 
88   /**
89    * @dev Throws if called by any account other than the owner.
90    */
91   modifier onlyOwner() {
92     require(msg.sender == owner);
93     _;
94   }
95 
96   /**
97    * @dev Allows the current owner to relinquish control of the contract.
98    * @notice Renouncing to ownership will leave the contract without an owner.
99    * It will not be possible to call the functions with the `onlyOwner`
100    * modifier anymore.
101    */
102   function renounceOwnership() public onlyOwner {
103     emit OwnershipRenounced(owner);
104     owner = address(0);
105   }
106 
107   /**
108    * @dev Allows the current owner to transfer control of the contract to a newOwner.
109    * @param _newOwner The address to transfer ownership to.
110    */
111   function transferOwnership(address _newOwner) public onlyOwner {
112     _transferOwnership(_newOwner);
113   }
114 
115   /**
116    * @dev Transfers control of the contract to a newOwner.
117    * @param _newOwner The address to transfer ownership to.
118    */
119   function _transferOwnership(address _newOwner) internal {
120     require(_newOwner != address(0));
121     emit OwnershipTransferred(owner, _newOwner);
122     owner = _newOwner;
123   }
124 }
125 
126 /**
127  * @title ERC20 interface
128  * @dev see https://github.com/ethereum/EIPs/issues/20
129  */
130 interface IERC20 {
131   function totalSupply() external view returns (uint256);
132 
133   function balanceOf(address who) external view returns (uint256);
134 
135   function allowance(address owner, address spender)
136     external view returns (uint256);
137 
138   function transfer(address to, uint256 value) external returns (bool);
139 
140   function approve(address spender, uint256 value)
141     external returns (bool);
142 
143   function transferFrom(address from, address to, uint256 value)
144     external returns (bool);
145 
146   event Transfer(
147     address indexed from,
148     address indexed to,
149     uint256 value
150   );
151 
152   event Approval(
153     address indexed owner,
154     address indexed spender,
155     uint256 value
156   );
157 }
158 
159 contract CryptoMilesToken is IERC20, Ownable {
160 
161     string private _name;
162     string private _symbol;
163     uint8 private _decimals;
164     
165     using SafeMath for uint256;
166     
167     mapping (address => uint256) private _balances;
168     
169     mapping (address => mapping (address => uint256)) private _allowed;
170     
171     uint256 private _totalSupply;
172 
173 	uint256 constant private INITITAL_SUPPLY = 650000000 * (10 ** uint256(_decimals));
174 
175     constructor(string name, string symbol, uint8 decimals) public
176     {
177         _name = name;
178         _symbol = symbol;
179         _decimals = decimals;
180 		_totalSupply = INITITAL_SUPPLY;
181 		_balances[msg.sender] = _totalSupply;
182 		emit Transfer(address(0x0), msg.sender, _totalSupply);
183     }
184     
185     /**
186     * @return the name of the token.
187     */
188     function name() public view returns(string) {
189         return _name;
190     }
191 
192     /**
193     * @return the symbol of the token.
194     */
195     function symbol() public view returns(string) {
196         return _symbol;
197     }
198 
199     /**
200     * @return the number of decimals of the token.
201     */
202     function decimals() public view returns(uint8) {
203         return _decimals;
204     }
205     
206     /**
207     * @dev Total number of tokens in existence
208     */
209     function totalSupply() public view returns (uint256) {
210         return _totalSupply;
211     }
212 
213     /**
214     * @dev Gets the balance of the specified address.
215     * @param owner The address to query the balance of.
216     * @return An uint256 representing the amount owned by the passed address.
217     */
218     function balanceOf(address owner) public view returns (uint256) {
219         return _balances[owner];
220     }
221 
222     /**
223        * @dev Function to check the amount of tokens that an owner allowed to a spender.
224        * @param owner address The address which owns the funds.
225        * @param spender address The address which will spend the funds.
226        * @return A uint256 specifying the amount of tokens still available for the spender.
227        */
228     function allowance( address owner, address spender ) public view returns (uint256) {
229         return _allowed[owner][spender];
230   }
231     
232     /**
233       * @dev Transfer token for a specified address
234       * @param to The address to transfer to.
235       * @param value The amount to be transferred.
236       */
237     function transfer(address to, uint256 value) public returns (bool) {
238         _transfer(msg.sender, to, value);
239         return true;
240   }
241 
242   /**
243    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
244    * Beware that changing an allowance with this method brings the risk that someone may use both the old
245    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
246    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
247    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
248    * @param spender The address which will spend the funds.
249    * @param value The amount of tokens to be spent.
250    */
251   function approve(address spender, uint256 value) public returns (bool) {
252     require(spender != address(0));
253 
254     _allowed[msg.sender][spender] = value;
255     emit Approval(msg.sender, spender, value);
256     return true;
257   }
258 
259   /**
260    * @dev Transfer tokens from one address to another
261    * @param from address The address which you want to send tokens from
262    * @param to address The address which you want to transfer to
263    * @param value uint256 the amount of tokens to be transferred
264    */
265   function transferFrom(address from, address to, uint256 value) public returns (bool) {
266     require(value <= _allowed[from][msg.sender]);
267 
268     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
269     _transfer(from, to, value);
270     return true;
271   }
272 
273   /**
274    * @dev Increase the amount of tokens that an owner allowed to a spender.
275    * approve should be called when allowed_[_spender] == 0. To increment
276    * allowed value is better to use this function to avoid 2 calls (and wait until
277    * the first transaction is mined)
278    * From MonolithDAO Token.sol
279    * @param spender The address which will spend the funds.
280    * @param addedValue The amount of tokens to increase the allowance by.
281    */
282   function increaseAllowance(address spender, uint256 addedValue) public returns (bool)
283   {
284     require(spender != address(0));
285 
286     _allowed[msg.sender][spender] = (
287       _allowed[msg.sender][spender].add(addedValue));
288     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
289     return true;
290   }
291 
292   /**
293    * @dev Decrease the amount of tokens that an owner allowed to a spender.
294    * approve should be called when allowed_[_spender] == 0. To decrement
295    * allowed value is better to use this function to avoid 2 calls (and wait until
296    * the first transaction is mined)
297    * From MonolithDAO Token.sol
298    * @param spender The address which will spend the funds.
299    * @param subtractedValue The amount of tokens to decrease the allowance by.
300    */
301   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool)
302   {
303     require(spender != address(0));
304 
305     _allowed[msg.sender][spender] = (
306       _allowed[msg.sender][spender].sub(subtractedValue));
307     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
308     return true;
309   }
310 
311   /**
312   * @dev Transfer token for a specified addresses
313   * @param from The address to transfer from.
314   * @param to The address to transfer to.
315   * @param value The amount to be transferred.
316   */
317   function _transfer(address from, address to, uint256 value) internal {
318     require(value <= _balances[from]);
319     require(to != address(0));
320 
321     _balances[from] = _balances[from].sub(value);
322     _balances[to] = _balances[to].add(value);
323     emit Transfer(from, to, value);
324   }
325 
326   /**
327    * @dev Internal function that mints an amount of the token and assigns it to
328    * an account. This encapsulates the modification of balances such that the
329    * proper events are emitted.
330    * @param account The account that will receive the created tokens.
331    * @param value The amount that will be created.
332    */
333   function _mint(address account, uint256 value) internal {
334     require(account != 0);
335     _totalSupply = _totalSupply.add(value);
336     _balances[account] = _balances[account].add(value);
337     emit Transfer(address(0), account, value);
338   }
339 
340   /**
341    * @dev Internal function that burns an amount of the token of a given
342    * account.
343    * @param account The account whose tokens will be burnt.
344    * @param value The amount that will be burnt.
345    */
346   function _burn(address account, uint256 value) internal {
347     require(account != 0);
348     require(value <= _balances[account]);
349 
350     _totalSupply = _totalSupply.sub(value);
351     _balances[account] = _balances[account].sub(value);
352     emit Transfer(account, address(0), value);
353   }
354 
355   /**
356    * @dev Internal function that burns an amount of the token of a given
357    * account, deducting from the sender's allowance for said account. Uses the
358    * internal burn function.
359    * @param account The account whose tokens will be burnt.
360    * @param value The amount that will be burnt.
361    */
362   function _burnFrom(address account, uint256 value) internal {
363     require(value <= _allowed[account][msg.sender]);
364 
365     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
366     // this function needs to emit an event with the updated approval.
367     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
368       value);
369     _burn(account, value);
370   }
371     
372 }