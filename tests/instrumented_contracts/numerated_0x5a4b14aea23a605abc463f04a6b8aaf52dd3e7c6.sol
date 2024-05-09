1 pragma solidity ^0.5.1;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8     function transfer(address to, uint256 value) external returns (bool);
9 
10     function approve(address spender, uint256 value) external returns (bool);
11 
12     function transferFrom(address from, address to, uint256 value) external returns (bool);
13 
14     function totalSupply() external view returns (uint256);
15 
16     function balanceOf(address who) external view returns (uint256);
17 
18     function allowance(address owner, address spender) external view returns (uint256);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 /**
26  * @title SafeMath
27  * @dev Unsigned math operations with safety checks that revert on error
28  */
29 library SafeMath {
30     /**
31      * @dev Multiplies two unsigned integers, reverts on overflow.
32      */
33     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
34         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
35         // benefit is lost if 'b' is also tested.
36         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
37         if (a == 0) {
38             return 0;
39         }
40 
41         uint256 c = a * b;
42         require(c / a == b);
43 
44         return c;
45     }
46 
47     /**
48      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
49      */
50     function div(uint256 a, uint256 b) internal pure returns (uint256) {
51         // Solidity only automatically asserts when dividing by 0
52         require(b > 0);
53         uint256 c = a / b;
54         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55 
56         return c;
57     }
58 
59     /**
60      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
61      */
62     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63         require(b <= a);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70      * @dev Adds two unsigned integers, reverts on overflow.
71      */
72     function add(uint256 a, uint256 b) internal pure returns (uint256) {
73         uint256 c = a + b;
74         require(c >= a);
75 
76         return c;
77     }
78 
79     /**
80      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
81      * reverts when dividing by zero.
82      */
83     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
84         require(b != 0);
85         return a % b;
86     }
87 }
88 
89 /**
90  * @title Standard ERC20 token
91  *
92  * @dev Implementation of the basic standard token.
93  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
94  * Originally based on code by FirstBlood:
95  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
96  *
97  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
98  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
99  * compliant implementations may not do it.
100  */
101 contract ERC20 is IERC20 {
102     using SafeMath for uint256;
103 
104     mapping (address => uint256) private _balances;
105 
106     mapping (address => mapping (address => uint256)) private _allowed;
107 
108     uint256 private _totalSupply;
109 
110     /**
111      * @dev Total number of tokens in existence
112      */
113     function totalSupply() public view returns (uint256) {
114         return _totalSupply;
115     }
116 
117     /**
118      * @dev Gets the balance of the specified address.
119      * @param owner The address to query the balance of.
120      * @return An uint256 representing the amount owned by the passed address.
121      */
122     function balanceOf(address owner) public view returns (uint256) {
123         return _balances[owner];
124     }
125 
126     /**
127      * @dev Function to check the amount of tokens that an owner allowed to a spender.
128      * @param owner address The address which owns the funds.
129      * @param spender address The address which will spend the funds.
130      * @return A uint256 specifying the amount of tokens still available for the spender.
131      */
132     function allowance(address owner, address spender) public view returns (uint256) {
133         return _allowed[owner][spender];
134     }
135 
136     /**
137      * @dev Transfer token for a specified address
138      * @param to The address to transfer to.
139      * @param value The amount to be transferred.
140      */
141     function transfer(address to, uint256 value) public returns (bool) {
142         _transfer(msg.sender, to, value);
143         return true;
144     }
145 
146     /**
147      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
148      * Beware that changing an allowance with this method brings the risk that someone may use both the old
149      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
150      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
151      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
152      * @param spender The address which will spend the funds.
153      * @param value The amount of tokens to be spent.
154      */
155     function approve(address spender, uint256 value) public returns (bool) {
156         _approve(msg.sender, spender, value);
157         return true;
158     }
159 
160     /**
161      * @dev Transfer tokens from one address to another.
162      * Note that while this function emits an Approval event, this is not required as per the specification,
163      * and other compliant implementations may not emit the event.
164      * @param from address The address which you want to send tokens from
165      * @param to address The address which you want to transfer to
166      * @param value uint256 the amount of tokens to be transferred
167      */
168     function transferFrom(address from, address to, uint256 value) public returns (bool) {
169         _transfer(from, to, value);
170         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
171         return true;
172     }
173 
174     /**
175      * @dev Increase the amount of tokens that an owner allowed to a spender.
176      * approve should be called when allowed_[_spender] == 0. To increment
177      * allowed value is better to use this function to avoid 2 calls (and wait until
178      * the first transaction is mined)
179      * From MonolithDAO Token.sol
180      * Emits an Approval event.
181      * @param spender The address which will spend the funds.
182      * @param addedValue The amount of tokens to increase the allowance by.
183      */
184     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
185         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
186         return true;
187     }
188 
189     /**
190      * @dev Decrease the amount of tokens that an owner allowed to a spender.
191      * approve should be called when allowed_[_spender] == 0. To decrement
192      * allowed value is better to use this function to avoid 2 calls (and wait until
193      * the first transaction is mined)
194      * From MonolithDAO Token.sol
195      * Emits an Approval event.
196      * @param spender The address which will spend the funds.
197      * @param subtractedValue The amount of tokens to decrease the allowance by.
198      */
199     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
200         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
201         return true;
202     }
203 
204     /**
205      * @dev Transfer token for a specified addresses
206      * @param from The address to transfer from.
207      * @param to The address to transfer to.
208      * @param value The amount to be transferred.
209      */
210     function _transfer(address from, address to, uint256 value) internal {
211         require(to != address(0));
212 
213         _balances[from] = _balances[from].sub(value);
214         _balances[to] = _balances[to].add(value);
215         emit Transfer(from, to, value);
216     }
217 
218     /**
219      * @dev Internal function that mints an amount of the token and assigns it to
220      * an account. This encapsulates the modification of balances such that the
221      * proper events are emitted.
222      * @param account The account that will receive the created tokens.
223      * @param value The amount that will be created.
224      */
225     function _mint(address account, uint256 value) internal {
226         require(account != address(0));
227 
228         _totalSupply = _totalSupply.add(value);
229         _balances[account] = _balances[account].add(value);
230         emit Transfer(address(0), account, value);
231     }
232 
233     /**
234      * @dev Internal function that burns an amount of the token of a given
235      * account.
236      * @param account The account whose tokens will be burnt.
237      * @param value The amount that will be burnt.
238      */
239     function _burn(address account, uint256 value) internal {
240         require(account != address(0));
241 
242         _totalSupply = _totalSupply.sub(value);
243         _balances[account] = _balances[account].sub(value);
244         emit Transfer(account, address(0), value);
245     }
246 
247     /**
248      * @dev Approve an address to spend another addresses' tokens.
249      * @param owner The address that owns the tokens.
250      * @param spender The address that will spend the tokens.
251      * @param value The number of tokens that can be spent.
252      */
253     function _approve(address owner, address spender, uint256 value) internal {
254         require(spender != address(0));
255         require(owner != address(0));
256 
257         _allowed[owner][spender] = value;
258         emit Approval(owner, spender, value);
259     }
260 
261     /**
262      * @dev Internal function that burns an amount of the token of a given
263      * account, deducting from the sender's allowance for said account. Uses the
264      * internal burn function.
265      * Emits an Approval event (reflecting the reduced allowance).
266      * @param account The account whose tokens will be burnt.
267      * @param value The amount that will be burnt.
268      */
269     function _burnFrom(address account, uint256 value) internal {
270         _burn(account, value);
271         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
272     }
273 }
274 
275 /**
276  * @title Ownable
277  * @dev The Ownable contract has an owner address, and provides basic authorization control
278  * functions, this simplifies the implementation of "user permissions".
279  */
280 contract Ownable {
281     address private _owner;
282 
283     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
284 
285     /**
286      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
287      * account.
288      */
289     constructor () internal {
290         _owner = msg.sender;
291         emit OwnershipTransferred(address(0), _owner);
292     }
293 
294     /**
295      * @return the address of the owner.
296      */
297     function owner() public view returns (address) {
298         return _owner;
299     }
300 
301     /**
302      * @dev Throws if called by any account other than the owner.
303      */
304     modifier onlyOwner() {
305         require(isOwner());
306         _;
307     }
308 
309     /**
310      * @return true if `msg.sender` is the owner of the contract.
311      */
312     function isOwner() public view returns (bool) {
313         return msg.sender == _owner;
314     }
315 
316     /**
317      * @dev Allows the current owner to relinquish control of the contract.
318      * @notice Renouncing to ownership will leave the contract without an owner.
319      * It will not be possible to call the functions with the `onlyOwner`
320      * modifier anymore.
321      */
322     function renounceOwnership() public onlyOwner {
323         emit OwnershipTransferred(_owner, address(0));
324         _owner = address(0);
325     }
326 
327     /**
328      * @dev Allows the current owner to transfer control of the contract to a newOwner.
329      * @param newOwner The address to transfer ownership to.
330      */
331     function transferOwnership(address newOwner) public onlyOwner {
332         _transferOwnership(newOwner);
333     }
334 
335     /**
336      * @dev Transfers control of the contract to a newOwner.
337      * @param newOwner The address to transfer ownership to.
338      */
339     function _transferOwnership(address newOwner) internal {
340         require(newOwner != address(0));
341         emit OwnershipTransferred(_owner, newOwner);
342         _owner = newOwner;
343     }
344 }
345 
346 contract HeartBout is ERC20, Ownable {
347   string public constant name = "HeartBout HP";
348   string public constant symbol = "HP";
349   uint32 public constant decimals = 18;
350 
351   uint256 public totalAmount = uint256(1e10).mul(1 ether); // 10 billions
352   
353   /**
354   * @param newOwner Address of the contract owner
355   */
356   constructor(address newOwner) public {
357     require(newOwner != address(0));
358     transferOwnership(newOwner);
359     _mint(newOwner, totalAmount);
360   }
361 }