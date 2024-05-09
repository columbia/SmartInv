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
111     * @dev Total number of tokens in existence
112     */
113     function totalSupply() public view returns (uint256) {
114         return _totalSupply;
115     }
116 
117     /**
118     * @dev Gets the balance of the specified address.
119     * @param owner The address to query the balance of.
120     * @return An uint256 representing the amount owned by the passed address.
121     */
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
137     * @dev Transfer token for a specified address
138     * @param to The address to transfer to.
139     * @param value The amount to be transferred.
140     */
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
156         require(spender != address(0));
157 
158         _allowed[msg.sender][spender] = value;
159         emit Approval(msg.sender, spender, value);
160         return true;
161     }
162 
163     /**
164      * @dev Transfer tokens from one address to another.
165      * Note that while this function emits an Approval event, this is not required as per the specification,
166      * and other compliant implementations may not emit the event.
167      * @param from address The address which you want to send tokens from
168      * @param to address The address which you want to transfer to
169      * @param value uint256 the amount of tokens to be transferred
170      */
171     function transferFrom(address from, address to, uint256 value) public returns (bool) {
172         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
173         _transfer(from, to, value);
174         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
175         return true;
176     }
177 
178     /**
179      * @dev Increase the amount of tokens that an owner allowed to a spender.
180      * approve should be called when allowed_[_spender] == 0. To increment
181      * allowed value is better to use this function to avoid 2 calls (and wait until
182      * the first transaction is mined)
183      * From MonolithDAO Token.sol
184      * Emits an Approval event.
185      * @param spender The address which will spend the funds.
186      * @param addedValue The amount of tokens to increase the allowance by.
187      */
188     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
189         require(spender != address(0));
190 
191         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
192         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
193         return true;
194     }
195 
196     /**
197      * @dev Decrease the amount of tokens that an owner allowed to a spender.
198      * approve should be called when allowed_[_spender] == 0. To decrement
199      * allowed value is better to use this function to avoid 2 calls (and wait until
200      * the first transaction is mined)
201      * From MonolithDAO Token.sol
202      * Emits an Approval event.
203      * @param spender The address which will spend the funds.
204      * @param subtractedValue The amount of tokens to decrease the allowance by.
205      */
206     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
207         require(spender != address(0));
208 
209         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
210         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
211         return true;
212     }
213 
214     /**
215     * @dev Transfer token for a specified addresses
216     * @param from The address to transfer from.
217     * @param to The address to transfer to.
218     * @param value The amount to be transferred.
219     */
220     function _transfer(address from, address to, uint256 value) internal {
221         require(to != address(0));
222 
223         _balances[from] = _balances[from].sub(value);
224         _balances[to] = _balances[to].add(value);
225         emit Transfer(from, to, value);
226     }
227 
228     /**
229      * @dev Internal function that mints an amount of the token and assigns it to
230      * an account. This encapsulates the modification of balances such that the
231      * proper events are emitted.
232      * @param account The account that will receive the created tokens.
233      * @param value The amount that will be created.
234      */
235     function _mint(address account, uint256 value) internal {
236         require(account != address(0));
237 
238         _totalSupply = _totalSupply.add(value);
239         _balances[account] = _balances[account].add(value);
240         emit Transfer(address(0), account, value);
241     }
242 
243     /**
244      * @dev Internal function that burns an amount of the token of a given
245      * account.
246      * @param account The account whose tokens will be burnt.
247      * @param value The amount that will be burnt.
248      */
249     function _burn(address account, uint256 value) internal {
250         require(account != address(0));
251 
252         _totalSupply = _totalSupply.sub(value);
253         _balances[account] = _balances[account].sub(value);
254         emit Transfer(account, address(0), value);
255     }
256 
257     /**
258      * @dev Internal function that burns an amount of the token of a given
259      * account, deducting from the sender's allowance for said account. Uses the
260      * internal burn function.
261      * Emits an Approval event (reflecting the reduced allowance).
262      * @param account The account whose tokens will be burnt.
263      * @param value The amount that will be burnt.
264      */
265     function _burnFrom(address account, uint256 value) internal {
266         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
267         _burn(account, value);
268         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
269     }
270 }
271 
272 /**
273  * @title ERC20Detailed token
274  * @dev The decimals are only for visualization purposes.
275  * All the operations are done using the smallest and indivisible token unit,
276  * just as on Ethereum all the operations are done in wei.
277  */
278 contract ERC20Detailed is IERC20 {
279     string private _name;
280     string private _symbol;
281     uint8 private _decimals;
282 
283     constructor (string memory name, string memory symbol, uint8 decimals) public {
284         _name = name;
285         _symbol = symbol;
286         _decimals = decimals;
287     }
288 
289     /**
290      * @return the name of the token.
291      */
292     function name() public view returns (string memory) {
293         return _name;
294     }
295 
296     /**
297      * @return the symbol of the token.
298      */
299     function symbol() public view returns (string memory) {
300         return _symbol;
301     }
302 
303     /**
304      * @return the number of decimals of the token.
305      */
306     function decimals() public view returns (uint8) {
307         return _decimals;
308     }
309 }
310 
311 /**
312  * @title Ownable
313  * @dev The Ownable contract has an owner address, and provides basic authorization control
314  * functions, this simplifies the implementation of "user permissions".
315  */
316 contract Ownable {
317     address private _owner;
318 
319     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
320 
321     /**
322      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
323      * account.
324      */
325     constructor () internal {
326         _owner = msg.sender;
327         emit OwnershipTransferred(address(0), _owner);
328     }
329 
330     /**
331      * @return the address of the owner.
332      */
333     function owner() public view returns (address) {
334         return _owner;
335     }
336 
337     /**
338      * @dev Throws if called by any account other than the owner.
339      */
340     modifier onlyOwner() {
341         require(isOwner());
342         _;
343     }
344 
345     /**
346      * @return true if `msg.sender` is the owner of the contract.
347      */
348     function isOwner() public view returns (bool) {
349         return msg.sender == _owner;
350     }
351 
352     /**
353      * @dev Allows the current owner to relinquish control of the contract.
354      * @notice Renouncing to ownership will leave the contract without an owner.
355      * It will not be possible to call the functions with the `onlyOwner`
356      * modifier anymore.
357      */
358     function renounceOwnership() public onlyOwner {
359         emit OwnershipTransferred(_owner, address(0));
360         _owner = address(0);
361     }
362 
363     /**
364      * @dev Allows the current owner to transfer control of the contract to a newOwner.
365      * @param newOwner The address to transfer ownership to.
366      */
367     function transferOwnership(address newOwner) public onlyOwner {
368         _transferOwnership(newOwner);
369     }
370 
371     /**
372      * @dev Transfers control of the contract to a newOwner.
373      * @param newOwner The address to transfer ownership to.
374      */
375     function _transferOwnership(address newOwner) internal {
376         require(newOwner != address(0));
377         emit OwnershipTransferred(_owner, newOwner);
378         _owner = newOwner;
379     }
380 }
381 
382 /**
383  * @title VeloxToken
384  * @dev VeloxCoin is now the VeloxToken ERC20 token contract.
385  * This VeloxToken update removes staking in favor of lower gas fees and updates Solditiy to 0.5.0.
386  */
387 contract VeloxToken is ERC20, ERC20Detailed, Ownable {
388     uint8 public constant DECIMALS = 2;
389     uint256 public constant MAX_TOTAL_SUPPLY = 100 * (10 ** (6 + uint256(DECIMALS))); // 100 million tokens
390     bool public balancesInitialized = false;
391 
392     /**
393      * @dev Constructor that gives msg.sender all of existing tokens.
394      */
395     constructor () public ERC20Detailed("Velox", "VLX", DECIMALS) {
396         // Nothing happens here: balances will be set in initBalances
397     }
398     
399     /**
400      * @dev Function to init balances mapping on token launch
401      */
402     function initBalances(address[] calldata _accounts, uint64[] calldata _amounts) external onlyOwner {
403         require(!balancesInitialized);
404         require(_accounts.length > 0 && _accounts.length == _amounts.length);
405 
406         uint256 total = 0;
407         for (uint256 i = 0; i < _amounts.length; i++) total = total.add(uint256(_amounts[i]));
408         require(total <= MAX_TOTAL_SUPPLY);
409 
410         for (uint256 j = 0; j < _accounts.length; j++) _mint(_accounts[j], uint256(_amounts[j]));
411     }
412 
413     /**
414      * @dev Function to complete initialization of token balances after launch
415      */
416     function completeInitialization() external onlyOwner {
417         require(!balancesInitialized);
418         balancesInitialized = true;
419     }
420 
421     /**
422      * @dev Transfer tokens to multiple addresses
423      * @param _to The addresses to transfer to.
424      * @param _values The amounts to be transferred.
425      */
426     function batchTransfer(address[] memory _to, uint256[] memory _values) public returns (bool) {
427         require(_to.length == _values.length);
428         for (uint256 i = 0; i < _to.length; i++) require(transfer(_to[i], _values[i]));
429         return true;
430     }
431 }