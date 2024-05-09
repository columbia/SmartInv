1 pragma solidity ^0.4.24;
2 
3 contract Ownable {
4   address private _owner;
5 
6 
7   event OwnershipRenounced(address indexed previousOwner);
8   event OwnershipTransferred(
9     address indexed previousOwner,
10     address indexed newOwner
11   );
12 
13 
14   /**
15    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16    * account.
17    */
18   constructor() public {
19     _owner = msg.sender;
20   }
21 
22   /**
23    * @return the address of the owner.
24    */
25   function owner() public view returns(address) {
26     return _owner;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(isOwner());
34     _;
35   }
36 
37   /**
38    * @return true if `msg.sender` is the owner of the contract.
39    */
40   function isOwner() public view returns(bool) {
41     return msg.sender == _owner;
42   }
43 
44   /**
45    * @dev Allows the current owner to relinquish control of the contract.
46    * @notice Renouncing to ownership will leave the contract without an owner.
47    * It will not be possible to call the functions with the `onlyOwner`
48    * modifier anymore.
49    */
50   function renounceOwnership() public onlyOwner {
51     emit OwnershipRenounced(_owner);
52     _owner = address(0);
53   }
54 
55   /**
56    * @dev Allows the current owner to transfer control of the contract to a newOwner.
57    * @param newOwner The address to transfer ownership to.
58    */
59   function transferOwnership(address newOwner) public onlyOwner {
60     _transferOwnership(newOwner);
61   }
62 
63   /**
64    * @dev Transfers control of the contract to a newOwner.
65    * @param newOwner The address to transfer ownership to.
66    */
67   function _transferOwnership(address newOwner) internal {
68     require(newOwner != address(0));
69     emit OwnershipTransferred(_owner, newOwner);
70     _owner = newOwner;
71   }
72 }
73 
74 
75 /**
76  * @title ERC20 interface
77  */
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
107 /**
108  * @title SafeMath
109  * @dev Math operations with safety checks that revert on error
110  */
111 library SafeMath {
112 
113   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
114     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
115     // benefit is lost if 'b' is also tested.
116     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
117     if (a == 0) {
118       return 0;
119     }
120 
121     uint256 c = a * b;
122     require(c / a == b);
123 
124     return c;
125   }
126 
127   function div(uint256 a, uint256 b) internal pure returns (uint256) {
128     require(b > 0); // Solidity only automatically asserts when dividing by 0
129     uint256 c = a / b;
130     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
131 
132     return c;
133   }
134 
135   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
136     require(b <= a);
137     uint256 c = a - b;
138 
139     return c;
140   }
141 
142   function add(uint256 a, uint256 b) internal pure returns (uint256) {
143     uint256 c = a + b;
144     require(c >= a);
145 
146     return c;
147   }
148 
149   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
150     require(b != 0);
151     return a % b;
152   }
153 }
154 
155 /**
156  * @title Standard ERC20 token
157  *
158  * @dev Implementation of the basic standard token.
159  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
160  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
161  */
162 contract Sportie is IERC20, Ownable {
163   using SafeMath for uint256;
164 
165   mapping (address => uint256) public _balances;
166 
167   mapping (address => mapping (address => uint256)) private _allowed;
168   
169   uint8 public decimals;
170   uint256 private _totalSupply;
171   string public name;
172   string public symbol;
173 
174   constructor () public{
175         decimals = 18;
176         _totalSupply = 2000000000000000000000000000;
177         _balances[msg.sender] = _totalSupply;
178         name = "Sportie";
179         symbol = "SPTI";
180         emit Transfer(address(0), msg.sender, _totalSupply);
181 
182     }
183 
184   /**
185   * @dev Total number of tokens in existence
186   */
187   function totalSupply() public view returns (uint256) {
188     return _totalSupply;
189   }
190 
191   /**
192   * @dev Gets the balance of the specified address.
193   * @param owner The address to query the the balance of.
194   * @return An uint256 representing the amount owned by the passed address.
195   */
196   function balanceOf(address owner) public view returns (uint256) {
197     return _balances[owner];
198   }
199 
200   /**
201    * @dev Function to check the amount of tokens that an owner allowed to a spender.
202    * @param owner address The address which owns the funds.
203    * @param spender address The address which will spend the funds.
204    * @return A uint256 specifying the amount of tokens still available for the spender.
205    */
206   function allowance(
207     address owner,
208     address spender
209    )
210     public
211     view
212     returns (uint256)
213   {
214     return _allowed[owner][spender];
215   }
216 
217   /**
218   * @dev Transfer token for a specified address
219   * @param to The address to transfer to.
220   * @param value The amount to be transferred.
221   */
222   function transfer(address to, uint256 value) public returns (bool) {
223     require(value <= _balances[msg.sender]);
224     require(to != address(0));
225 
226     _balances[msg.sender] = _balances[msg.sender].sub(value);
227     _balances[to] = _balances[to].add(value);
228     emit Transfer(msg.sender, to, value);
229     return true;
230   }
231 
232   /**
233    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
234    * Beware that changing an allowance with this method brings the risk that someone may use both the old
235    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
236    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
237    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
238    * @param spender The address which will spend the funds.
239    * @param value The amount of tokens to be spent.
240    */
241   function approve(address spender, uint256 value) public returns (bool) {
242     require(spender != address(0));
243 
244     _allowed[msg.sender][spender] = value;
245     emit Approval(msg.sender, spender, value);
246     return true;
247   }
248 
249   /**
250    * @dev Transfer tokens from one address to another
251    * @param from address The address which you want to send tokens from
252    * @param to address The address which you want to transfer to
253    * @param value uint256 the amount of tokens to be transferred
254    */
255   function transferFrom(
256     address from,
257     address to,
258     uint256 value
259   )
260     public
261     returns (bool)
262   {
263     require(value <= _balances[from]);
264     require(value <= _allowed[from][msg.sender]);
265     require(to != address(0));
266 
267     _balances[from] = _balances[from].sub(value);
268     _balances[to] = _balances[to].add(value);
269     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
270     emit Transfer(from, to, value);
271     return true;
272   }
273 
274   /**
275    * @dev Increase the amount of tokens that an owner allowed to a spender.
276    * approve should be called when allowed_[_spender] == 0. To increment
277    * allowed value is better to use this function to avoid 2 calls (and wait until
278    * the first transaction is mined)
279    * From MonolithDAO Token.sol
280    * @param spender The address which will spend the funds.
281    * @param addedValue The amount of tokens to increase the allowance by.
282    */
283   function increaseAllowance(
284     address spender,
285     uint256 addedValue
286   )
287     public
288     returns (bool)
289   {
290     require(spender != address(0));
291 
292     _allowed[msg.sender][spender] = (
293       _allowed[msg.sender][spender].add(addedValue));
294     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
295     return true;
296   }
297 
298   /**
299    * @dev Decrease the amount of tokens that an owner allowed to a spender.
300    * approve should be called when allowed_[_spender] == 0. To decrement
301    * allowed value is better to use this function to avoid 2 calls (and wait until
302    * the first transaction is mined)
303    * From MonolithDAO Token.sol
304    * @param spender The address which will spend the funds.
305    * @param subtractedValue The amount of tokens to decrease the allowance by.
306    */
307   function decreaseAllowance(
308     address spender,
309     uint256 subtractedValue
310   )
311     public
312     returns (bool)
313   {
314     require(spender != address(0));
315 
316     _allowed[msg.sender][spender] = (
317       _allowed[msg.sender][spender].sub(subtractedValue));
318     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
319     return true;
320   }
321 
322   /**
323    * @dev Internal function that burns an amount of the token of a given
324    * account.
325    * @param account The account whose tokens will be burnt.
326    * @param amount The amount that will be burnt.
327    */
328   function _burn(address account, uint256 amount) internal {
329     require(account != 0);
330     require(amount <= _balances[account]);
331 
332     _totalSupply = _totalSupply.sub(amount);
333     _balances[account] = _balances[account].sub(amount);
334     emit Transfer(account, address(0), amount);
335   }
336 
337   /**
338    * @dev Internal function that burns an amount of the token of a given
339    * account, deducting from the sender's allowance for said account. Uses the
340    * internal burn function.
341    * @param account The account whose tokens will be burnt.
342    * @param amount The amount that will be burnt.
343    */
344   function _burnFrom(address account, uint256 amount) internal {
345     require(amount <= _allowed[account][msg.sender]);
346 
347     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
348     // this function needs to emit an event with the updated approval.
349     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
350       amount);
351     _burn(account, amount);
352   }
353   function burn(address account, uint256 amount) public {
354     _burn(account, amount);
355   }
356 
357   function burnFrom(address account, uint256 amount) public {
358     _burnFrom(account, amount);
359   }
360 }