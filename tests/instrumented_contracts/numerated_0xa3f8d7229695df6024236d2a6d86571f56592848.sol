1 // File: contracts/lib/SafeMath.sol
2 
3 pragma solidity ^0.4.26;
4 
5 /**
6  * @title SafeMath
7  * @dev Unsigned math operations with safety checks that revert on error
8  */
9 library SafeMath {
10     /**
11     * @dev Multiplies two unsigned integers, reverts on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         uint256 c = a * b;
22         require(c / a == b);
23 
24         return c;
25     }
26 
27     /**
28     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
29     */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // Solidity only automatically asserts when dividing by 0
32         require(b > 0);
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41     */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50     * @dev Adds two unsigned integers, reverts on overflow.
51     */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
61     * reverts when dividing by zero.
62     */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 // File: contracts/IERC20.sol
70 
71 pragma solidity ^0.4.26;
72 
73 /**
74  * @title ERC20 interface
75  * @dev see https://github.com/ethereum/EIPs/issues/20
76  */
77 interface IERC20 {
78   function totalSupply() external view returns (uint256);
79 
80   function balanceOf(address who) external view returns (uint256);
81 
82   function allowance(address owner, address spender)
83     external view returns (uint256);
84 
85   function transfer(address to, uint256 value) external returns (bool);
86 
87   function approve(address spender, uint256 value)
88     external returns (bool);
89 
90   function transferFrom(address from, address to, uint256 value)
91     external returns (bool);
92 
93   event Transfer(
94     address indexed from,
95     address indexed to,
96     uint256 value
97   );
98 
99   event Approval(
100     address indexed owner,
101     address indexed spender,
102     uint256 value
103   );
104 }
105 
106 // File: contracts/MiningBankToken.sol
107 
108 pragma solidity ^0.4.26;
109 
110 
111 
112 contract Ownable {
113   address private _owner;
114 
115   event OwnershipTransferred(
116     address indexed previousOwner,
117     address indexed newOwner
118   );
119 
120   constructor() internal {
121     _owner = msg.sender;
122     emit OwnershipTransferred(address(0), _owner);
123   }
124 
125   function owner() public view returns(address) {
126     return _owner;
127   }
128 
129   /**
130    * @dev Throws if called by any account other than the owner.
131    */
132   modifier onlyOwner() {
133     require(isOwner(), "Permission denied");
134     _;
135   }
136 
137   /**
138    * @return true if `msg.sender` is the owner of the contract.
139    */
140   function isOwner() public view returns(bool) {
141     return msg.sender == _owner;
142   }
143 
144   function transferOwnership(address newOwner) public onlyOwner {
145     _transferOwnership(newOwner);
146   }
147 
148   /**
149    * @dev Transfers control of the contract to a newOwner.
150    * @param newOwner The address to transfer ownership to.
151    */
152   function _transferOwnership(address newOwner) internal {
153     require(newOwner != address(0));
154     emit OwnershipTransferred(_owner, newOwner);
155     _owner = newOwner;
156   }
157 }
158 
159 contract MiningBankToken is IERC20, Ownable {
160   using SafeMath for uint;
161 
162   mapping (address => uint) private _balances;
163   mapping (address => mapping (address => uint)) private _allowed;
164 
165   string public constant name = "Mining Bank";
166   string public constant symbol = "MGB";
167   uint256 public constant decimals = 18;
168   uint256 private _totalSupply = 100*10**8 * 10**(decimals);
169 
170   constructor() public {
171     _balances[msg.sender] = _totalSupply;
172     emit Transfer(address(0), msg.sender, _totalSupply);
173   }
174 
175   function totalSupply() public view returns (uint) {
176     return _totalSupply;
177   }
178 
179   function balanceOf(address _who) public view returns (uint) {
180     return _balances[_who];
181   }
182 
183   /**
184    * @dev Function to check the amount of tokens that an owner allowed to a spender.
185    * @param owner address The address which owns the funds.
186    * @param spender address The address which will spend the funds.
187    * @return A uint specifying the amount of tokens still available for the spender.
188    */
189   function allowance(
190     address owner,
191     address spender
192    )
193     public
194     view
195     returns (uint)
196   {
197     return _allowed[owner][spender];
198   }
199 
200   /**
201   * @dev Transfer token for a specified address
202   * @param to The address to transfer to.
203   * @param value The amount to be transferred.
204   */
205   function transfer(address to, uint value) public stoppable personalStoppable(msg.sender) returns (bool) {
206     _transfer(msg.sender, to, value);
207     return true;
208   }
209 
210   function approve(address spender, uint value) public stoppable personalStoppable(msg.sender) returns (bool) {
211     require(spender != address(0));
212 
213     _allowed[msg.sender][spender] = value;
214     emit Approval(msg.sender, spender, value);
215     return true;
216   }
217 
218   function transferFrom(
219     address from,
220     address to,
221     uint value
222   )
223     public stoppable personalStoppable(from) returns (bool)
224   {
225     require(value <= _allowed[from][msg.sender]);
226 
227     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
228     _transfer(from, to, value);
229     return true;
230   }
231 
232   /**
233    * @dev Increase the amount of tokens that an owner allowed to a spender.
234    * approve should be called when allowed_[_spender] == 0. To increment
235    * allowed value is better to use this function to avoid 2 calls (and wait until
236    * the first transaction is mined)
237    * From MonolithDAO Token.sol
238    * @param spender The address which will spend the funds.
239    * @param addedValue The amount of tokens to increase the allowance by.
240    */
241   function increaseAllowance(
242     address spender,
243     uint addedValue
244   )
245     public
246     returns (bool)
247   {
248     require(spender != address(0));
249 
250     _allowed[msg.sender][spender] = (
251     _allowed[msg.sender][spender].add(addedValue));
252     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
253     return true;
254   }
255 
256   /**
257    * @dev Decrease the amount of tokens that an owner allowed to a spender.
258    * approve should be called when allowed_[_spender] == 0. To decrement
259    * allowed value is better to use this function to avoid 2 calls (and wait until
260    * the first transaction is mined)
261    * From MonolithDAO Token.sol
262    * @param spender The address which will spend the funds.
263    * @param subtractedValue The amount of tokens to decrease the allowance by.
264    */
265   function decreaseAllowance(
266     address spender,
267     uint subtractedValue
268   )
269     public
270     returns (bool)
271   {
272     require(spender != address(0));
273 
274     _allowed[msg.sender][spender] = (
275       _allowed[msg.sender][spender].sub(subtractedValue));
276     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
277     return true;
278   }
279 
280   /**
281   * @dev Transfer token for a specified addresses
282   * @param from The address to transfer from.
283   * @param to The address to transfer to.
284   * @param value The amount to be transferred.
285   */
286   function _transfer(address from, address to, uint value) internal {
287     require(value <= _balances[from]);
288     require(to != address(0));
289 
290     _balances[from] = _balances[from].sub(value);
291     _balances[to] = _balances[to].add(value);
292     emit Transfer(from, to, value);
293   }
294 
295   bool public stopped = true; // 全局转账开关
296   mapping(address => bool) personalStopped; // 个人是否可以转账
297   // address[] personalStoppedList; // 不能转账的人员清单
298 
299   modifier stoppable {
300     require(!stopped, "transfer stopped");
301     _;
302   }
303 
304   modifier personalStoppable(address _who) {
305     require(!personalStopped[_who], "personal transfer stopped");
306     _;
307   }
308 
309   function start() public onlyOwner {
310     stopped = false;
311   }
312 
313   function stop() public onlyOwner {
314     stopped = true;
315   }
316 
317   // 加入黑名单
318   function setPersonalStart(address _who) public onlyOwner returns (bool) {
319     personalStopped[_who] = false;
320 
321     return true;
322   }
323 
324   // 移除黑名单
325   function setPersonalStop(address _who) public onlyOwner returns (bool) {
326     personalStopped[_who] = true;
327     return true;
328   }
329 
330   // 设置多人不能转账
331   function setPeopleTransferStop(address[] _whos) onlyOwner public returns (bool){ //不能判断元素是否相同
332     require(_whos.length > 0, "address length >0");
333     require(_whos.length < 101, "address length <101");
334 
335     for (uint i = 0; i < _whos.length; i++){
336       personalStopped[_whos[i]] = true;
337     }
338 
339     return true;
340   }
341 
342   // 设置多人可以转账
343   function setPeopleTransferStart(address[] _whos) onlyOwner public returns (bool){ //不能判断元素是否相同
344     require(_whos.length > 0, "address length >0");
345     require(_whos.length < 101, "address length <101");
346 
347     for (uint i = 0; i < _whos.length; i++){
348       personalStopped[_whos[i]] = false;
349     }
350 
351     return true;
352   }
353 
354   // 获得个人的转账状态
355   function getPersonalTransferState(address _who) onlyOwner public view returns(bool) {
356     return personalStopped[_who];
357   }
358 
359 }