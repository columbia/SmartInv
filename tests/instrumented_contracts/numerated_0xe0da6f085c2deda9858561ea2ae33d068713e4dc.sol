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
162 contract ERC20 is IERC20, Ownable {
163   using SafeMath for uint256;
164 
165   mapping (address => uint256) public _balances;
166 
167   mapping (address => mapping (address => uint256)) private _allowed;
168 
169   uint256 public _totalSupply = 2000000000;
170 
171   /**
172   * @dev Total number of tokens in existence
173   */
174   function totalSupply() public view returns (uint256) {
175     return _totalSupply;
176   }
177 
178   /**
179   * @dev Gets the balance of the specified address.
180   * @param owner The address to query the the balance of.
181   * @return An uint256 representing the amount owned by the passed address.
182   */
183   function balanceOf(address owner) public view returns (uint256) {
184     return _balances[owner];
185   }
186 
187   /**
188    * @dev Function to check the amount of tokens that an owner allowed to a spender.
189    * @param owner address The address which owns the funds.
190    * @param spender address The address which will spend the funds.
191    * @return A uint256 specifying the amount of tokens still available for the spender.
192    */
193   function allowance(
194     address owner,
195     address spender
196    )
197     public
198     view
199     returns (uint256)
200   {
201     return _allowed[owner][spender];
202   }
203 
204   /**
205   * @dev Transfer token for a specified address
206   * @param to The address to transfer to.
207   * @param value The amount to be transferred.
208   */
209   function transfer(address to, uint256 value) public returns (bool) {
210     require(value <= _balances[msg.sender]);
211     require(to != address(0));
212 
213     _balances[msg.sender] = _balances[msg.sender].sub(value);
214     _balances[to] = _balances[to].add(value);
215     emit Transfer(msg.sender, to, value);
216     return true;
217   }
218 
219   /**
220    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
221    * Beware that changing an allowance with this method brings the risk that someone may use both the old
222    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
223    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
224    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
225    * @param spender The address which will spend the funds.
226    * @param value The amount of tokens to be spent.
227    */
228   function approve(address spender, uint256 value) public returns (bool) {
229     require(spender != address(0));
230 
231     _allowed[msg.sender][spender] = value;
232     emit Approval(msg.sender, spender, value);
233     return true;
234   }
235 
236   /**
237    * @dev Transfer tokens from one address to another
238    * @param from address The address which you want to send tokens from
239    * @param to address The address which you want to transfer to
240    * @param value uint256 the amount of tokens to be transferred
241    */
242   function transferFrom(
243     address from,
244     address to,
245     uint256 value
246   )
247     public
248     returns (bool)
249   {
250     require(value <= _balances[from]);
251     require(value <= _allowed[from][msg.sender]);
252     require(to != address(0));
253 
254     _balances[from] = _balances[from].sub(value);
255     _balances[to] = _balances[to].add(value);
256     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
257     emit Transfer(from, to, value);
258     return true;
259   }
260 
261   /**
262    * @dev Increase the amount of tokens that an owner allowed to a spender.
263    * approve should be called when allowed_[_spender] == 0. To increment
264    * allowed value is better to use this function to avoid 2 calls (and wait until
265    * the first transaction is mined)
266    * From MonolithDAO Token.sol
267    * @param spender The address which will spend the funds.
268    * @param addedValue The amount of tokens to increase the allowance by.
269    */
270   function increaseAllowance(
271     address spender,
272     uint256 addedValue
273   )
274     public
275     returns (bool)
276   {
277     require(spender != address(0));
278 
279     _allowed[msg.sender][spender] = (
280       _allowed[msg.sender][spender].add(addedValue));
281     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
282     return true;
283   }
284 
285   /**
286    * @dev Decrease the amount of tokens that an owner allowed to a spender.
287    * approve should be called when allowed_[_spender] == 0. To decrement
288    * allowed value is better to use this function to avoid 2 calls (and wait until
289    * the first transaction is mined)
290    * From MonolithDAO Token.sol
291    * @param spender The address which will spend the funds.
292    * @param subtractedValue The amount of tokens to decrease the allowance by.
293    */
294   function decreaseAllowance(
295     address spender,
296     uint256 subtractedValue
297   )
298     public
299     returns (bool)
300   {
301     require(spender != address(0));
302 
303     _allowed[msg.sender][spender] = (
304       _allowed[msg.sender][spender].sub(subtractedValue));
305     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
306     return true;
307   }
308 
309   /**
310    * @dev Internal function that burns an amount of the token of a given
311    * account.
312    * @param account The account whose tokens will be burnt.
313    * @param amount The amount that will be burnt.
314    */
315   function _burn(address account, uint256 amount) internal {
316     require(account != 0);
317     require(amount <= _balances[account]);
318 
319     _totalSupply = _totalSupply.sub(amount);
320     _balances[account] = _balances[account].sub(amount);
321     emit Transfer(account, address(0), amount);
322   }
323 
324   /**
325    * @dev Internal function that burns an amount of the token of a given
326    * account, deducting from the sender's allowance for said account. Uses the
327    * internal burn function.
328    * @param account The account whose tokens will be burnt.
329    * @param amount The amount that will be burnt.
330    */
331   function _burnFrom(address account, uint256 amount) internal {
332     require(amount <= _allowed[account][msg.sender]);
333 
334     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
335     // this function needs to emit an event with the updated approval.
336     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
337       amount);
338     _burn(account, amount);
339   }
340 }
341 
342 contract Sportie is ERC20 {
343   string public name;
344   string public symbol;
345 
346   constructor () public{
347         _balances[msg.sender] = _totalSupply;
348         name = "Sportie";
349         symbol = "SPTI";
350     }
351 
352   function burn(address account, uint256 amount) public {
353     _burn(account, amount);
354   }
355 
356   function burnFrom(address account, uint256 amount) public {
357     _burnFrom(account, amount);
358   }
359 
360 }