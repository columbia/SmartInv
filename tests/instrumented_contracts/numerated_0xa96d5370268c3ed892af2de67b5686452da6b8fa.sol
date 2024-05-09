1 /**
2  * ############################################################## 
3  * 
4  *  CFT2 ERC-20 Test Token
5  * 
6  * ##############################################################
7  */
8 
9 
10 pragma solidity ^0.5.0;
11 
12 /**
13  * @title Ownable
14  * @dev The Ownable contract has an owner address, and provides basic authorization control
15  * functions, this simplifies the implementation of "user permissions".
16  */
17 contract Ownable {
18     address private _owner;
19 
20     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21 
22     /**
23      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
24      * account.
25      */
26     constructor () internal {
27         _owner = msg.sender;
28         emit OwnershipTransferred(address(0), _owner);
29     }
30 
31     /**
32      * @return the address of the owner.
33      */
34     function owner() public view returns (address) {
35         return _owner;
36     }
37 
38     /**
39      * @dev Throws if called by any account other than the owner.
40      */
41     modifier onlyOwner() {
42         require(isOwner());
43         _;
44     }
45 
46     /**
47      * @return true if `msg.sender` is the owner of the contract.
48      */
49     function isOwner() public view returns (bool) {
50         return msg.sender == _owner;
51     }
52 
53     /**
54      * @dev Allows the current owner to relinquish control of the contract.
55      * @notice Renouncing to ownership will leave the contract without an owner.
56      * It will not be possible to call the functions with the `onlyOwner`
57      * modifier anymore.
58      */
59     function renounceOwnership() public onlyOwner {
60         emit OwnershipTransferred(_owner, address(0));
61         _owner = address(0);
62     }
63 
64     /**
65      * @dev Allows the current owner to transfer control of the contract to a newOwner.
66      * @param newOwner The address to transfer ownership to.
67      */
68     function transferOwnership(address newOwner) public onlyOwner {
69         _transferOwnership(newOwner);
70     }
71 
72     /**
73      * @dev Transfers control of the contract to a newOwner.
74      * @param newOwner The address to transfer ownership to.
75      */
76     function _transferOwnership(address newOwner) internal {
77         require(newOwner != address(0));
78         emit OwnershipTransferred(_owner, newOwner);
79         _owner = newOwner;
80     }
81 }
82 
83 
84 pragma solidity ^0.5.0;
85 
86 /**
87  * @title ERC20 interface
88  * @dev see https://github.com/ethereum/EIPs/issues/20
89  */
90 interface IERC20 {
91     function transfer(address to, uint256 value) external returns (bool);
92 
93     function approve(address spender, uint256 value) external returns (bool);
94 
95     function transferFrom(address from, address to, uint256 value) external returns (bool);
96 
97     function totalSupply() external view returns (uint256);
98 
99     function balanceOf(address who) external view returns (uint256);
100 
101     function allowance(address owner, address spender) external view returns (uint256);
102 
103     event Transfer(address indexed from, address indexed to, uint256 value);
104 
105     event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
107 
108 
109 pragma solidity ^0.5.0;
110 
111 /**
112  * @title SafeMath
113  * @dev Unsigned math operations with safety checks that revert on error
114  */
115 library SafeMath {
116     /**
117     * @dev Multiplies two unsigned integers, reverts on overflow.
118     */
119     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
120         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
121         // benefit is lost if 'b' is also tested.
122         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
123         if (a == 0) {
124             return 0;
125         }
126 
127         uint256 c = a * b;
128         require(c / a == b);
129 
130         return c;
131     }
132 
133     /**
134     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
135     */
136     function div(uint256 a, uint256 b) internal pure returns (uint256) {
137         // Solidity only automatically asserts when dividing by 0
138         require(b > 0);
139         uint256 c = a / b;
140         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
141 
142         return c;
143     }
144 
145     /**
146     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
147     */
148     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
149         require(b <= a);
150         uint256 c = a - b;
151 
152         return c;
153     }
154 
155     /**
156     * @dev Adds two unsigned integers, reverts on overflow.
157     */
158     function add(uint256 a, uint256 b) internal pure returns (uint256) {
159         uint256 c = a + b;
160         require(c >= a);
161 
162         return c;
163     }
164 
165     /**
166     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
167     * reverts when dividing by zero.
168     */
169     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
170         require(b != 0);
171         return a % b;
172     }
173 }
174 
175 
176 pragma solidity ^0.5.0;
177 
178 
179 /**
180  * @title Standard ERC20 token
181  *
182  * @dev Implementation of the basic standard token.
183  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
184  * Originally based on code by FirstBlood:
185  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
186  *
187  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
188  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
189  * compliant implementations may not do it.
190  */
191 contract ERC20 is IERC20 {
192     using SafeMath for uint256;
193 
194     mapping (address => uint256) private _balances;
195 
196     mapping (address => mapping (address => uint256)) private _allowed;
197 
198     uint256 private _totalSupply;
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
209     * @param owner The address to query the balance of.
210     * @return An uint256 representing the amount owned by the passed address.
211     */
212     function balanceOf(address owner) public view returns (uint256) {
213         return _balances[owner];
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
254      * @dev Transfer tokens from one address to another.
255      * Note that while this function emits an Approval event, this is not required as per the specification,
256      * and other compliant implementations may not emit the event.
257      * @param from address The address which you want to send tokens from
258      * @param to address The address which you want to transfer to
259      * @param value uint256 the amount of tokens to be transferred
260      */
261     function transferFrom(address from, address to, uint256 value) public returns (bool) {
262         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
263         _transfer(from, to, value);
264         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
265         return true;
266     }
267 
268     /**
269      * @dev Increase the amount of tokens that an owner allowed to a spender.
270      * approve should be called when allowed_[_spender] == 0. To increment
271      * allowed value is better to use this function to avoid 2 calls (and wait until
272      * the first transaction is mined)
273      * From MonolithDAO Token.sol
274      * Emits an Approval event.
275      * @param spender The address which will spend the funds.
276      * @param addedValue The amount of tokens to increase the allowance by.
277      */
278     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
279         require(spender != address(0));
280 
281         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
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
292      * Emits an Approval event.
293      * @param spender The address which will spend the funds.
294      * @param subtractedValue The amount of tokens to decrease the allowance by.
295      */
296     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
297         require(spender != address(0));
298 
299         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
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
311         require(to != address(0));
312 
313         _balances[from] = _balances[from].sub(value);
314         _balances[to] = _balances[to].add(value);
315         emit Transfer(from, to, value);
316     }
317 
318     /**
319      * @dev Internal function that mints an amount of the token and assigns it to
320      * an account. This encapsulates the modification of balances such that the
321      * proper events are emitted.
322      * @param account The account that will receive the created tokens.
323      * @param value The amount that will be created.
324      */
325     function _mint(address account, uint256 value) internal {
326         require(account != address(0));
327 
328         _totalSupply = _totalSupply.add(value);
329         _balances[account] = _balances[account].add(value);
330         emit Transfer(address(0), account, value);
331     }
332 
333     /**
334      * @dev Internal function that burns an amount of the token of a given
335      * account.
336      * @param account The account whose tokens will be burnt.
337      * @param value The amount that will be burnt.
338      */
339     function _burn(address account, uint256 value) internal {
340         require(account != address(0));
341 
342         _totalSupply = _totalSupply.sub(value);
343         _balances[account] = _balances[account].sub(value);
344         emit Transfer(account, address(0), value);
345     }
346 
347     /**
348      * @dev Internal function that burns an amount of the token of a given
349      * account, deducting from the sender's allowance for said account. Uses the
350      * internal burn function.
351      * Emits an Approval event (reflecting the reduced allowance).
352      * @param account The account whose tokens will be burnt.
353      * @param value The amount that will be burnt.
354      */
355     function _burnFrom(address account, uint256 value) internal {
356         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
357         _burn(account, value);
358         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
359     }
360 }
361 
362 
363 pragma solidity ^0.5.0;
364 
365 
366 /**
367  * @title ERC20Detailed token
368  * @dev The decimals are only for visualization purposes.
369  * All the operations are done using the smallest and indivisible token unit,
370  * just as on Ethereum all the operations are done in wei.
371  */
372 contract ERC20Detailed is IERC20 {
373     string private _name;
374     string private _symbol;
375     uint8 private _decimals;
376 
377     constructor (string memory name, string memory symbol, uint8 decimals) public {
378         _name = name;
379         _symbol = symbol;
380         _decimals = decimals;
381     }
382 
383     /**
384      * @return the name of the token.
385      */
386     function name() public view returns (string memory) {
387         return _name;
388     }
389 
390     /**
391      * @return the symbol of the token.
392      */
393     function symbol() public view returns (string memory) {
394         return _symbol;
395     }
396 
397     /**
398      * @return the number of decimals of the token.
399      */
400     function decimals() public view returns (uint8) {
401         return _decimals;
402     }
403 }
404 
405 
406 pragma solidity 0.5.0;
407 
408 
409 
410 contract CFTestToken2 is Ownable, ERC20, ERC20Detailed {
411 
412     // 21 Million tokens (with 18 decimals)
413     uint256 public constant TOTAL_TOKEN_AMOUNT = 21000000000000000000000000;
414     uint8 public constant DECIMALS = 18;
415     string public constant NAME = "CF Test 2";
416     string public constant SYMBOL = "CFTEST2";
417 
418     /**
419      * Constructor, mints all tokens to contract creator.
420      */
421     constructor()
422     public
423     ERC20Detailed(NAME, SYMBOL, DECIMALS) {
424         _mint(msg.sender, TOTAL_TOKEN_AMOUNT);
425     }
426 
427     function cleanup(address payable beneficiary)
428     public
429     onlyOwner {
430         selfdestruct(beneficiary);
431     }
432 
433 }