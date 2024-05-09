1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9     * @dev Multiplies two unsigned integers, reverts on overflow.
10     */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27     */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39     */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48     * @dev Adds two unsigned integers, reverts on overflow.
49     */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59     * reverts when dividing by zero.
60     */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 /**
68  * @title ERC20 interface
69  * @dev see https://github.com/ethereum/EIPs/issues/20
70  */
71 interface IERC20 {
72     function transfer(address to, uint256 value) external returns (bool);
73 
74     function approve(address spender, uint256 value) external returns (bool);
75 
76     function transferFrom(address from, address to, uint256 value) external returns (bool);
77 
78     function totalSupply() external view returns (uint256);
79 
80     function balanceOf(address who) external view returns (uint256);
81 
82     function allowance(address owner, address spender) external view returns (uint256);
83 
84     event Transfer(address indexed from, address indexed to, uint256 value);
85 
86     event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 /**
90  * @title ERC20Detailed token
91  * @dev The decimals are only for visualization purposes.
92  * All the operations are done using the smallest and indivisible token unit,
93  * just as on Ethereum all the operations are done in wei.
94  */
95 contract ERC20Detailed is IERC20 {
96     string private _name;
97     string private _symbol;
98     uint8 private _decimals;
99 
100     constructor (string memory name, string memory symbol, uint8 decimals) public {
101         _name = name;
102         _symbol = symbol;
103         _decimals = decimals;
104     }
105 
106     /**
107      * @return the name of the token.
108      */
109     function name() public view returns (string memory) {
110         return _name;
111     }
112 
113     /**
114      * @return the symbol of the token.
115      */
116     function symbol() public view returns (string memory) {
117         return _symbol;
118     }
119 
120     /**
121      * @return the number of decimals of the token.
122      */
123     function decimals() public view returns (uint8) {
124         return _decimals;
125     }
126 }
127 
128 /**
129  * @title Ownable
130  * @dev The Ownable contract has an owner address, and provides basic authorization control
131  * functions, this simplifies the implementation of "user permissions".
132  */
133 contract Ownable {
134     address private _owner;
135 
136     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
137 
138     /**
139      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
140      * account.
141      */
142     constructor () internal {
143         _owner = msg.sender;
144         emit OwnershipTransferred(address(0), _owner);
145     }
146 
147     /**
148      * @return the address of the owner.
149      */
150     function owner() public view returns (address) {
151         return _owner;
152     }
153 
154     /**
155      * @dev Throws if called by any account other than the owner.
156      */
157     modifier onlyOwner() {
158         require(isOwner());
159         _;
160     }
161 
162     /**
163      * @return true if `msg.sender` is the owner of the contract.
164      */
165     function isOwner() public view returns (bool) {
166         return msg.sender == _owner;
167     }
168 
169     /**
170      * @dev Allows the current owner to relinquish control of the contract.
171      * @notice Renouncing to ownership will leave the contract without an owner.
172      * It will not be possible to call the functions with the `onlyOwner`
173      * modifier anymore.
174      */
175     function renounceOwnership() public onlyOwner {
176         emit OwnershipTransferred(_owner, address(0));
177         _owner = address(0);
178     }
179 
180     /**
181      * @dev Allows the current owner to transfer control of the contract to a newOwner.
182      * @param newOwner The address to transfer ownership to.
183      */
184     function transferOwnership(address newOwner) public onlyOwner {
185         _transferOwnership(newOwner);
186     }
187 
188     /**
189      * @dev Transfers control of the contract to a newOwner.
190      * @param newOwner The address to transfer ownership to.
191      */
192     function _transferOwnership(address newOwner) internal {
193         require(newOwner != address(0));
194         emit OwnershipTransferred(_owner, newOwner);
195         _owner = newOwner;
196     }
197 }
198 
199 contract TwogapERC20 is IERC20, Ownable {
200 
201     using SafeMath for uint256;
202 
203     mapping (address => uint256) private bounties;
204     //2019-02-27 00:00:00 AM UTC
205     uint256 bountyLockTime3Month = 1556280000;
206     uint256 bountyLockTime6Month = 1564142400;
207     uint256 bountyLockTime12Month = 1580040000;
208 
209     mapping (address => uint256) private _balances;
210 
211     mapping (address => mapping (address => uint256)) private _allowed;
212 
213     uint256 private _totalSupply;
214 
215     function bountyWithdraw(address to, uint256 value) public onlyOwner returns (bool) {
216         withdraw(to, value);
217         bounties[to] = value;
218         return true;
219     }
220 
221     function withdraw(address to, uint256 value) public onlyOwner returns (bool) {
222         require(to != address(0));
223         address _from = owner();
224         _balances[_from] = _balances[_from].sub(value);
225         _balances[to] = _balances[to].add(value);
226         emit Transfer(_from, to, value);
227         return true;
228     }
229 
230     /**
231     * @dev Total number of tokens in existence
232     */
233     function totalSupply() public view returns (uint256) {
234         return _totalSupply;
235     }
236 
237     /**
238     * @dev Gets the balance of the specified address.
239     * @param owner The address to query the balance of.
240     * @return An uint256 representing the amount owned by the passed address.
241     */
242     function balanceOf(address owner) public view returns (uint256) {
243         return _balances[owner];
244     }
245 
246     /**
247      * @dev Function to check the amount of tokens that an owner allowed to a spender.
248      * @param owner address The address which owns the funds.
249      * @param spender address The address which will spend the funds.
250      * @return A uint256 specifying the amount of tokens still available for the spender.
251      */
252     function allowance(address owner, address spender) public view returns (uint256) {
253         return _allowed[owner][spender];
254     }
255 
256     /**
257     * @dev Transfer token for a specified address
258     * @param to The address to transfer to.
259     * @param value The amount to be transferred.
260     */
261     function transfer(address to, uint256 value) public returns (bool) {
262         _transfer(msg.sender, to, value);
263         return true;
264     }
265 
266     /**
267      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
268      * Beware that changing an allowance with this method brings the risk that someone may use both the old
269      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
270      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
271      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
272      * @param spender The address which will spend the funds.
273      * @param value The amount of tokens to be spent.
274      */
275     function approve(address spender, uint256 value) public returns (bool) {
276         require(spender != address(0));
277 
278         _allowed[msg.sender][spender] = value;
279         emit Approval(msg.sender, spender, value);
280         return true;
281     }
282 
283     /**
284      * @dev Transfer tokens from one address to another.
285      * Note that while this function emits an Approval event, this is not required as per the specification,
286      * and other compliant implementations may not emit the event.
287      * @param from address The address which you want to send tokens from
288      * @param to address The address which you want to transfer to
289      * @param value uint256 the amount of tokens to be transferred
290      */
291     function transferFrom(address from, address to, uint256 value) public returns (bool) {
292         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
293         _transfer(from, to, value);
294         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
295         return true;
296     }
297 
298     /**
299      * @dev Increase the amount of tokens that an owner allowed to a spender.
300      * approve should be called when allowed_[_spender] == 0. To increment
301      * allowed value is better to use this function to avoid 2 calls (and wait until
302      * the first transaction is mined)
303      * From MonolithDAO Token.sol
304      * Emits an Approval event.
305      * @param spender The address which will spend the funds.
306      * @param addedValue The amount of tokens to increase the allowance by.
307      */
308     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
309         require(spender != address(0));
310 
311         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
312         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
313         return true;
314     }
315 
316     /**
317      * @dev Decrease the amount of tokens that an owner allowed to a spender.
318      * approve should be called when allowed_[_spender] == 0. To decrement
319      * allowed value is better to use this function to avoid 2 calls (and wait until
320      * the first transaction is mined)
321      * From MonolithDAO Token.sol
322      * Emits an Approval event.
323      * @param spender The address which will spend the funds.
324      * @param subtractedValue The amount of tokens to decrease the allowance by.
325      */
326     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
327         require(spender != address(0));
328 
329         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
330         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
331         return true;
332     }
333 
334     /**
335     * @dev Transfer token for a specified addresses
336     * @param from The address to transfer from.
337     * @param to The address to transfer to.
338     * @param value The amount to be transferred.
339     */
340     function _transfer(address from, address to, uint256 value) internal {
341         require(to != address(0));
342         if (block.timestamp < bountyLockTime3Month) {
343             require(_balances[from].sub(value) >= bounties[from]);
344         } else if(block.timestamp < bountyLockTime6Month) {
345             require(_balances[from].sub(value) >= (bounties[from] * 9 / 10));
346         } else if(block.timestamp < bountyLockTime12Month) {
347             require(_balances[from].sub(value) >= (bounties[from] * 6 / 10));
348         }
349         _balances[from] = _balances[from].sub(value);
350         _balances[to] = _balances[to].add(value);
351         emit Transfer(from, to, value);
352     }
353 
354     /**
355      * @dev Internal function that mints an amount of the token and assigns it to
356      * an account. This encapsulates the modification of balances such that the
357      * proper events are emitted.
358      * @param account The account that will receive the created tokens.
359      * @param value The amount that will be created.
360      */
361     function _mint(address account, uint256 value) internal {
362         require(account != address(0));
363 
364         _totalSupply = _totalSupply.add(value);
365         _balances[account] = _balances[account].add(value);
366         emit Transfer(address(0), account, value);
367     }
368 
369     /**
370      * @dev Internal function that burns an amount of the token of a given
371      * account.
372      * @param account The account whose tokens will be burnt.
373      * @param value The amount that will be burnt.
374      */
375     function _burn(address account, uint256 value) internal {
376         require(account != address(0));
377 
378         _totalSupply = _totalSupply.sub(value);
379         _balances[account] = _balances[account].sub(value);
380         emit Transfer(account, address(0), value);
381     }
382 
383     /**
384      * @dev Internal function that burns an amount of the token of a given
385      * account, deducting from the sender's allowance for said account. Uses the
386      * internal burn function.
387      * Emits an Approval event (reflecting the reduced allowance).
388      * @param account The account whose tokens will be burnt.
389      * @param value The amount that will be burnt.
390      */
391     function _burnFrom(address account, uint256 value) internal {
392         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
393         _burn(account, value);
394         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
395     }
396 }
397 
398 contract TwogapContract is TwogapERC20, ERC20Detailed {
399 
400     uint8 public constant DECIMALS = 18;
401     uint256 public constant INITIAL_SUPPLY = 210 * 10**9 * (10 ** uint256(DECIMALS));
402 
403     /**
404      * @dev Constructor that gives msg.sender all of existing tokens.
405      */
406     constructor () public ERC20Detailed("Twogap Token", "TGT", DECIMALS) {
407         _mint(msg.sender, INITIAL_SUPPLY);
408     }
409 }