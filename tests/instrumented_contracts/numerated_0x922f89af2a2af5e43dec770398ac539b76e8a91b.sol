1 pragma solidity ^0.4.23;
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
64   address private _owner;
65 
66 
67   event OwnershipRenounced(address indexed previousOwner);
68   event OwnershipTransferred(
69     address indexed previousOwner,
70     address indexed newOwner
71   );
72 
73 
74   /**
75    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
76    * account.
77    */
78   constructor() public {
79     _owner = msg.sender;
80   }
81 
82   /**
83    * @return the address of the owner.
84    */
85   function owner() public view returns(address) {
86     return _owner;
87   }
88 
89   /**
90    * @dev Throws if called by any account other than the owner.
91    */
92   modifier onlyOwner() {
93     require(isOwner());
94     _;
95   }
96 
97   /**
98    * @return true if `msg.sender` is the owner of the contract.
99    */
100   function isOwner() public view returns(bool) {
101     return msg.sender == _owner;
102   }
103 
104   /**
105    * @dev Allows the current owner to relinquish control of the contract.
106    * @notice Renouncing to ownership will leave the contract without an owner.
107    * It will not be possible to call the functions with the `onlyOwner`
108    * modifier anymore.
109    */
110   function renounceOwnership() public onlyOwner {
111     emit OwnershipRenounced(_owner);
112     _owner = address(0);
113   }
114 
115   /**
116    * @dev Allows the current owner to transfer control of the contract to a newOwner.
117    * @param newOwner The address to transfer ownership to.
118    */
119   function transferOwnership(address newOwner) public onlyOwner {
120     _transferOwnership(newOwner);
121   }
122 
123   /**
124    * @dev Transfers control of the contract to a newOwner.
125    * @param newOwner The address to transfer ownership to.
126    */
127   function _transferOwnership(address newOwner) internal {
128     require(newOwner != address(0));
129     emit OwnershipTransferred(_owner, newOwner);
130     _owner = newOwner;
131   }
132 }
133 
134 interface IERC20 {
135   function totalSupply() external view returns (uint256);
136 
137   function balanceOf(address who) external view returns (uint256);
138 
139   function allowance(address owner, address spender)
140     external view returns (uint256);
141 
142   function transfer(address to, uint256 value) external returns (bool);
143 
144   function approve(address spender, uint256 value)
145     external returns (bool);
146 
147   function transferFrom(address from, address to, uint256 value)
148     external returns (bool);
149 
150   event Transfer(
151     address indexed from,
152     address indexed to,
153     uint256 value
154   );
155 
156   event Approval(
157     address indexed owner,
158     address indexed spender,
159     uint256 value
160   );
161 }
162 
163 contract ERC20 is IERC20 {
164   using SafeMath for uint256;
165 
166   mapping (address => uint256) private _balances;
167 
168   mapping (address => mapping (address => uint256)) private _allowed;
169 
170   uint256 private _totalSupply;
171 
172   /**
173   * @dev Total number of tokens in existence
174   */
175   function totalSupply() public view returns (uint256) {
176     return _totalSupply;
177   }
178 
179   /**
180   * @dev Gets the balance of the specified address.
181   * @param owner The address to query the the balance of.
182   * @return An uint256 representing the amount owned by the passed address.
183   */
184   function balanceOf(address owner) public view returns (uint256) {
185     return _balances[owner];
186   }
187 
188   /**
189    * @dev Function to check the amount of tokens that an owner allowed to a spender.
190    * @param owner address The address which owns the funds.
191    * @param spender address The address which will spend the funds.
192    * @return A uint256 specifying the amount of tokens still available for the spender.
193    */
194   function allowance(
195     address owner,
196     address spender
197    )
198     public
199     view
200     returns (uint256)
201   {
202     return _allowed[owner][spender];
203   }
204 
205   /**
206   * @dev Transfer token for a specified address
207   * @param to The address to transfer to.
208   * @param value The amount to be transferred.
209   */
210   function transfer(address to, uint256 value) public returns (bool) {
211     require(value <= _balances[msg.sender]);
212     require(to != address(0));
213 
214     _balances[msg.sender] = _balances[msg.sender].sub(value);
215     _balances[to] = _balances[to].add(value);
216     emit Transfer(msg.sender, to, value);
217     return true;
218   }
219 
220   /**
221    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
222    * Beware that changing an allowance with this method brings the risk that someone may use both the old
223    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
224    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
225    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
226    * @param spender The address which will spend the funds.
227    * @param value The amount of tokens to be spent.
228    */
229   function approve(address spender, uint256 value) public returns (bool) {
230     require(spender != address(0));
231 
232     _allowed[msg.sender][spender] = value;
233     emit Approval(msg.sender, spender, value);
234     return true;
235   }
236 
237   /**
238    * @dev Transfer tokens from one address to another
239    * @param from address The address which you want to send tokens from
240    * @param to address The address which you want to transfer to
241    * @param value uint256 the amount of tokens to be transferred
242    */
243   function transferFrom(
244     address from,
245     address to,
246     uint256 value
247   )
248     public
249     returns (bool)
250   {
251     require(value <= _balances[from]);
252     require(value <= _allowed[from][msg.sender]);
253     require(to != address(0));
254 
255     _balances[from] = _balances[from].sub(value);
256     _balances[to] = _balances[to].add(value);
257     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
258     emit Transfer(from, to, value);
259     return true;
260   }
261 
262   /**
263    * @dev Increase the amount of tokens that an owner allowed to a spender.
264    * approve should be called when allowed_[_spender] == 0. To increment
265    * allowed value is better to use this function to avoid 2 calls (and wait until
266    * the first transaction is mined)
267    * From MonolithDAO Token.sol
268    * @param spender The address which will spend the funds.
269    * @param addedValue The amount of tokens to increase the allowance by.
270    */
271   function increaseAllowance(
272     address spender,
273     uint256 addedValue
274   )
275     public
276     returns (bool)
277   {
278     require(spender != address(0));
279 
280     _allowed[msg.sender][spender] = (
281       _allowed[msg.sender][spender].add(addedValue));
282     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
283     return true;
284   }
285 
286   /**
287    * @dev Decrease the amount of tokens that an owner allowed to a spender.
288    * approve should be called when allowed_[_spender] == 0. To decrement
289    * allowed value is better to use this function to avoid 2 calls (and wait until
290    * the first transaction is mined)
291    * From MonolithDAO Token.sol
292    * @param spender The address which will spend the funds.
293    * @param subtractedValue The amount of tokens to decrease the allowance by.
294    */
295   function decreaseAllowance(
296     address spender,
297     uint256 subtractedValue
298   )
299     public
300     returns (bool)
301   {
302     require(spender != address(0));
303 
304     _allowed[msg.sender][spender] = (
305       _allowed[msg.sender][spender].sub(subtractedValue));
306     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
307     return true;
308   }
309 
310   /**
311    * @dev Internal function that mints an amount of the token and assigns it to
312    * an account. This encapsulates the modification of balances such that the
313    * proper events are emitted.
314    * @param account The account that will receive the created tokens.
315    * @param amount The amount that will be created.
316    */
317   function _mint(address account, uint256 amount) internal {
318     require(account != 0);
319     _totalSupply = _totalSupply.add(amount);
320     _balances[account] = _balances[account].add(amount);
321     emit Transfer(address(0), account, amount);
322   }
323 
324   /**
325    * @dev Internal function that burns an amount of the token of a given
326    * account.
327    * @param account The account whose tokens will be burnt.
328    * @param amount The amount that will be burnt.
329    */
330   function _burn(address account, uint256 amount) internal {
331     require(account != 0);
332     require(amount <= _balances[account]);
333 
334     _totalSupply = _totalSupply.sub(amount);
335     _balances[account] = _balances[account].sub(amount);
336     emit Transfer(account, address(0), amount);
337   }
338 
339   /**
340    * @dev Internal function that burns an amount of the token of a given
341    * account, deducting from the sender's allowance for said account. Uses the
342    * internal burn function.
343    * @param account The account whose tokens will be burnt.
344    * @param amount The amount that will be burnt.
345    */
346   function _burnFrom(address account, uint256 amount) internal {
347     require(amount <= _allowed[account][msg.sender]);
348 
349     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
350     // this function needs to emit an event with the updated approval.
351     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
352       amount);
353     _burn(account, amount);
354   }
355 }
356 
357 contract ElecAirdrop is Ownable {
358 
359     function multisend(
360         address _tokenAddr, 
361         address[] dests, 
362         uint256[] values
363     ) 
364     onlyOwner
365     public 
366     returns (uint256) {
367         
368         uint256 i = 0;
369         while (i < dests.length) {
370            ERC20(_tokenAddr).transferFrom(msg.sender, dests[i], values[i]);
371            i += 1;
372         }
373         return(i);
374         
375     }
376 }