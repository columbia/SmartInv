1 /* ***************************************************************************
2  *
3  * Contract: Quant Compute Credit
4  * Ticker: XQC
5  * 
6  * Type: ERC-20
7  * Website: https://www.quantom.cloud/token
8  * 
9  * This token is a form of payment on Quantom Cloud. Users accrue charges for
10  * using CPU time, disk space, and other features of the cloud. At the end of
11  * the month they can choose to pay the bill with QCC tokens at 20% discount
12  * rate, or at full price by paying with their credit card.
13  */
14 pragma solidity 0.4.25;
15 
16 
17 library SafeMath {
18 
19   /**
20   * @dev Multiplies two numbers, reverts on overflow.
21   */
22   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
24     // benefit is lost if 'b' is also tested.
25     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
26     if (a == 0) {
27       return 0;
28     }
29 
30     uint256 c = a * b;
31     require(c / a == b);
32 
33     return c;
34   }
35 
36   /**
37   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
38   */
39   function div(uint256 a, uint256 b) internal pure returns (uint256) {
40     require(b > 0); // Solidity only automatically asserts when dividing by 0
41     uint256 c = a / b;
42     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
43 
44     return c;
45   }
46 
47   /**
48   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
49   */
50   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51     require(b <= a);
52     uint256 c = a - b;
53 
54     return c;
55   }
56 
57   /**
58   * @dev Adds two numbers, reverts on overflow.
59   */
60   function add(uint256 a, uint256 b) internal pure returns (uint256) {
61     uint256 c = a + b;
62     require(c >= a);
63 
64     return c;
65   }
66 
67   /**
68   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
69   * reverts when dividing by zero.
70   */
71   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
72     require(b != 0);
73     return a % b;
74   }
75 }
76 
77 
78 interface IERC20 {
79   function totalSupply() external view returns (uint256);
80 
81   function balanceOf(address who) external view returns (uint256);
82 
83   function allowance(address owner, address spender)
84     external view returns (uint256);
85 
86   function transfer(address to, uint256 value) external returns (bool);
87 
88   function approve(address spender, uint256 value)
89     external returns (bool);
90 
91   function transferFrom(address from, address to, uint256 value)
92     external returns (bool);
93 
94   event Transfer(
95     address indexed from,
96     address indexed to,
97     uint256 value
98   );
99 
100   event Approval(
101     address indexed owner,
102     address indexed spender,
103     uint256 value
104   );
105 }
106 
107 
108 contract ERC20Detailed is IERC20 {
109   string private _name;
110   string private _symbol;
111   uint8 private _decimals;
112 
113   constructor(string name, string symbol, uint8 decimals) public {
114     _name = name;
115     _symbol = symbol;
116     _decimals = decimals;
117   }
118 
119   /**
120    * @return the name of the token.
121    */
122   function name() public view returns(string) {
123     return _name;
124   }
125 
126   /**
127    * @return the symbol of the token.
128    */
129   function symbol() public view returns(string) {
130     return _symbol;
131   }
132 
133   /**
134    * @return the number of decimals of the token.
135    */
136   function decimals() public view returns(uint8) {
137     return _decimals;
138   }
139 }
140 
141 
142 contract Ownable {
143   address private _owner;
144 
145   event OwnershipTransferred(
146     address indexed previousOwner,
147     address indexed newOwner
148   );
149 
150   /**
151    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
152    * account.
153    */
154   constructor() internal {
155     _owner = msg.sender;
156     emit OwnershipTransferred(address(0), _owner);
157   }
158 
159   /**
160    * @return the address of the owner.
161    */
162   function owner() public view returns(address) {
163     return _owner;
164   }
165 
166   /**
167    * @dev Throws if called by any account other than the owner.
168    */
169   modifier onlyOwner() {
170     require(isOwner());
171     _;
172   }
173 
174   /**
175    * @return true if `msg.sender` is the owner of the contract.
176    */
177   function isOwner() public view returns(bool) {
178     return msg.sender == _owner;
179   }
180 
181   /**
182    * @dev Allows the current owner to relinquish control of the contract.
183    * @notice Renouncing to ownership will leave the contract without an owner.
184    * It will not be possible to call the functions with the `onlyOwner`
185    * modifier anymore.
186    */
187   function renounceOwnership() public onlyOwner {
188     emit OwnershipTransferred(_owner, address(0));
189     _owner = address(0);
190   }
191 
192   /**
193    * @dev Allows the current owner to transfer control of the contract to a newOwner.
194    * @param newOwner The address to transfer ownership to.
195    */
196   function transferOwnership(address newOwner) public onlyOwner {
197     _transferOwnership(newOwner);
198   }
199 
200   /**
201    * @dev Transfers control of the contract to a newOwner.
202    * @param newOwner The address to transfer ownership to.
203    */
204   function _transferOwnership(address newOwner) internal {
205     require(newOwner != address(0));
206     emit OwnershipTransferred(_owner, newOwner);
207     _owner = newOwner;
208   }
209 }
210 
211 
212 /**
213  * @title Standard ERC20 token
214  *
215  * @dev Implementation of the basic standard token.
216  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
217  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
218  */
219 contract ERC20 is IERC20 {
220   using SafeMath for uint256;
221 
222   mapping (address => uint256) private _balances;
223 
224   mapping (address => mapping (address => uint256)) private _allowed;
225 
226   uint256 private _totalSupply;
227 
228   /**
229   * @dev Total number of tokens in existence
230   */
231   function totalSupply() public view returns (uint256) {
232     return _totalSupply;
233   }
234 
235   /**
236   * @dev Gets the balance of the specified address.
237   * @param owner The address to query the balance of.
238   * @return An uint256 representing the amount owned by the passed address.
239   */
240   function balanceOf(address owner) public view returns (uint256) {
241     return _balances[owner];
242   }
243 
244   /**
245    * @dev Function to check the amount of tokens that an owner allowed to a spender.
246    * @param owner address The address which owns the funds.
247    * @param spender address The address which will spend the funds.
248    * @return A uint256 specifying the amount of tokens still available for the spender.
249    */
250   function allowance(
251     address owner,
252     address spender
253    )
254     public
255     view
256     returns (uint256)
257   {
258     return _allowed[owner][spender];
259   }
260 
261   /**
262   * @dev Transfer token for a specified address
263   * @param to The address to transfer to.
264   * @param value The amount to be transferred.
265   */
266   function transfer(address to, uint256 value) public returns (bool) {
267     _transfer(msg.sender, to, value);
268     return true;
269   }
270 
271   /**
272    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
273    * Beware that changing an allowance with this method brings the risk that someone may use both the old
274    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
275    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
276    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
277    * @param spender The address which will spend the funds.
278    * @param value The amount of tokens to be spent.
279    */
280   function approve(address spender, uint256 value) public returns (bool) {
281     require(spender != address(0));
282 
283     _allowed[msg.sender][spender] = value;
284     emit Approval(msg.sender, spender, value);
285     return true;
286   }
287 
288   /**
289    * @dev Transfer tokens from one address to another
290    * @param from address The address which you want to send tokens from
291    * @param to address The address which you want to transfer to
292    * @param value uint256 the amount of tokens to be transferred
293    */
294   function transferFrom(
295     address from,
296     address to,
297     uint256 value
298   )
299     public
300     returns (bool)
301   {
302     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
303     _transfer(from, to, value);
304     return true;
305   }
306 
307   /**
308    * @dev Increase the amount of tokens that an owner allowed to a spender.
309    * approve should be called when allowed_[_spender] == 0. To increment
310    * allowed value is better to use this function to avoid 2 calls (and wait until
311    * the first transaction is mined)
312    * From MonolithDAO Token.sol
313    * @param spender The address which will spend the funds.
314    * @param addedValue The amount of tokens to increase the allowance by.
315    */
316   function increaseAllowance(
317     address spender,
318     uint256 addedValue
319   )
320     public
321     returns (bool)
322   {
323     require(spender != address(0));
324 
325     _allowed[msg.sender][spender] = (
326       _allowed[msg.sender][spender].add(addedValue));
327     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
328     return true;
329   }
330 
331   /**
332    * @dev Decrease the amount of tokens that an owner allowed to a spender.
333    * approve should be called when allowed_[_spender] == 0. To decrement
334    * allowed value is better to use this function to avoid 2 calls (and wait until
335    * the first transaction is mined)
336    * From MonolithDAO Token.sol
337    * @param spender The address which will spend the funds.
338    * @param subtractedValue The amount of tokens to decrease the allowance by.
339    */
340   function decreaseAllowance(
341     address spender,
342     uint256 subtractedValue
343   )
344     public
345     returns (bool)
346   {
347     require(spender != address(0));
348 
349     _allowed[msg.sender][spender] = (
350       _allowed[msg.sender][spender].sub(subtractedValue));
351     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
352     return true;
353   }
354 
355   /**
356   * @dev Transfer token for a specified addresses
357   * @param from The address to transfer from.
358   * @param to The address to transfer to.
359   * @param value The amount to be transferred.
360   */
361   function _transfer(address from, address to, uint256 value) internal {
362     require(to != address(0));
363 
364     _balances[from] = _balances[from].sub(value);
365     _balances[to] = _balances[to].add(value);
366     emit Transfer(from, to, value);
367   }
368 
369   /**
370    * @dev Internal function that mints an amount of the token and assigns it to
371    * an account. This encapsulates the modification of balances such that the
372    * proper events are emitted.
373    * @param account The account that will receive the created tokens.
374    * @param value The amount that will be created.
375    */
376   function _mint(address account, uint256 value) internal {
377     require(account != address(0));
378 
379     _totalSupply = _totalSupply.add(value);
380     _balances[account] = _balances[account].add(value);
381     emit Transfer(address(0), account, value);
382   }
383 
384   /**
385    * @dev Internal function that burns an amount of the token of a given
386    * account.
387    * @param account The account whose tokens will be burnt.
388    * @param value The amount that will be burnt.
389    */
390   function _burn(address account, uint256 value) internal {
391     require(account != address(0));
392 
393     _totalSupply = _totalSupply.sub(value);
394     _balances[account] = _balances[account].sub(value);
395     emit Transfer(account, address(0), value);
396   }
397 
398   /**
399    * @dev Internal function that burns an amount of the token of a given
400    * account, deducting from the sender's allowance for said account. Uses the
401    * internal burn function.
402    * @param account The account whose tokens will be burnt.
403    * @param value The amount that will be burnt.
404    */
405   function _burnFrom(address account, uint256 value) internal {
406     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
407     // this function needs to emit an event with the updated approval.
408     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
409       value);
410     _burn(account, value);
411   }
412 }
413 
414 
415 
416 contract QuantomComputeCredit is ERC20, ERC20Detailed, Ownable {
417     using SafeMath for uint256;
418 
419     uint256 public constant INITIAL_SUPPLY = 1e9 * (10 ** uint256(18));
420 
421       /**
422        * @dev Constructor that gives msg.sender all of existing tokens.
423        */
424       constructor() public ERC20Detailed("Quantom Compute Credit", "XQC", 18) {
425         _mint(msg.sender, INITIAL_SUPPLY);
426     }
427 }