1 pragma solidity ^0.4.24;
2 
3 // File: contracts/IERC20.sol
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 interface IERC20 {
10   function totalSupply() external view returns (uint256);
11 
12   function balanceOf(address who) external view returns (uint256);
13 
14   function allowance(address owner, address spender)
15     external view returns (uint256);
16 
17   function transfer(address to, uint256 value) external returns (bool);
18 
19   function approve(address spender, uint256 value)
20     external returns (bool);
21 
22   function transferFrom(address from, address to, uint256 value)
23     external returns (bool);
24 
25   event Transfer(
26     address indexed from,
27     address indexed to,
28     uint256 value
29   );
30 
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 // File: contracts/Ownable.sol
39 
40 /**
41  * @title Ownable
42  * @dev The Ownable contract has an owner address, and provides basic authorization control
43  * functions, this simplifies the implementation of "user permissions".
44  */
45 contract Ownable {
46   address private _owner;
47 
48   event OwnershipTransferred(
49     address indexed previousOwner,
50     address indexed newOwner
51   );
52 
53   /**
54    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
55    * account.
56    */
57   constructor() internal {
58     _owner = msg.sender;
59     emit OwnershipTransferred(address(0), _owner);
60   }
61 
62   /**
63    * @return the address of the owner.
64    */
65   function owner() public view returns(address) {
66     return _owner;
67   }
68 
69   /**
70    * @dev Throws if called by any account other than the owner.
71    */
72   modifier onlyOwner() {
73     require(isOwner());
74     _;
75   }
76 
77   /**
78    * @return true if `msg.sender` is the owner of the contract.
79    */
80   function isOwner() public view returns(bool) {
81     return msg.sender == _owner;
82   }
83 
84   /**
85    * @dev Allows the current owner to relinquish control of the contract.
86    * @notice Renouncing to ownership will leave the contract without an owner.
87    * It will not be possible to call the functions with the `onlyOwner`
88    * modifier anymore.
89    */
90   function renounceOwnership() public onlyOwner {
91     emit OwnershipTransferred(_owner, address(0));
92     _owner = address(0);
93   }
94 
95   /**
96    * @dev Allows the current owner to transfer control of the contract to a newOwner.
97    * @param newOwner The address to transfer ownership to.
98    */
99   function transferOwnership(address newOwner) public onlyOwner {
100     _transferOwnership(newOwner);
101   }
102 
103   /**
104    * @dev Transfers control of the contract to a newOwner.
105    * @param newOwner The address to transfer ownership to.
106    */
107   function _transferOwnership(address newOwner) internal {
108     require(newOwner != address(0));
109     emit OwnershipTransferred(_owner, newOwner);
110     _owner = newOwner;
111   }
112 }
113 
114 // File: contracts/SafeMath.sol
115 
116 /**
117  * @title SafeMath
118  * @dev Math operations with safety checks that revert on error
119  */
120 library SafeMath {
121 
122   /**
123   * @dev Multiplies two numbers, reverts on overflow.
124   */
125   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
126     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
127     // benefit is lost if 'b' is also tested.
128     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
129     if (a == 0) {
130       return 0;
131     }
132 
133     uint256 c = a * b;
134     require(c / a == b);
135 
136     return c;
137   }
138 
139   /**
140   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
141   */
142   function div(uint256 a, uint256 b) internal pure returns (uint256) {
143     require(b > 0); // Solidity only automatically asserts when dividing by 0
144     uint256 c = a / b;
145     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
146 
147     return c;
148   }
149 
150   /**
151   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
152   */
153   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
154     require(b <= a);
155     uint256 c = a - b;
156 
157     return c;
158   }
159 
160   /**
161   * @dev Adds two numbers, reverts on overflow.
162   */
163   function add(uint256 a, uint256 b) internal pure returns (uint256) {
164     uint256 c = a + b;
165     require(c >= a);
166 
167     return c;
168   }
169 
170   /**
171   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
172   * reverts when dividing by zero.
173   */
174   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
175     require(b != 0);
176     return a % b;
177   }
178 }
179 
180 // File: contracts/STMC.sol
181 
182 contract STMC is IERC20, Ownable {
183     using SafeMath for uint256;
184 
185     string public constant name = "Smart Tourism Matching Chain";
186     string public constant symbol = "STMC";
187     uint256 public constant decimals = 18;
188 
189     uint256 private constant _base1 = 10 ** decimals;
190     address private constant _holder = 0x81c0ebFcf9B75E93EaB96d735924b9aE43BCCb7f;
191 
192     mapping(address => uint256) private _balances;
193     mapping(address => mapping(address => uint256)) private _allowed;
194     uint256 private _totalSupply;
195 
196     constructor() public {
197         _mint(_holder, 80 * (10 ** 8) * _base1);
198     }
199 
200     /**
201     * @dev Total number of tokens in existence
202     */
203     function totalSupply() public view returns (uint256) {
204         return _totalSupply;
205     }
206 
207     /**
208     * @dev Gets the balance of the specified address.
209     * @param addr The address to query the balance of.
210     * @return An uint256 representing the amount owned by the passed address.
211     */
212     function balanceOf(address addr) public view returns (uint256) {
213         return _balances[addr];
214     }
215 
216     /**
217      * @dev Function to check the amount of tokens that an owner allowed to a spender.
218      * @param owner address The address which owns the funds.
219      * @param spender address The address which will spend the funds.
220      * @return A uint256 specifying the amount of tokens still available for the spender.
221      */
222     function allowance(address owner, address spender) public view returns (uint256) {
223         return _allowed[owner][spender];
224     }
225 
226     /**
227     * @dev Transfer token for a specified address
228     * @param to The address to transfer to.
229     * @param value The amount to be transferred.
230     */
231     function transfer(address to, uint256 value) public returns (bool) {
232         _transfer(msg.sender, to, value);
233         return true;
234     }
235 
236     /**
237      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
238      * Beware that changing an allowance with this method brings the risk that someone may use both the old
239      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
240      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
241      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
242      * @param spender The address which will spend the funds.
243      * @param value The amount of tokens to be spent.
244      */
245     function approve(address spender, uint256 value) public returns (bool) {
246         require(spender != address(0));
247 
248         _allowed[msg.sender][spender] = value;
249         emit Approval(msg.sender, spender, value);
250         return true;
251     }
252 
253     /**
254      * @dev Transfer tokens from one address to another
255      * @param from address The address which you want to send tokens from
256      * @param to address The address which you want to transfer to
257      * @param value uint256 the amount of tokens to be transferred
258      */
259     function transferFrom(address from, address to, uint256 value) public returns (bool)
260     {
261         require(value <= _allowed[from][msg.sender]);
262 
263         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
264         _transfer(from, to, value);
265         return true;
266     }
267 
268     /**
269      * @dev Increase the amount of tokens that an owner allowed to a spender.
270      * approve should be called when allowed_[_spender] == 0. To increment
271      * allowed value is better to use this function to avoid 2 calls (and wait until
272      * the first transaction is mined)
273      * From MonolithDAO Token.sol
274      * @param spender The address which will spend the funds.
275      * @param addedValue The amount of tokens to increase the allowance by.
276      */
277     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
278         require(spender != address(0));
279 
280         _allowed[msg.sender][spender] = (
281         _allowed[msg.sender][spender].add(addedValue));
282         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
283         return true;
284     }
285 
286     /**
287      * @dev Decrease the amount of tokens that an owner allowed to a spender.
288      * approve should be called when allowed_[_spender] == 0. To decrement
289      * allowed value is better to use this function to avoid 2 calls (and wait until
290      * the first transaction is mined)
291      * From MonolithDAO Token.sol
292      * @param spender The address which will spend the funds.
293      * @param subtractedValue The amount of tokens to decrease the allowance by.
294      */
295     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
296         require(spender != address(0));
297 
298         _allowed[msg.sender][spender] = (
299         _allowed[msg.sender][spender].sub(subtractedValue));
300         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
301         return true;
302     }
303 
304     /**
305     * @dev Transfer token for a specified addresses
306     * @param from The address to transfer from.
307     * @param to The address to transfer to.
308     * @param value The amount to be transferred.
309     */
310     function _transfer(address from, address to, uint256 value) internal {
311         require(value <= _balances[from]);
312         require(to != address(0));
313 
314         _balances[from] = _balances[from].sub(value);
315         _balances[to] = _balances[to].add(value);
316         emit Transfer(from, to, value);
317     }
318 
319     /**
320      * @dev Internal function that mints an amount of the token and assigns it to
321      * an account. This encapsulates the modification of balances such that the
322      * proper events are emitted.
323      * @param account The account that will receive the created tokens.
324      * @param value The amount that will be created.
325      */
326     function _mint(address account, uint256 value) internal {
327         require(account != 0);
328         _totalSupply = _totalSupply.add(value);
329         _balances[account] = _balances[account].add(value);
330         emit Transfer(address(0), account, value);
331     }
332 }