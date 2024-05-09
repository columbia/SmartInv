1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address private _owner;
10 
11   event OwnershipTransferred(
12     address indexed previousOwner,
13     address indexed newOwner
14   );
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   constructor() internal {
21     _owner = msg.sender;
22     emit OwnershipTransferred(address(0), _owner);
23   }
24 
25   /**
26    * @return the address of the owner.
27    */
28   function owner() public view returns (address) {
29     return _owner;
30   }
31 
32   /**
33    * @dev Throws if called by any account other than the owner.
34    */
35   modifier onlyOwner() {
36     require(isOwner());
37     _;
38   }
39 
40   /**
41    * @return true if `msg.sender` is the owner of the contract.
42    */
43   function isOwner() public view returns (bool) {
44     return msg.sender == _owner;
45   }
46 
47   /**
48    * @dev Allows the current owner to relinquish control of the contract.
49    * @notice Renouncing to ownership will leave the contract without an owner.
50    * It will not be possible to call the functions with the `onlyOwner`
51    * modifier anymore.
52    */
53   function renounceOwnership() public onlyOwner {
54     emit OwnershipTransferred(_owner, address(0));
55     _owner = address(0);
56   }
57 
58   /**
59    * @dev Allows the current owner to transfer control of the contract to a newOwner.
60    * @param newOwner The address to transfer ownership to.
61    */
62   function transferOwnership(address newOwner) public onlyOwner {
63     _transferOwnership(newOwner);
64   }
65 
66   /**
67    * @dev Transfers control of the contract to a newOwner.
68    * @param newOwner The address to transfer ownership to.
69    */
70   function _transferOwnership(address newOwner) internal {
71     require(newOwner != address(0));
72     emit OwnershipTransferred(_owner, newOwner);
73     _owner = newOwner;
74   }
75 }
76 
77 /**
78  * @title ERC20 interface
79  * @dev see https://github.com/ethereum/EIPs/issues/20
80  */
81 interface IERC20 {
82   function totalSupply() external view returns (uint256);
83 
84   function balanceOf(address who) external view returns (uint256);
85 
86   function allowance(address owner, address spender) external view returns (uint256);
87 
88   function transfer(address to, uint256 value) external returns (bool);
89 
90   function approve(address spender, uint256 value) external returns (bool);
91 
92   function transferFrom(address from, address to, uint256 value) external returns (bool);
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
107 /**
108  * @title SafeMath
109  * @dev Math operations with safety checks that revert on error
110  */
111 library SafeMath {
112 
113   /**
114   * @dev Multiplies two numbers, reverts on overflow.
115   */
116   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
117     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
118     // benefit is lost if 'b' is also tested.
119     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
120     if (a == 0) {
121       return 0;
122     }
123 
124     uint256 c = a * b;
125     require(c / a == b);
126 
127     return c;
128   }
129 
130   /**
131   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
132   */
133   function div(uint256 a, uint256 b) internal pure returns (uint256) {
134     require(b > 0);
135     // Solidity only automatically asserts when dividing by 0
136     uint256 c = a / b;
137     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
138 
139     return c;
140   }
141 
142   /**
143   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
144   */
145   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
146     require(b <= a);
147     uint256 c = a - b;
148 
149     return c;
150   }
151 
152   /**
153   * @dev Adds two numbers, reverts on overflow.
154   */
155   function add(uint256 a, uint256 b) internal pure returns (uint256) {
156     uint256 c = a + b;
157     require(c >= a);
158 
159     return c;
160   }
161 
162   /**
163   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
164   * reverts when dividing by zero.
165   */
166   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
167     require(b != 0);
168     return a % b;
169   }
170 }
171 
172 /**
173  * @title Standard ERC20 token
174  *
175  * @dev Implementation of the basic standard token.
176  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
177  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
178  */
179 contract ERC20 is IERC20, Ownable {
180   using SafeMath for uint256;
181 
182   mapping(address => uint256) private _balances;
183   mapping(address => bool) private _frozen;
184 
185   mapping(address => mapping(address => uint256)) private _allowed;
186 
187   uint256 private _totalSupply = 100000000000000000000000000;
188 
189   constructor() public {
190     _balances[address(this)] = _totalSupply;
191     emit Transfer(address(0x0), address(this), _totalSupply);
192   }
193 
194   /**
195   * @param _address The address to be frozen/unfrozen.
196   * @param _boolean The flag to set frozen if true and unfrozen if false.
197   */
198   function freeze(address _address, bool _boolean) external onlyOwner {
199     _frozen[_address] = _boolean;
200   }
201 
202   /**
203    * @param owner The address to be checked.
204    * @return A bool representing of the address state frozen if true and unfrozen if false.
205    */
206   function isFrozen(address owner) public view returns (bool) {
207     return _frozen[owner];
208   }
209 
210   /**
211   * @dev Total number of tokens in existence
212   */
213   function totalSupply() public view returns (uint256) {
214     return _totalSupply;
215   }
216 
217   /**
218   * @dev Gets the balance of the specified address.
219   * @param owner The address to query the balance of.
220   * @return An uint256 representing the amount owned by the passed address.
221   */
222   function balanceOf(address owner) public view returns (uint256) {
223     return _balances[owner];
224   }
225 
226   /**
227    * @dev Function to check the amount of tokens that an owner allowed to a spender.
228    * @param owner address The address which owns the funds.
229    * @param spender address The address which will spend the funds.
230    * @return A uint256 specifying the amount of tokens still available for the spender.
231    */
232   function allowance(address owner, address spender) public view returns (uint256){
233     return _allowed[owner][spender];
234   }
235 
236   /**
237   * @dev Transfer token for a specified address
238   * @param to The address to transfer to.
239   * @param value The amount to be transferred.
240   */
241   function transfer(address to, uint256 value) public returns (bool) {
242     require(!isFrozen(msg.sender));
243     _transfer(msg.sender, to, value);
244     return true;
245   }
246 
247   /**
248    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
249    * Beware that changing an allowance with this method brings the risk that someone may use both the old
250    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
251    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
252    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
253    * @param spender The address which will spend the funds.
254    * @param value The amount of tokens to be spent.
255    */
256   function approve(address spender, uint256 value) public returns (bool) {
257     require(spender != address(0));
258 
259     _allowed[msg.sender][spender] = value;
260     emit Approval(msg.sender, spender, value);
261     return true;
262   }
263 
264   /**
265    * @dev Transfer tokens from one address to another
266    * @param from address The address which you want to send tokens from
267    * @param to address The address which you want to transfer to
268    * @param value uint256 the amount of tokens to be transferred
269    */
270   function transferFrom(address from, address to, uint256 value) public returns (bool){
271     require(value <= _allowed[from][msg.sender]);
272     require(!isFrozen(from));
273 
274     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
275     _transfer(from, to, value);
276     return true;
277   }
278 
279   /**
280    * @dev Increase the amount of tokens that an owner allowed to a spender.
281    * approve should be called when allowed_[_spender] == 0. To increment
282    * allowed value is better to use this function to avoid 2 calls (and wait until
283    * the first transaction is mined)
284    * From MonolithDAO Token.sol
285    * @param spender The address which will spend the funds.
286    * @param addedValue The amount of tokens to increase the allowance by.
287    */
288   function increaseAllowance(address spender, uint256 addedValue) public returns (bool){
289     require(spender != address(0));
290 
291     _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
292     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
293     return true;
294   }
295 
296   /**
297    * @dev Decrease the amount of tokens that an owner allowed to a spender.
298    * approve should be called when allowed_[_spender] == 0. To decrement
299    * allowed value is better to use this function to avoid 2 calls (and wait until
300    * the first transaction is mined)
301    * From MonolithDAO Token.sol
302    * @param spender The address which will spend the funds.
303    * @param subtractedValue The amount of tokens to decrease the allowance by.
304    */
305   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool){
306     require(spender != address(0));
307 
308     _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
309     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
310     return true;
311   }
312 
313   /**
314   * @dev Transfer token for a specified addresses
315   * @param from The address to transfer from.
316   * @param to The address to transfer to.
317   * @param value The amount to be transferred.
318   */
319   function _transfer(address from, address to, uint256 value) internal {
320     require(value <= _balances[from]);
321     require(to != address(0));
322 
323     _balances[from] = _balances[from].sub(value);
324     _balances[to] = _balances[to].add(value);
325     emit Transfer(from, to, value);
326   }
327 
328   /**
329   * @param to The address to receive tokens.
330   * @param value The number of tokens to receive.
331   */
332   function transferTokens(address to, uint256 value) external onlyOwner {
333     require(value <= _balances[address(this)]);
334     require(to != address(0));
335 
336     _balances[address(this)] = _balances[address(this)].sub(value);
337     _balances[to] = _balances[to].add(value);
338     emit Transfer(address(this), to, value);
339   }
340 
341   /**
342   * @param to The array of addresses to receive tokens.
343   * @param value The array of numbers of tokens to receive.
344   */
345   function airdrop(address[] to, uint256[] value) external onlyOwner {
346     require(to.length == value.length);
347     for (uint i = 0; i < to.length; i++) {
348       _transfer(address(this), to[i], value[i]);
349     }
350   }
351 }
352 
353 contract UbaiCoin is ERC20 {
354   string constant public name = "UBAI COIN";
355   string constant public symbol = "UBAI";
356   uint256 constant public decimals = 18;
357 }